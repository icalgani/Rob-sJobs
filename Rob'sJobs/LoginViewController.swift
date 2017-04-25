//
//  LoginViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/3/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var EmailPhoneNumberTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var CreateAccountButton: ButtonCustom!
    
    let Utility = UIUtility()
    let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var LoginButton: ButtonCustom!
    
    @IBAction func doLogin(_ sender: UIButton) {
        
        //check if email and pass is null
        if (EmailPhoneNumberTextfield.text == ""){
            
            //create alert if email is empty
            let alertController = UIAlertController(title: "Alert", message:
                "Email must be filled in", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        
        }else if(PasswordTextfield.text == ""){
            
            //create alert if password is empty
            let alertController = UIAlertController(title: "Alert", message:
                "Password must be filled in", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        
        }else{
            
            //close keypad
            view.endEditing(true)
            
            var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/user/login")!)
            
            //check login
            request.httpMethod = "POST"
            let postString = "email=\(String(describing: EmailPhoneNumberTextfield.text))&password=\(String(describing: PasswordTextfield.text))"
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
                            let jsonData = json["data"] as! [String:Any]
                            let userDictionary = ["userID": jsonData["id"], "userName": jsonData["name"], "userPhone": jsonData["mobile_no"], "userEmail": self.EmailPhoneNumberTextfield.text]
                            
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")
                            
                            //go to FirstTimeLogin Storyboard
                            let storyBoard : UIStoryboard = UIStoryboard(name: "FirstTimeLogin", bundle: nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SetUpProfile") as UIViewController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = nextViewController
                        }
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
            task.resume()
        }
    }
    
    @IBAction func goToLogin(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailPhoneNumberTextfield.delegate=self
        PasswordTextfield.delegate=self
        
        CreateAccountButton.whiteBorder()
        LoginButton.roundingButton()
        
        //create background
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_login")
        self.view.insertSubview(backgroundImage, at: 0)
        
        //change status bar color
        Utility.setStatusBarBackgroundColor(color: Utility.hexStringToUIColor(hex: "#d3d3d3"))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //press next to change to next tab
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
