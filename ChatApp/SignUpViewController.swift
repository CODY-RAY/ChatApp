//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by cody's macbook on 10/30/17.
//  Copyright © 2017 crank llc. All rights reserved.
//

import UIKit
import SwiftyJSON


class SignUpViewController: UIViewController {

    @IBOutlet weak var UNText: UITextField!
    @IBOutlet weak var EMText: UITextField!
    @IBOutlet weak var PWText0: UITextField!
    @IBOutlet weak var PWText1: UITextField!
    @IBOutlet weak var netWorkIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        netWorkIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func SignUpButton(_ sender: UIButton) {
        
        if PWText0.text == PWText1.text{
            let n = UNText.text!
            let e = EMText.text!
            let p = PWText0.text!
            let json = JSON(["name":n,"email":e, "password":p])
            let url = URL(string: "http://\(AppDelegate.web):8080/users")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! json.rawData()
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
               
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                   
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                    //let responseString = String(data: data, encoding: .utf8)
                   
                    DispatchQueue.main.async {
                       self.performSegue(withIdentifier: "ToLogin", sender: nil)
                    }
                    
                    
                }
              
            }
            task.resume()
            
        }
       
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
 

}
