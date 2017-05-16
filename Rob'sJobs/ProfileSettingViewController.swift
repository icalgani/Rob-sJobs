//
//  ProfileSettingViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/10/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var SectorTextfield: UITextField!
    @IBOutlet weak var SalaryTextfield: UITextField!
    @IBOutlet weak var WorkTypeTextfield: UITextField!
    @IBOutlet weak var WorkTimeTextfield: UITextField!
    @IBOutlet weak var DistanceSlider: UISlider!
    
    var passedSalaryValue: String?
    var passedSalaryMinValue: String?
    var passedSalaryMaxValue: String?
    var passedCurrentSectorValue: String?
    var passedWorkTypeValue: String?
    var passedWorkTimeValue: String?
    var distanceValue: String?

    @IBAction func backToProfileSettingSegue(segue: UIStoryboardSegue) {
        
        //if segue from Salary picker
        if(segue.source.isKind(of: SalaryPickerTableViewController.self)){
            let SalaryView:SalaryPickerTableViewController = segue.source as! SalaryPickerTableViewController
            
            if(SalaryView.salaryToPass != ""){
                passedSalaryValue = SalaryView.salaryToPass
                SalaryTextfield.text = passedSalaryValue
            }
        }
        
        //if segue from sector picker
        if(segue.source.isKind(of: CurrentSectorTableViewController.self)){
            let View:CurrentSectorTableViewController = segue.source as! CurrentSectorTableViewController
            
            if(View.currentSectorToPass != ""){
                passedCurrentSectorValue = View.currentSectorToPass
                SectorTextfield.text = passedCurrentSectorValue
            }
        }
        
        
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
        
        SectorTextfield.delegate = self
        SalaryTextfield.delegate = self
        WorkTimeTextfield.delegate = self
        WorkTypeTextfield.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == self.SectorTextfield){
            performSegue(withIdentifier: "showSectorPicker", sender: self)
            return false
        }
        
        if(textField==self.SalaryTextfield){
            self.performSegue(withIdentifier: "showSalaryPicker", sender: self)
            return false
        }
        
//        if(textField == self.WorkTypeTextfield){
//            performSegue(withIdentifier: "showEducationPicker", sender: self)
//            return false
//        }
        
        if(textField == self.WorkTimeTextfield){
            performSegue(withIdentifier: "showWorkTimePicker", sender: self)
            return false
        }
    
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
