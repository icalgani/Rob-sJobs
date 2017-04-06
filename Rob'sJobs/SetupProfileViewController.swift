//
//  SetupProfileViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/3/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class SetupProfileViewController: UIViewController, UITextFieldDelegate, SSRadioButtonControllerDelegate {
    
    let Utility = UIUtility()

    
    var passedProvinceValue:String = "Province"
    var passedCityValue:String = ""
    var passedSalaryValue:String = ""
    var passedCharacterValue:[String] = []
    var passedSkillValue:[String] = []
    var passedEmploymentValue:String = ""
    var passedDesiredSectorValue:String = ""
    
    @IBOutlet weak var CharacterInput: FloatLabelTextField!
    @IBOutlet weak var ProvinceInput: FloatLabelTextField!
    @IBOutlet weak var NameInput: FloatLabelTextField!
    @IBOutlet weak var BirthdateInput: FloatLabelTextField!
    @IBOutlet weak var CityInput: FloatLabelTextField!
    @IBOutlet weak var SalaryInput: FloatLabelTextField!
    @IBOutlet weak var SkillsInput: FloatLabelTextField!
    @IBOutlet weak var EmploymentInput: FloatLabelTextField!
    @IBOutlet weak var DesiredSectorInput: FloatLabelTextField!
    @IBOutlet weak var CurrentSectorInput: FloatLabelTextField!
    
    
    @IBOutlet weak var workExperienceYesButton: SSRadioButton!
    @IBOutlet weak var workExperienceNoButton: SSRadioButton!
    @IBOutlet weak var currentyEmployedYesButton: SSRadioButton!
    @IBOutlet weak var currentyEmployedNoButton: SSRadioButton!
    
    var workExperienceRadioController: SSRadioButtonsController?
    
    
    //segue
    @IBAction func backToSetupProfile(segue: UIStoryboardSegue) {
        
        //if segue from province picker
        if(segue.source.isKind(of: ProvincePickerTableViewController.self))
        {
            let view2:ProvincePickerTableViewController = segue.source as! ProvincePickerTableViewController
            
            if(view2.valueToPass != ""){
                passedProvinceValue = view2.valueToPass
                ProvinceInput.text = passedProvinceValue
            }
            
            if(passedProvinceValue != "" && passedProvinceValue != "Province"){
                CityInput.isUserInteractionEnabled=true
            }
            
        }
        
        //if segue from City picker
        if(segue.source.isKind(of: CityPickerTableViewController.self)){
            let CityView:CityPickerTableViewController = segue.source as! CityPickerTableViewController
            
            if(CityView.cityToPass != ""){
                passedCityValue = CityView.cityToPass
                CityInput.text = passedCityValue
            }
        }
        
        //if segue from Salary picker
        if(segue.source.isKind(of: SalaryPickerTableViewController.self)){
            let SalaryView:SalaryPickerTableViewController = segue.source as! SalaryPickerTableViewController
            
            if(SalaryView.salaryToPass != ""){
                passedSalaryValue = SalaryView.salaryToPass
                SalaryInput.text = passedSalaryValue
            }
        }
        
        //if segue from Characters picker
        if(segue.source.isKind(of: CharactersTableViewController.self)){
            let CharacterView:CharactersTableViewController = segue.source as! CharactersTableViewController
            
            if(CharacterView.charactersToPass.count>0){
                passedCharacterValue = CharacterView.charactersToPass
                let concatedPassedCharacterValue: String = passedCharacterValue.joined(separator: ", ")
                CharacterInput.text = concatedPassedCharacterValue
            }
        }
        
        //if segue from Skills picker
        if(segue.source.isKind(of: SkillsPickerTableViewController.self)){
            let SkillView:SkillsPickerTableViewController = segue.source as! SkillsPickerTableViewController
            
            if(SkillView.skillToPass.count>0){
                passedSkillValue = SkillView.skillToPass
                let concatedPassedSkillValue: String = passedSkillValue.joined(separator: ", ")
                SkillsInput.text = concatedPassedSkillValue
            }
        }
        
        //if segue from Employment picker
        if(segue.source.isKind(of: EmploymentPickerTableViewController.self)){
            let employmentView:EmploymentPickerTableViewController = segue.source as! EmploymentPickerTableViewController
            
            if(employmentView.employmentToPass != ""){
                passedEmploymentValue = employmentView.employmentToPass
                EmploymentInput.text = passedEmploymentValue
            }
        }
        
        //if segue from Salary picker
        if(segue.source.isKind(of: DesiredSectorTableViewController.self)){
            let DesiredSector:DesiredSectorTableViewController = segue.source as! DesiredSectorTableViewController
            
            if(DesiredSector.desiredSectorToPass != ""){
                passedDesiredSectorValue = DesiredSector.desiredSectorToPass
                DesiredSectorInput.text = passedDesiredSectorValue
            }
        }
    }
    
    @IBAction func setDateInput(_ sender: FloatLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
                datePickerView.datePickerMode = UIDatePickerMode.date
        
                sender.inputView = datePickerView
        
                datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change status bar color
        Utility.setStatusBarBackgroundColor(color: Utility.hexStringToUIColor(hex: "#d3d3d3"))
        
        //add done to birthdate datepicker
        addUIBarPad(textField: BirthdateInput)
        
        //disable City
        CityInput.isUserInteractionEnabled=false
        
        //add dropdown image
        ProvinceInput.delegate = self
        CityInput.delegate = self
        SalaryInput.delegate = self
        CharacterInput.delegate = self
        SkillsInput.delegate = self
        EmploymentInput.delegate = self
        DesiredSectorInput.delegate = self
        
        //set work experience radio button
        workExperienceRadioController = SSRadioButtonsController(buttons: workExperienceYesButton, workExperienceNoButton)
        workExperienceRadioController!.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == self.ProvinceInput){
            performSegue(withIdentifier: "showProvincePicker", sender: self)
            return false
        }
        
        if(textField==self.CityInput){
            performSegue(withIdentifier: "showCityPicker", sender: self)
            return false
        }
        
        if(textField == self.SalaryInput){
            performSegue(withIdentifier: "showSalaryPicker", sender: self)
            return false
        }
        
        if(textField == self.CharacterInput){
            performSegue(withIdentifier: "showCharactersPicker", sender: self)
            return false
        }
        
        if(textField == self.SkillsInput){
            performSegue(withIdentifier: "showSkillsPicker", sender: self)
            return false
        }
        
        if(textField == self.EmploymentInput){
            performSegue(withIdentifier: "showEmploymentPicker", sender: self)
            return false
        }
        
        if(textField == self.DesiredSectorInput){
            performSegue(withIdentifier: "showDesiredSector", sender: self)
            return false
        }
    return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none

        BirthdateInput.text = dateFormatter.string(from: sender.date)
    }
    
    func addUIBarPad(textField: UITextField){
        let numberToolbar: UIToolbar = UIToolbar()
        
        numberToolbar.barStyle = UIBarStyle.blackTranslucent
        numberToolbar.items=[
        
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeNumpad))
        ]
        
        numberToolbar.sizeToFit()
        
        textField.inputAccessoryView = numberToolbar //do it for every relevant textfield if there are more than one
    }
    
    
    func closeNumpad() {
        BirthdateInput.resignFirstResponder()
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
