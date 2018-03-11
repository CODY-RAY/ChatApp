//
//  SignInViewController.swift
//  ChatApp
//
//  Created by cody's macbook on 10/30/17.
//  Copyright © 2017 crank llc. All rights reserved.
//

import UIKit
import SwiftyJSON
class SignInViewController: UIViewController {

    @IBOutlet weak var UNText: UITextField!
    @IBOutlet weak var PWText: UITextField!
    @IBOutlet weak var netWorkIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
       netWorkIndicator.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignIn(_ sender: UIButton) {
        let url = URL(string: "http://\(AppDelegate.web):8080/login")!
        let userPasswordString = "\(UNText.text!):\(PWText.text!)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Basic \(base64EncodedCredential)" , forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                
            }
            
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                
                let token = String.init(data: data, encoding: .utf8)!
                AppDelegate.token = token
                DispatchQueue.main.async {
                  self.performSegue(withIdentifier: "ToChats", sender: nil)
                }
                
                
            }
            
        }
        task.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
