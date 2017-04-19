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
    var passedCurrentSectorValue:String = ""
    var provinceID: String = ""
    
    @IBOutlet weak var Stackview: UIStackView!
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var CharacterInput: FloatLabelTextField!
    @IBOutlet weak var ProvinceInput: FloatLabelTextField!
    @IBOutlet weak var NameInput: FloatLabelTextField!
    @IBOutlet weak var BirthdateInput: FloatLabelTextField!
    @IBOutlet weak var CityInput: FloatLabelTextField!
    @IBOutlet weak var SalaryInput: FloatLabelTextField!
    @IBOutlet weak var SkillsInput: FloatLabelTextField!
    @IBOutlet weak var EmploymentInput: FloatLabelTextField!
    @IBOutlet weak var DesiredSectorInput: FloatLabelTextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var CurrentSectorInput: FloatLabelTextField!
    @IBOutlet weak var DescribeYourselfInput: FloatLabelTextField!
    @IBOutlet weak var Scrollview: UIScrollView!
    
    @IBOutlet weak var workExperienceYesButton: SSRadioButton!
    @IBOutlet weak var workExperienceNoButton: SSRadioButton!
    @IBOutlet weak var currentyEmployedYesButton: SSRadioButton!
    @IBOutlet weak var currentyEmployedNoButton: SSRadioButton!
    
    @IBOutlet weak var SearchDistanceSlider: UISlider!
    
    var workExperienceRadioController: SSRadioButtonsController?
    var currentlyEmployedRadioController: SSRadioButtonsController?
    
    @IBAction func goToTutorialPage(_ sender: UIButton) {
        //close keypad
        view.endEditing(true)
        
        //go to tutorial page
        let storyBoard : UIStoryboard = UIStoryboard(name: "TutorialPage", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TutorialTestPageViewController") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
    }
    
    //segue
    @IBAction func backToSetupProfile(segue: UIStoryboardSegue) {
        
        //if segue from province picker
        if(segue.source.isKind(of: ProvincePickerTableViewController.self))
        {
            let view2:ProvincePickerTableViewController = segue.source as! ProvincePickerTableViewController
            
            if(view2.valueToPass != ""){
                self.passedProvinceValue = view2.valueToPass
                ProvinceInput.text = passedProvinceValue
                self.provinceID = view2.idToPass
                let cityView = CityPickerTableViewController()
                cityView.passedProvinceID = provinceID
            }
            
            if(passedProvinceValue != "" && passedProvinceValue != "Province"){
                CityInput.isUserInteractionEnabled=true
            }
            print(provinceID)
            
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
        
        //if segue from desired sector picker
        if(segue.source.isKind(of: DesiredSectorTableViewController.self)){
            let DesiredSector:DesiredSectorTableViewController = segue.source as! DesiredSectorTableViewController
            
            if(DesiredSector.desiredSectorToPass != ""){
                passedDesiredSectorValue = DesiredSector.desiredSectorToPass
                DesiredSectorInput.text = passedDesiredSectorValue
            }
        }
        
        //if segue from current sector picker
        if(segue.source.isKind(of: CurrentSectorTableViewController.self)){
            let CurrentSector:CurrentSectorTableViewController = segue.source as! CurrentSectorTableViewController
            
            if(CurrentSector.currentSectorToPass != ""){
                passedCurrentSectorValue = CurrentSector.currentSectorToPass
                CurrentSectorInput.text = passedCurrentSectorValue
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
        CurrentSectorInput.delegate = self
        
        //set work experience radio button
        workExperienceRadioController = SSRadioButtonsController(buttons: workExperienceYesButton, workExperienceNoButton)
        workExperienceRadioController!.delegate = self
        
        //set currently employed radio button
        currentlyEmployedRadioController = SSRadioButtonsController(buttons: currentyEmployedYesButton, currentyEmployedNoButton)
        currentlyEmployedRadioController!.delegate = self
        
        //set keyboard
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification: Notification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: false, notification: notification as Notification)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == self.ProvinceInput){
            performSegue(withIdentifier: "showProvincePicker", sender: self)
            return false
        }
        
        if(textField==self.CityInput){
            self.performSegue(withIdentifier: "showCityPicker", sender: self)
            
            print("perform segue with identifier.\(provinceID)")
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
        
        if(textField == self.CurrentSectorInput){
            performSegue(withIdentifier: "showCurrentSector", sender: self)
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
    
    //adjust keyboard so you can see what you fill in
    func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        Scrollview.contentInset.bottom = adjustmentHeight
        Scrollview.scrollIndicatorInsets.bottom = adjustmentHeight
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCityPicker" {
            let dvc = segue.destination as! UINavigationController
            let view = dvc.topViewController as! CityPickerTableViewController
            view.passedProvinceID = provinceID
            print("prepare segue, province id  =\(provinceID)")
        }
    }
 

}
