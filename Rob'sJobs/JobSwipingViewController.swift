//
//  JobSwipingViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/12/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class JobSwipingViewController: UIViewController,CLLocationManagerDelegate, UITabBarControllerDelegate {

    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        self.tabBarController?.delegate = self
        checkLocationIsOn()
        
        var draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            //do your stuff
        }
    }
    
    func checkLocationIsOn(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else{
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                UIApplication.shared.open(settingsURL)
            }
        }
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
