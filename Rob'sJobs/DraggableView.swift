//
//  DraggableView.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX:Float = 0.93          //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: Float = 320  //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: Float = 3.14/8  //%%% Higher = stronger rotation angle

protocol DraggableViewDelegate {
    func cardSwipedLeft(card: UIView) -> Void
    func cardSwipedRight(card: UIView) -> Void
}

class DraggableView: UIView {
    var delegate: DraggableViewDelegate!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originPoint: CGPoint!
    var overlayView: OverlayView!
    var xFromCenter: Float!
    var yFromCenter: Float!
    
    var companyNameLabel: UILabel!
    var companyLogoView: UIImageView!
    var containerDetail: UIView!
    var distanceDetailView: UIView!
    var typeDetailView: UIView!
    var salaryDetailView: UIView!
    var experienceDetailView: UIView!
    
    var requiredSkillView: UIView!
    
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
    
    var requiredSkill: [String] = ["Accounting","Analysis","Audit","Finance","Reporting","Accurate","Analytical Thinking", "Motivated","Problem Solver","Used To Working Under Pressure"]
    var requiredSkillLabel: UILabel!
    
    var offerTimeView: UIView!
    var offerTimeLabel: UILabel!
    
    var moreButtonView: UIView!
    var moreButton: UIButton!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupView()

        self.backgroundColor = UIColor.white

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged(_:)))

        self.addGestureRecognizer(panGestureRecognizer)

        overlayView = OverlayView(frame: CGRect(x: self.frame.size.width/2-100,y: 0,width: 100,height: 100))
        overlayView.alpha = 0
        self.addSubview(overlayView)
        
        setUpDraggableContent()
        
        xFromCenter = 0
        yFromCenter = 0
    }
    
    func setUpDraggableContent(){



        
        //company Logo
        companyLogoView = UIImageView(frame: CGRect(x: 0,y: 10,width: 115,height: 80))
        companyLogoView.image = UIImage(named:"ads")
        companyLogoView.frame.origin.x = (self.bounds.size.width - companyLogoView.frame.size.width) / 2.0
        
        //company name
        companyNameLabel = UILabel(frame: CGRect(x: 0,y: 120,width: self.frame.size.width,height: 30))
        companyNameLabel.text = "no info given"
        companyNameLabel.textAlignment = NSTextAlignment.center
        companyNameLabel.textColor = UIColor.black
        companyNameLabel.font.withSize(20)
        self.addSubview(companyNameLabel)
        self.addSubview(companyLogoView)
        
        //container detail
        containerDetail = UIView()
        self.addSubview(containerDetail)
        //container constraint
        containerDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: containerDetail,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 10.0).isActive = true
        
        NSLayoutConstraint(item: containerDetail,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
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
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -200.0).isActive = true
        
        let leadingSize = (self.frame.size.width - 20) / 4
        let detailInformationUI = UIDetailInformationRow()

        //distance detail view
        distanceDetailView = UIView()
        self.addSubview(distanceDetailView)
        //distance detail view constraint
        distanceDetailView.translatesAutoresizingMaskIntoConstraints = false
        detailInformationUI.createDetailConstraint(container: distanceDetailView, leadingToItem: containerDetail, leadingSize: 0, frameSizeWidth: Float(leadingSize), ToItem: containerDetail)
        
        //types detail view
        typeDetailView = UIView()
        self.addSubview(typeDetailView)
        //types detail view constraint
        typeDetailView.translatesAutoresizingMaskIntoConstraints = false
        detailInformationUI.createDetailConstraint(container: typeDetailView, leadingToItem: containerDetail, leadingSize: Float(leadingSize),frameSizeWidth: Float(leadingSize), ToItem: containerDetail)

        //salary detail view
        salaryDetailView = UIView()
        self.addSubview(salaryDetailView)
        //salary detail view constraint
        salaryDetailView.translatesAutoresizingMaskIntoConstraints = false
        detailInformationUI.createDetailConstraint(container: salaryDetailView, leadingToItem: typeDetailView, leadingSize: Float(leadingSize),frameSizeWidth: Float(leadingSize), ToItem: containerDetail)
        
        //experience detail view
        experienceDetailView = UIView()
        self.addSubview(experienceDetailView)
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
        self.addSubview(requiredSkillView)
        //container constraint
        requiredSkillView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: requiredSkillView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: requiredSkillView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
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
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -100.0).isActive = true
        
        requiredSkillLabel = UILabel(frame: CGRect(x:0 ,y:0 ,width: self.frame.size.width, height: 60))
        requiredSkillLabel.textColor = UIColor(red:0.15, green:0.57, blue:0.45, alpha:1.0)
        requiredSkillLabel.textAlignment = NSTextAlignment.center
        requiredSkillLabel.font = UIFont(name: "Arial", size: 12)
        requiredSkillLabel.numberOfLines = 0
        requiredSkillLabel.text = requiredSkill.joined(separator: ", ")
        requiredSkillView.addSubview(requiredSkillLabel)
        
        //offer time
        //create requiredSkillView
        offerTimeView = UIView()
        self.addSubview(offerTimeView)
        //container constraint
        offerTimeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: offerTimeView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: offerTimeView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: offerTimeView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: requiredSkillView,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 65.0).isActive = true
        
        NSLayoutConstraint(item: offerTimeView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -70.0).isActive = true
        
        offerTimeLabel = UILabel(frame: CGRect(x:0 ,y:0 ,width: self.frame.size.width, height: 20))
        offerTimeLabel.textColor = UIColor.black
        offerTimeLabel.textAlignment = NSTextAlignment.center
        offerTimeLabel.font = UIFont(name: "Arial", size: 10)
        offerTimeLabel.numberOfLines = 1
        offerTimeLabel.text = "End in 64 Days"
        offerTimeView.addSubview(offerTimeLabel)
        
        //create button
