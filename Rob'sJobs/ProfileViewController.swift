//
//  ProfileViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/11/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var DetailStackView: UIStackView!
    @IBOutlet weak var UserDescriptionLabel: UILabel!
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var userSkillsLabel: UILabel!
    @IBOutlet weak var LogOutButton: UIButton!
    
    
    @IBOutlet weak var BirthdateLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var EducationLabel: UILabel!
    @IBOutlet weak var CharactersLabel: UILabel!
    @IBOutlet weak var SkillsLabel: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    
    @IBAction func doLogOut(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userDictionary")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartingPoint") as UIViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserDescriptionLabel()
//        UserImage.backgroundColor = UIColor.black
//        UserImage.layer.opacity = 0.3
    }
    
    override func viewDidLayoutSubviews() {
        
        // add bottom border at user description
        let descriptionUnderline = CALayer()
        let width = CGFloat(1.0)
        descriptionUnderline.borderColor = UIColor.darkGray.cgColor
        descriptionUnderline.frame = CGRect(x: 0, y: UserDescriptionLabel.frame.size.height - width, width:  UserDescriptionLabel.frame.size.width, height: UserDescriptionLabel.frame.size.height)
        
        descriptionUnderline.borderWidth = width
        UserDescriptionLabel.layer.addSublayer(descriptionUnderline)
        UserDescriptionLabel.layer.masksToBounds = true
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUserDescriptionLabel(){
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        BirthdateLabel.text = (userDictionary?["birthdate"] as! String)
        EmailLabel.text = userDictionary?["email"] as! String
        LocationLabel.text = userDictionary?["city"] as! String
        EducationLabel.text = userDictionary?["edu_level"] as! String
        CharactersLabel.text = userDictionary?["interests"] as! String
        SkillsLabel.text = userDictionary?["skills"] as! String
        UserDescriptionLabel.text = userDictionary?["bio"] as! String
        print(userDictionary?["image"] as! String)
        //download image from url
            if let checkedUrl = URL(string: userDictionary?["image"] as! String) {
                
                downloadImage(url: checkedUrl)
            }
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.UserImage.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }


}
