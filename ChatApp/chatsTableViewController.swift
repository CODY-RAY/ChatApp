//
//  ChatsTableViewController.swift
//  ChatApp
//
//  Created by cody's macbook on 11/3/17.
//  Copyright © 2017 crank llc. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var NavBar: UINavigationBar!
    var me = JSON()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        let url = URL(string: "http://\(AppDelegate.web):8080/me")!
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
                    self.me = JSON(data: data)
                   // self.tableView.reloadData()
                }
                
            }
            
        }
        task.resume()
        getChats()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var x = 0
        if !ChatViewController.chats.isEmpty{
        x = ChatViewController.chats.array!.count
    }
        return x / 2
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        var subview = cell.subviews.first?.subviews
        let otherUser = subview![0] as! UILabel
        let lastMesage = subview![1] as! UILabel
        let row = indexPath.row
        var newestMessage = ChatViewController.chats[row * 2 + 1].array!.last!
        
        otherUser.text = newestMessage["senderName"].string!
        lastMesage.text = newestMessage["content"].string!
        

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let row = indexPath.row
        print(me["chats"].array![ row + 1 ])
        print(ChatViewController.chats[row * 2 + 1])
        
    }
    func getChats() {
        let url = URL(string: "http://\(AppDelegate.web):8080/chats")!
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
                    ChatViewController.chats = JSON(data: data)
                    self.tableView.reloadData()
                }
                
            }
            
        }
        task.resume()
    }
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation  */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
  

}
