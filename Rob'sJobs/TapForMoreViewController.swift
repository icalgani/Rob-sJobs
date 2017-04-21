//
//  TapForMoreViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/21/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class TapForMoreViewController: UIViewController {
    var companyNameLabel: UILabel!
    var companyLogoView: UIImageView!
    var containerDetail: UIView!
    var distanceDetailView: UIView!
    var typeDetailView: UIView!
    var salaryDetailView: UIView!
    var experienceDetailView: UIView!
    var requiredSkillView: UIView!
    var descriptionView: UIView!
    
    var locationLogo: UIImageView!
    var locationLabel: UILabel!
    var informationLocationLabel: UILabel!
    
    var typeLogo: UIImageView!
    var typeLabel: UILabel!
    var informationTypesLabel: UILabel!
    
    var salaryLogo: UIImageView!
    var salaryLabel: UILabel!
    var informationSalaryLabel: UILabel!
    
    var experienceLogo: UIImageView!
    var experienceLabel: UILabel!
    var informationExperienceLabel: UILabel!
    
    var descriptionLabel: UILabel!
    
    var passedData: String!
    
    @IBOutlet weak var ContainerVIew: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ExitButton: UIButton!
    
    var requiredSkill: [String] = ["Accounting","Analysis","Audit","Finance","Reporting","Accurate","Analytical Thinking", "Motivated","Problem Solver","Used To Working Under Pressure"]
    var requiredSkillLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "jobsdetail_bg")
        self.view.insertSubview(backgroundImage, at: 0)
        
        ContainerVIew.frame.size.width = ScrollView.frame.size.width
        ContainerVIew.frame.size.height = ScrollView.frame.size.height
        
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setView(){
        //company Logo
        companyLogoView = UIImageView(frame: CGRect(x: 0,y: 10,width: 115,height: 80))
        companyLogoView.image = UIImage(named:"ads")
        companyLogoView.frame.origin.x = (ContainerVIew.frame.size.width - companyLogoView.frame.size.width - 40) / 2.0
        
        //company name
        companyNameLabel = UILabel(frame: CGRect(x: 0,y: 120,width: ContainerVIew.frame.size.width - 40,height: 30))
        companyNameLabel.text = "no info given"
        companyNameLabel.textAlignment = NSTextAlignment.center
        companyNameLabel.textColor = UIColor.black
        companyNameLabel.font.withSize(20)
        ContainerVIew.addSubview(companyNameLabel)
        ContainerVIew.addSubview(companyLogoView)
        
        //container detail
        containerDetail = UIView()
        ContainerVIew.addSubview(containerDetail)
        //container constraint
        containerDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: containerDetail,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: ContainerVIew,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 10.0).isActive = true
        
        NSLayoutConstraint(item: containerDetail,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: ContainerVIew,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -10.0).isActive = true
        
        NSLayoutConstraint(item: containerDetail,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: companyNameLabel,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 55.0).isActive = true
        
        NSLayoutConstraint(item: containerDetail,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: ContainerVIew,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -200.0).isActive = true
        
        let leadingSize = (ContainerVIew.frame.size.width - 60) / 4
        let detailInformationUI = UIDetailInformationRow()
        
        //distance detail view
        distanceDetailView = UIView()
        ContainerVIew.addSubview(distanceDetailView)
        //distance detail view constraint
        distanceDetailView.translatesAutoresizingMaskIntoConstraints = false
        detailInformationUI.createDetailConstraint(container: distanceDetailView, leadingToItem: containerDetail, leadingSize: 0, frameSizeWidth: Float(leadingSize), ToItem: containerDetail)
        
        //types detail view
        typeDetailView = UIView()
        ContainerVIew.addSubview(typeDetailView)
        //types detail view constraint
        typeDetailView.translatesAutoresizingMaskIntoConstraints = false
        detailInformationUI.createDetailConstraint(container: typeDetailView, leadingToItem: containerDetail, leadingSize: Float(leadingSize),frameSizeWidth: Float(leadingSize), ToItem: containerDetail)
        
        //salary detail view
        salaryDetailView = UIView()
        ContainerVIew.addSubview(salaryDetailView)
        //salary detail view constraint
        salaryDetailView.translatesAutoresizingMaskIntoConstraints = false
        detailInformationUI.createDetailConstraint(container: salaryDetailView, leadingToItem: typeDetailView, leadingSize: Float(leadingSize),frameSizeWidth: Float(leadingSize), ToItem: containerDetail)
        
        //experience detail view
        experienceDetailView = UIView()
        ContainerVIew.addSubview(experienceDetailView)
        //experience detail view constraint
        experienceDetailView.translatesAutoresizingMaskIntoConstraints = false
        detailInformationUI.createDetailConstraint(container: experienceDetailView, leadingToItem: salaryDetailView, leadingSize: Float(leadingSize),frameSizeWidth: Float(leadingSize), ToItem: containerDetail)
        
        //create all detail information
        //distance detail
        locationLogo = UIImageView(frame: CGRect(x:(leadingSize-15)/2 ,y:0 ,width: 15, height: 15))
        locationLabel = UILabel(frame: CGRect(x:0 ,y:20 ,width: (leadingSize), height: 15))
        informationLocationLabel = UILabel(frame: CGRect(x:0 ,y:35 ,width: (leadingSize), height: 15))
        //initiate detail
        detailInformationUI.createInformationDetail(logoImage: locationLogo, imageName: "icon_location", addtoView: distanceDetailView, labelView: locationLabel, labelText: "121Km", informationLabel: informationLocationLabel, informationDetail: "Distance")
        
        //types detail
        typeLogo = UIImageView(frame: CGRect(x: (leadingSize-15)/2, y:0 , width: 15, height: 15))
        typeLabel = UILabel(frame: CGRect(x:0 ,y:20 ,width: (leadingSize), height: 15))
        informationTypesLabel = UILabel(frame: CGRect(x:0 ,y:35 ,width: (leadingSize), height: 15))
        //initiate detail
        detailInformationUI.createInformationDetail(logoImage: typeLogo, imageName: "icon_employment", addtoView: typeDetailView, labelView: typeLabel, labelText: "Full-time", informationLabel: informationTypesLabel, informationDetail: "Types")
        
        //Salary detail
        salaryLogo = UIImageView(frame: CGRect(x: (leadingSize-15)/2, y:0 , width: 15, height: 15))
        salaryLabel = UILabel(frame: CGRect(x:0 ,y:20 ,width: (leadingSize), height: 15))
        informationSalaryLabel = UILabel(frame: CGRect(x:0 ,y:35 ,width: (leadingSize), height: 15))
        //initiate detail
        detailInformationUI.createInformationDetail(logoImage: salaryLogo, imageName: "icon_salary", addtoView: salaryDetailView, labelView: salaryLabel, labelText: "5jt-7.5jt", informationLabel: informationSalaryLabel, informationDetail: "Salary")
        
        //experience detail
        experienceLogo = UIImageView(frame: CGRect(x: (leadingSize-15)/2, y:0 , width: 15, height: 15))
        experienceLabel = UILabel(frame: CGRect(x:0 ,y:20 ,width: (leadingSize), height: 15))
        informationExperienceLabel = UILabel(frame: CGRect(x:0 ,y:35 ,width: (leadingSize), height: 15))
        //initiate detail
        detailInformationUI.createInformationDetail(logoImage: experienceLogo, imageName: "icon_experience", addtoView: experienceDetailView, labelView: experienceLabel, labelText: "No", informationLabel: informationExperienceLabel, informationDetail: "Experience")
        
        //create requiredSkillView
        requiredSkillView = UIView()
        requiredSkillView.backgroundColor = UIColor(red:0.91, green:0.98, blue:0.96, alpha:1.0)
        ContainerVIew.addSubview(requiredSkillView)
        //container constraint
        requiredSkillView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: requiredSkillView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: ContainerVIew,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: requiredSkillView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: ContainerVIew,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: requiredSkillView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: containerDetail,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 55.0).isActive = true
        
        NSLayoutConstraint(item: requiredSkillView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: ContainerVIew,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -200.0).isActive = true
        
        requiredSkillLabel = UILabel(frame: CGRect(x:0 ,y:0 ,width: ContainerVIew.frame.size.width - 60, height: 60))
        requiredSkillLabel.textColor = UIColor(red:0.15, green:0.57, blue:0.45, alpha:1.0)
        requiredSkillLabel.textAlignment = NSTextAlignment.center
        requiredSkillLabel.font = UIFont(name: "Arial", size: 12)
        requiredSkillLabel.numberOfLines = 0
        requiredSkillLabel.text = requiredSkill.joined(separator: ", ")
        requiredSkillView.addSubview(requiredSkillLabel)
        
        //create requiredSkillView
        descriptionView = UIView()
        ContainerVIew.addSubview(descriptionView)
        //container constraint
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.autoresizingMask = [.flexibleBottomMargin]
        NSLayoutConstraint(item: descriptionView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: ContainerVIew,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 20.0).isActive = true
        
        NSLayoutConstraint(item: descriptionView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: ContainerVIew,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: descriptionView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: requiredSkillView,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 120.0).isActive = true
        
        descriptionLabel = UILabel(frame: CGRect(x:0 ,y:0 ,width: ContainerVIew.frame.size.width - 60, height: 200))
        descriptionLabel.textAlignment = NSTextAlignment.justified
        descriptionLabel.font = UIFont(name: "Arial", size: 14)
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        descriptionView.addSubview(descriptionLabel)
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