//        detailInformationUI.createTapForMoreButton(view: self)
        moreButtonView = UIView()
        self.addSubview(moreButtonView)
        
        moreButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: moreButtonView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant:10.0).isActive = true
        
        NSLayoutConstraint(item: moreButtonView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -10.0).isActive = true
        
        NSLayoutConstraint(item: moreButtonView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: offerTimeView,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 25.0).isActive = true
        
        NSLayoutConstraint(item: moreButtonView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -10.0).isActive = true
        
        moreButton = UIButton(frame: CGRect(x: 0,y: 0,width: self.frame.size.width - 20,height: 50))
        moreButton.backgroundColor = UIColor(red:0.22, green:0.83, blue:0.65, alpha:1.0)
        moreButton.layer.cornerRadius = 5
        moreButton.setTitle("Tap For More", for: .normal)
        moreButton.addTarget(self, action: #selector(self.action(_:)), for: UIControlEvents.touchUpInside)
        moreButtonView.addSubview(moreButton)
    }
    
    func action(_ sender:UIButton!) {
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/user/login")!)
        //create the session object
        
        request.httpMethod = "POST"
        let postString = "email=666clover@gmail.com&password=luckynumber"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            //handling json
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        //if status code is not 200
                        let errorMessage = json["error"] as! [String:Any]
                        print(errorMessage)
                        let currentErrorMessage = errorMessage["message"] as! String
                        print(currentErrorMessage)
                    }else{
                        let jsonData = json["data"] as! [String:Any]
                        let userID = jsonData["id"] as! String
                        print(userID)
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
    
    
    func setupView() -> Void {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSize(width: 1,height: 1);
    }

    func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) -> Void {
        xFromCenter = Float(gestureRecognizer.translation(in: self).x)
        yFromCenter = Float(gestureRecognizer.translation(in: self).y)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            self.originPoint = self.center
        case UIGestureRecognizerState.changed:
            let rotationStrength: Float = min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = ROTATION_ANGLE * rotationStrength
            let scale = max(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)

            self.center = CGPoint(x: self.originPoint.x + CGFloat(xFromCenter),y: self.originPoint.y + CGFloat(yFromCenter))

            let transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
            let scaleTransform = transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
            self.transform = scaleTransform
            self.updateOverlay(distance: CGFloat(xFromCenter))
        case UIGestureRecognizerState.ended:
            self.afterSwipeAction()
        case UIGestureRecognizerState.possible:
            fallthrough
        case UIGestureRecognizerState.cancelled:
            fallthrough
        case UIGestureRecognizerState.failed:
            fallthrough
        default:
            break
        }
    }

    func updateOverlay(distance: CGFloat) -> Void {
        if distance > 0 {
            overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeRight)
        } else {
            overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeLeft)
        }
        overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100, 0.4))
    }

    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        } else {
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.center = self.originPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    func rightAction() -> Void {
        
        let finishPoint: CGPoint = CGPoint(x: 500,y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(card: self)
    }

    func leftAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: -500,y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(card: self)
    }

    func rightClickAction() -> Void {
        let finishPoint = CGPoint(x: 600,y: self.center.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransform(rotationAngle: 1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(card: self)
    }

    func leftClickAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: -600,y: self.center.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransform(rotationAngle: 1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(card: self)
    }
    
    
}
