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
        var companyLogoView: UIImageView!
        var locationLogo: UIImageView!
        var locationLabel: UILabel!
        var distanceLabel: UILabel!


        
        //company Logo
        companyLogoView = UIImageView(frame: CGRect(x: 0,y: 30,width: 100,height: 100))
        companyLogoView.image = UIImage(named:"ads")
        companyLogoView.frame.origin.x = (self.bounds.size.width - companyLogoView.frame.size.width) / 2.0
        
        //company name
        companyNameLabel = UILabel(frame: CGRect(x: 0,y: 100,width: self.frame.size.width,height: 100))
        companyNameLabel.text = "no info given"
        companyNameLabel.textAlignment = NSTextAlignment.center
        companyNameLabel.textColor = UIColor.black
        companyNameLabel.font.withSize(20)
        
        //location logo
        locationLogo = UIImageView(frame: CGRect(x: 0,y: 0,width: 10,height: 10))
        locationLogo.image = UIImage(named:"icon_location")
        //location label
        locationLabel = UILabel(frame: CGRect(x: 0,y: 20,width: self.frame.size.width,height: self.frame.size.height))
        locationLabel.text = "121 KM"
        locationLabel.textAlignment = NSTextAlignment.center
        locationLabel.textColor = UIColor.black
        //location label
        distanceLabel = UILabel(frame: CGRect(x: 0,y: 40,width: self.frame.size.width,height: self.frame.size.height))
        distanceLabel.text = "Distance"
        distanceLabel.textAlignment = NSTextAlignment.center
        distanceLabel.textColor = UIColor.black
        
        let stackView   = UIStackView(frame: CGRect(x: 0,y: 150,width: 30,height: 30))
        stackView.axis  = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing   = 16.0
        
        stackView.addArrangedSubview(locationLogo)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(distanceLabel)
        stackView.frame.origin.y = 100.0
        stackView.frame.origin.x = 20.0
        
        self.addSubview(companyNameLabel)
        self.addSubview(companyLogoView)
        self.addSubview(stackView)
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
