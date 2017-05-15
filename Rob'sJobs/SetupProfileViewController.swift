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
    var passedEducationValue: String = ""
    var passedSalaryValue:String = ""
    var passedCharacterValue:[String] = []
    var passedSkillValue:[String] = []
    var passedEmploymentValue:String = ""
    var passedDesiredSectorValue:String = ""
    var passedCurrentSectorValue:String = ""
    var provinceID: String = ""
    var passedWorkExperienceValue: String = ""
    var prevControllerFrom = 0
    
    
    @IBOutlet weak var Scrollview: UIScrollView!
    
    @IBOutlet weak var WorkExperienceInput: UITextField!
    @IBOutlet weak var EducationInput: UITextField!
    @IBOutlet weak var CharacterInput: FloatLabelTextField!
    @IBOutlet weak var ProvinceInput: UITextField!
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var BirthdateInput: UITextField!
    @IBOutlet weak var CityInput: UITextField!
    @IBOutlet weak var SalaryInput: UITextField!
    @IBOutlet weak var SkillsInput: FloatLabelTextField!
    @IBOutlet weak var EmploymentInput: FloatLabelTextField!
    @IBOutlet weak var DesiredSectorInput: FloatLabelTextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var CurrentSectorInput: FloatLabelTextField!
    @IBOutlet weak var DescribeYourselfInput: UITextField!
    
    @IBOutlet weak var workExperienceYesButton: SSRadioButton!
    @IBOutlet weak var workExperienceNoButton: SSRadioButton!
    @IBOutlet weak var currentyEmployedYesButton: SSRadioButton!
    @IBOutlet weak var currentyEmployedNoButton: SSRadioButton!
    
    @IBAction func goToTutorialPage(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        let sendJson = SendJsonSetupProfile()
        sendJson.sendDataToAPI(userDictionary)
        
        //close keypad
        view.endEditing(true)
        
        if(userDictionary?["city"] != nil){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipingScene") as! UITabBarController
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nextViewController
        
        }else{
            
        //go to tutorial page
        let storyBoard : UIStoryboard = UIStoryboard(name: "TutorialPage", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TutorialTestPageViewController") as UIViewController
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
        }
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
        }
        
        //if segue from City picker
        if(segue.source.isKind(of: CityPickerTableViewController.self)){
            let CityView:CityPickerTableViewController = segue.source as! CityPickerTableViewController
            
            if(CityView.cityToPass != ""){
                passedCityValue = CityView.cityToPass
                CityInput.text = passedCityValue
            }
        }
        
        //if segue from educationpicker
        if(segue.source.isKind(of: EducationPickerTableViewController.self)){
            let educationView:EducationPickerTableViewController = segue.source as! EducationPickerTableViewController
            
            if(educationView.educationToPass != ""){
                passedEducationValue = educationView.educationToPass
                EducationInput.text = passedEducationValue
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
        
        //if segue from educationpicker
        if(segue.source.isKind(of: WorkExperiencePickerTableViewController.self)){
            let workExperienceView:WorkExperiencePickerTableViewController = segue.source as! WorkExperiencePickerTableViewController
            
            if(workExperienceView.workExperienceToPass != ""){
                passedWorkExperienceValue = workExperienceView.workExperienceToPass
                WorkExperienceInput.text = passedWorkExperienceValue
            }
        }

        
        //if segue from Characters picker
//        if(segue.source.isKind(of: CharactersTableViewController.self)){
//            let CharacterView:CharactersTableViewController = segue.source as! CharactersTableViewController
//            
//            if(CharacterView.charactersToPass.count>0){
//                passedCharacterValue = CharacterView.charactersToPass
//                let concatedPassedCharacterValue: String = passedCharacterValue.joined(separator: ", ")
//                CharacterInput.text = concatedPassedCharacterValue
//            }
//        }
    }
    
    @IBAction func setDateInput(_ sender: FloatLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        if(userDictionary?["city"] != nil){
            setInputText()
        }
        
        //add done to birthdate datepicker
        addUIBarPad(textField: BirthdateInput)
        
        //disable City
        CityInput.isUserInteractionEnabled=false
        
        //add dropdown image
        ProvinceInput.delegate = self
        CityInput.delegate = self
        EducationInput.delegate = self
        SalaryInput.delegate = self
        WorkExperienceInput.delegate = self
        DescribeYourselfInput.delegate = self
//        EmploymentInput.delegate = self
//        DesiredSectorInput.delegate = self
//        CurrentSectorInput.delegate = self
        
//        //set work experience radio button
//        workExperienceRadioController = SSRadioButtonsController(buttons: workExperienceYesButton, workExperienceNoButton)
//        workExperienceRadioController!.delegate = self
//        
//        //set currently employed radio button
//        currentlyEmployedRadioController = SSRadioButtonsController(buttons: currentyEmployedYesButton, currentyEmployedNoButton)
//        currentlyEmployedRadioController!.delegate = self
        
        //set keyboard
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setInputText(){
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        if(userDictionary?["userName"] != nil){
            NameInput.text = (userDictionary?["userName"] as! String)
        }
        if(userDictionary?["birthdate"] != nil){
            BirthdateInput.text = (userDictionary?["birthdate"] as! String)
        }
        if(userDictionary?["province"] != nil){
            ProvinceInput.text = (userDictionary?["province"] as! String)
        }
        if(userDictionary?["city"] != nil){
            CityInput.text = (userDictionary?["city"] as! String)
        }
        if(userDictionary?["salary"] != nil){
            SalaryInput.text = (userDictionary?["salary"] as! String)
        }
        if(userDictionary?["edu_level"] != nil){
            EducationInput.text = (userDictionary?["edu_level"] as! String)
        }
        if(userDictionary?["bio"] != nil){
            DescribeYourselfInput.text = (userDictionary?["bio"] as! String)
        }
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
            return false
        }
        
        if(textField == self.EducationInput){
            performSegue(withIdentifier: "showEducationPicker", sender: self)
            return false
        }
        
        if(textField == self.SalaryInput){
            performSegue(withIdentifier: "showSalaryPicker", sender: self)
            return false
        }
        
        if(textField == self.WorkExperienceInput){
            performSegue(withIdentifier: "showWorkExperiencePicker", sender: self)
            return false
        }
//        if(textField == self.CharacterInput){
//            performSegue(withIdentifier: "showCharactersPicker", sender: self)
//            return false
//        }
//        
//        if(textField == self.SkillsInput){
//            performSegue(withIdentifier: "showSkillsPicker", sender: self)
//            return false
//        }
//        
//        if(textField == self.EmploymentInput){
//            performSegue(withIdentifier: "showEmploymentPicker", sender: self)
//            return false
//        }
//        
//        if(textField == self.DesiredSectorInput){
//            performSegue(withIdentifier: "showDesiredSector", sender: self)
//            return false
//        }
//        
//        if(textField == self.CurrentSectorInput){
//            performSegue(withIdentifier: "showCurrentSector", sender: self)
//            return false
//        }
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
        }
    }
 

}
