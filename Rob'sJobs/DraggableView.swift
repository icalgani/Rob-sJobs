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
        companyLogoView = UIImageView(frame: CGRect(x: 0,y: 10,width: 120,height: 80))
        companyLogoView.image = UIImage(named:"ads")
        companyLogoView.frame.origin.x = (self.bounds.size.width - companyLogoView.frame.size.width) / 2.0
        
        //company name
        companyNameLabel = UILabel(frame: CGRect(x: 0,y: 100,width: self.frame.size.width,height: 30))
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
                           constant: 40.0).isActive = true
        
        NSLayoutConstraint(item: containerDetail,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -200.0).isActive = true
        
        let leadingSize = (self.frame.size.width - 20) / 4
        
        //distance detail view
        distanceDetailView = UIView()
        self.addSubview(distanceDetailView)
        //distance detail view constraint
        distanceDetailView.translatesAutoresizingMaskIntoConstraints = false
        createDetailConstraint(container: distanceDetailView, leadingToItem: containerDetail, leadingSize: 0)
        
        //types detail view
        typeDetailView = UIView()
        self.addSubview(typeDetailView)
        //types detail view constraint
        typeDetailView.translatesAutoresizingMaskIntoConstraints = false
        createDetailConstraint(container: typeDetailView, leadingToItem: containerDetail, leadingSize: Float(leadingSize))

        //salary detail view
        salaryDetailView = UIView()
        self.addSubview(salaryDetailView)
        //salary detail view constraint
        salaryDetailView.translatesAutoresizingMaskIntoConstraints = false
        createDetailConstraint(container: salaryDetailView, leadingToItem: typeDetailView, leadingSize: Float(leadingSize))
        
        //experience detail view
        experienceDetailView = UIView()
        self.addSubview(experienceDetailView)
        //experience detail view constraint
        experienceDetailView.translatesAutoresizingMaskIntoConstraints = false
        createDetailConstraint(container: experienceDetailView, leadingToItem: salaryDetailView, leadingSize: Float(leadingSize))
        
        //create all detail information
        //distance detail
        locationLogo = UIImageView(frame: CGRect(x:(leadingSize-15)/2 ,y:0 ,width: 15, height: 15))
        locationLabel = UILabel(frame: CGRect(x:0 ,y:20 ,width: (leadingSize), height: 15))
        informationLocationLabel = UILabel(frame: CGRect(x:0 ,y:35 ,width: (leadingSize), height: 15))
        //initiate detail
        createInformationDetail(logoImage: locationLogo, imageName: "icon_location", addtoView: distanceDetailView, labelView: locationLabel, labelText: "121Km", informationLabel: informationLocationLabel, informationDetail: "Distance")
        
        //types detail
        typeLogo = UIImageView(frame: CGRect(x: (leadingSize-15)/2, y:0 , width: 15, height: 15))
        typeLabel = UILabel(frame: CGRect(x:0 ,y:20 ,width: (leadingSize), height: 15))
        informationTypesLabel = UILabel(frame: CGRect(x:0 ,y:35 ,width: (leadingSize), height: 15))
        //initiate detail
        createInformationDetail(logoImage: typeLogo, imageName: "icon_employment", addtoView: typeDetailView, labelView: typeLabel, labelText: "Full-time", informationLabel: informationTypesLabel, informationDetail: "Types")
        
        //Salary detail
        salaryLogo = UIImageView(frame: CGRect(x: (leadingSize-15)/2, y:0 , width: 15, height: 15))
        salaryLabel = UILabel(frame: CGRect(x:0 ,y:20 ,width: (leadingSize), height: 15))
        informationSalaryLabel = UILabel(frame: CGRect(x:0 ,y:35 ,width: (leadingSize), height: 15))
        //initiate detail
        createInformationDetail(logoImage: salaryLogo, imageName: "icon_salary", addtoView: salaryDetailView, labelView: salaryLabel, labelText: "5jt-7.5jt", informationLabel: informationSalaryLabel, informationDetail: "Salary")
        
        //experience detail
        experienceLogo = UIImageView(frame: CGRect(x: (leadingSize-15)/2, y:0 , width: 15, height: 15))
        experienceLabel = UILabel(frame: CGRect(x:0 ,y:20 ,width: (leadingSize), height: 15))
        informationExperienceLabel = UILabel(frame: CGRect(x:0 ,y:35 ,width: (leadingSize), height: 15))
        //initiate detail
        createInformationDetail(logoImage: experienceLogo, imageName: "icon_experience", addtoView: experienceDetailView, labelView: experienceLabel, labelText: "No", informationLabel: informationExperienceLabel, informationDetail: "Experience")
    }

    func setupView() -> Void {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSize(width: 1,height: 1);
    }
    
    func createInformationDetail(logoImage: UIImageView, imageName: String, addtoView: UIView, labelView: UILabel, labelText: String,informationLabel: UILabel, informationDetail: String){
//        let leadingSize = (self.frame.size.width - 20) / 4

        //logo image
        logoImage.image = UIImage(named:imageName)
        addtoView.addSubview(logoImage)
        
        //value label
        labelView.text = labelText
        labelView.font = UIFont(name: "Arial", size: 10)
        labelView.textColor = UIColor.black
        labelView.textAlignment = NSTextAlignment.center
        addtoView.addSubview(labelView)
        
        //information label
        informationLabel.text = informationDetail
        informationLabel.font = UIFont(name: "Arial", size: 10)
        informationLabel.textColor = UIColor.green
        informationLabel.textAlignment = NSTextAlignment.center
        addtoView.addSubview(informationLabel)
        
    }
    
    func createDetailConstraint(container: UIView, leadingToItem: UIView, leadingSize: Float){
        NSLayoutConstraint(item: container,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: leadingToItem,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: CGFloat(leadingSize)).isActive = true
        
        NSLayoutConstraint(item: container,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: containerDetail,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: container,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: (self.frame.size.width - 20) / 4).isActive = true
        
        NSLayoutConstraint(item: container,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: containerDetail,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
    }
    
    func createInsideDetailConstraint(){
    
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
