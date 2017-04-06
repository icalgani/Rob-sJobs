//
//  ViewController.swift
//  RobsJobs
//
//  Created by MacBook on 3/31/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var CreateAccountButton: ButtonCustom!
    @IBOutlet weak var FacebookButton: ButtonCustom!
    @IBOutlet weak var LoginWIthEmailAndPhoneButton: ButtonCustom!
    
    @IBAction func backToLogin(segue: UIStoryboardSegue) {
    }

    @IBAction func registerUser(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create button white border
        CreateAccountButton.whiteBorder()
        
        //rounding facebook button
        FacebookButton.roundingButton()
        
        //rounding login with email or phone button
        LoginWIthEmailAndPhoneButton.roundingButton()
        
        //set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_landing")
        self.view.insertSubview(backgroundImage, at: 0)
        
        //set status bar color
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

