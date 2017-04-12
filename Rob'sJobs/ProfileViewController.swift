//
//  ProfileViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/11/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var UserDescriptionLabel: UILabel!
    @IBOutlet weak var ProfileDetailStackView: UIStackView!
    @IBOutlet weak var LabelForUnderline: UILabel!
    @IBOutlet weak var LogOutButton: ButtonCustom!
    
    @IBAction func doLogOut(_ sender: ButtonCustom) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add underline on user description
        UserDescriptionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1)
        LabelForUnderline.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1)
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
