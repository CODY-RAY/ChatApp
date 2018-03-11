//
//  ChatViewController.swift
//  ChatApp
//
//  Created by cody's macbook on 10/28/17.
//  Copyright © 2017 crank llc. All rights reserved.
//

import UIKit
import SwiftyJSON
import Starscream

class ChatViewController: UIViewController,UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet weak var messCollection: MessagesView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var usersLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var toolbarConstraint: NSLayoutConstraint!
    var users = JSON()
    static var chats = JSON()
    var socket = {
        return WebSocket(url: URL(string: "ws://\(AppDelegate.local):8080/message")!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
        usersTableView.delegate = self
        usersTableView.dataSource = self
        textField.delegate = self
        self.messCollection.reloadData()
        
        socket.request.addValue("Bearer \(AppDelegate.token)" , forHTTPHeaderField: "Authorization")
        
        socket.onConnect = {
            print("websocket is connected")
        }
        
        //websocketDidReceiveMessage
        socket.onText = { (text: String) in
            print("got some text: \(text)")
        }
        //websocketDidReceiveData
        socket.onData = { (data: Data) in
            print("got some data: \(data.count)")
        }
        
        socket.connect()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
 
   
    @IBAction func send(_ sender: UIButton) {
        
        socket.write(string: textField.text!)
    }
    @IBAction func upTextChanged(_ sender: UITextField) {
        if sender.text == " "{
            sender.text = ""
        }
        if sender.text != "" {
        
        usersTableView.isHidden = false
        let url = URL(string: "http://\(AppDelegate.web):8080/users?search=\(sender.text ?? "" )")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(AppDelegate.token)" , forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                
            }
            
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                
                DispatchQueue.main.async  {
                    self.users = JSON(data: data)
                    self.usersTableView.reloadData()
                  self.messCollection.reloadData()
                }
                
            }
            
        }
        task.resume()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
      
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let x = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
            
            UIView.animate(withDuration: x){
                self.toolbarConstraint.constant = -keyboardHeight
            }
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        
      //  if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
           // let keyboardRectangle = keyboardFrame.cgRectValue
            //let keyboardHeight = keyboardRectangle.height
            let x = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
            
            UIView.animate(withDuration: x){
                self.toolbarConstraint.constant = 0
            }
        //}
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let row = indexPath.row
        usersLabel.text = users.array![row].string!
        usersLabel.isHidden = false
        tableView.isHidden = true
        topToolBar.isHidden = true
        toolbar.isHidden = false
        messCollection.isHidden = false
        self.messCollection.reloadData()
        view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath)
        var subview = cell.subviews.first?.subviews
        let otherUser = subview![0] as! UILabel
        otherUser.text = users.array![indexPath.item].string!
        return cell
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
