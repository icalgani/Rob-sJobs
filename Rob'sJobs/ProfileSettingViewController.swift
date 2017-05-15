//
//  ProfileSettingViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/10/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController {

    @IBOutlet weak var SectorTextfield: UITextField!
    @IBOutlet weak var SalaryTextfield: UITextField!
    @IBOutlet weak var WorkTypeTextfield: UITextField!
    @IBOutlet weak var WorkTimeTextfield: UITextField!
    @IBOutlet weak var DistanceSlider: UISlider!
    
    
    @IBAction func backToProfileSettingSegue(segue: UIStoryboardSegue) {
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SliderValueChanged(_ sender: UISlider) {
        let step: Float = 25.0
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
