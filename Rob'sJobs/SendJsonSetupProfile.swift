//
//  File.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/15/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class SendJsonSetupProfile{
    
    func sendDataToAPI(userDictionary: Dictionary){
        
        
        //check login
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/user/profile")!)
        request.httpMethod = "POST"
        let postString = "userid=\(userDictionary["userid"])&password=\((PasswordTextfield.text)!)&name=\((NameTextfield.text)!) \((LastNameTextfield.text)!)&mobile_no=\((PhoneNumberTextfield.text)!)"
        request.httpBody = postString.data(using: .utf8)
        print(postString)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            //handling json
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        //if status code is not 200
                        let errorMessage = json["error"] as! [String:Any]
                        let currentErrorMessage = errorMessage["message"] as! String
                        DispatchQueue.main.async {
                            //set alert if email or password is wrong
                            let alertController = UIAlertController(title: "Alert", message:
                                currentErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            //tell user that register is success
                            let alertController = UIAlertController(title: "Alert", message:
                                "Registration Success", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            
                            //go to FirstTimeLogin Storyboard
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartingPoint") as! ViewController
                            self.present(nextViewController, animated:true, completion:nil)
                        }
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        }//end request
        task.resume()
    }
}
