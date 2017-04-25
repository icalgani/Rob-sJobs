//
//  ResetPasswordViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/3/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    let Utility = UIUtility()
    
    @IBOutlet weak var ResetPasswordButton: ButtonCustom!
    @IBOutlet weak var RegisteredEmailTextfield: FloatLabelTextField!
    
    
    @IBAction func ResetPasswordPressed(_ sender: ButtonCustom) {
        
        if (RegisteredEmailTextfield.text == ""){
            
            //create alert if email is empty
            let alertController = UIAlertController(title: "Alert", message:
                "Email must be filled in", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }else{
        
        //check login
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/user/signup")!)
        request.httpMethod = "POST"
        let postString = "email=\(String(describing: RegisteredEmailTextfield.text))"
        request.httpBody = postString.data(using: .utf8)
        
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
                        
                        //set alert if email or password is wrong
                        let alertController = UIAlertController(title: "Alert", message:
                            currentErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        
                        //tell user that register is success
                        let alertController = UIAlertController(title: "Alert", message:
                            "Reset Password Success", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        
                        //go to FirstTimeLogin Storyboard
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartingPoint") as! ViewController
                        self.present(nextViewController, animated:true, completion:nil)
                        
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        }//end request
        task.resume()
        }
    } //end button action
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create background
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_login")
        self.view.insertSubview(backgroundImage, at: 0)
        
        //change status bar color
        Utility.setStatusBarBackgroundColor(color: Utility.hexStringToUIColor(hex: "#d3d3d3"))
        
        //Reset Password Button
        ResetPasswordButton.roundingButton()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
