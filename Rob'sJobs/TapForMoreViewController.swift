//
//  TapForMoreViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/21/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class TapForMoreViewController: UIViewController {
    
    var passedData: String!
    
    var idArray: String!
    var employerIDArray: String!
    var jobTitleArray: String!
    var interestArray: String!
    var employmentTypeArray: String!
    var distanceArray: String!
    var salaryArray: String!
    var endDateArray: String!
    var companyLogoArray: UIImage!
    var experienceArray: String!
    var descriptionArray: String!
    
    @IBOutlet weak var ContainerVIew: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ExitButton: UIButton!
    
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var SalaryLabel: UILabel!
    @IBOutlet weak var ExperienceLabel: UILabel!
    
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var InterestLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    @IBOutlet weak var UserImage: UIImageView!
    
    @IBAction func backToTapForMore(segue: UIStoryboardSegue) {
        
    }
    
    
    @IBAction func CloseButtonPressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipingScene") as! CustomTabbarViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "jobsdetail_bg")
        self.view.insertSubview(backgroundImage, at: 0)
        
        InterestLabel.text = interestArray
        InterestLabel.sizeToFit()
        InterestLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        DescriptionLabel.text = descriptionArray
//        DescriptionLabel.sizeToFit()
//        DescriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        JobLabel.text = jobTitleArray
        DistanceLabel.text = distanceArray
        TypeLabel.text = employmentTypeArray
        SalaryLabel.text = salaryArray
        ExperienceLabel.text = experienceArray
        UserImage.image = companyLogoArray
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dvc = segue.destination as! UINavigationController
        let view = dvc.topViewController as! SendJobToFriendViewController
        view.passedJobId = idArray
    }

}
