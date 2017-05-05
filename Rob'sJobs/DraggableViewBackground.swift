//
//  DraggableViewBackground.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class DraggableViewBackground: UIView, DraggableViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    let swipeCardData = SwipeCardData()
    var exampleCardLabels: [String]!
    var allCards: [DraggableView]!
    
    var idArray: [String] = []
    var employerIDArray: [String] = []
    var jobTitleArray: [String] = []
    var interestArray: [String] = []
    var employmentTypeArray: [String] = []
    var distanceArray: [String] = []
    var salaryArray: [String] = []
    var endDateArray: [String] = []
    var companyLogoArray: [String] = []
    var experienceArray: [String] = []
    var descriptionArray: [String] = []
    var companyImageArray: [UIImage] = []
    var jobsScoreArray: [String] = []

    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290

    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    
    var cardsSum: Int = 10
    var cardsStartID: Int = 1
    
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        print("\(String(describing: (userDictionary?["userID"])!))/1/\(cardsSum)/\(locValue.latitude)/\(locValue.longitude)")
        swipeCardData.getDataFromServer(dataToGet: "\(String(describing: (userDictionary?["userID"])!))/1/\(cardsSum)/\(locValue.latitude)/\(locValue.longitude)")
        
    }

    func setupView() -> Void {
//        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)

        //create pass button
        xButton = UIButton(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2 + 35,y: self.frame.size.height/2 + CARD_HEIGHT/2 + 10,width: 59,height: 59))
        xButton.setImage(UIImage(named: "RJ_pass_icon_col"), for: UIControlState.normal)
        xButton.addTarget(self, action: #selector(self.swipeLeft), for: UIControlEvents.touchUpInside)
        
        //create ok button
        checkButton = UIButton(frame: CGRect(x: self.frame.size.width/2 + CARD_WIDTH/2 - 85,y: self.frame.size.height/2 + CARD_HEIGHT/2 + 10,width: 59,height: 59))
        checkButton.setImage(UIImage(named: "RJ_apply_icon_col"), for: UIControlState.normal)
        checkButton.addTarget(self, action: #selector(self.swipeRight), for: UIControlEvents.touchUpInside)

        self.addSubview(xButton)
        self.addSubview(checkButton)
    }

    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2,y: (self.frame.size.height - CARD_HEIGHT)/2,width: CARD_WIDTH,height: CARD_HEIGHT))
        
        //set new data
        //set Job Title
        draggableView.jobOfferLabel.text = jobTitleArray[index]
        draggableView.jobOfferLabel.font = UIFont(name: "Arial", size: 16)
        draggableView.jobOfferLabel.numberOfLines = 1
        
//        draggableView.requiredSkillLabel.text = interestArray[index]
        draggableView.typeLabel.text = employmentTypeArray[index]
        draggableView.locationLabel.text = distanceArray[index]
        draggableView.salaryLabel.text = salaryArray[index]
        draggableView.experienceLabel.text = experienceArray[index]
//        draggableView.offerTimeLabel.text = "end in \(endDateArray[index]) days"
        
        //download image from url
        for index in 0...companyLogoArray.count-1 {
            if let checkedUrl = URL(string: companyLogoArray[index]) {
                
                downloadImage(url: checkedUrl,imageIndex: index)
            }
        }
        
        draggableView.delegate = self
        return draggableView
    }
    
    func downloadImage(url: URL, imageIndex: NSInteger) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.allCards[imageIndex].companyLogoView.image = UIImage(data: data)
                self.companyImageArray.append(UIImage(data: data)!)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func loadCards() -> Void {
        if jobTitleArray.count > 0 {
            let numLoadedCardsCap = jobTitleArray.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : jobTitleArray.count
            for i in 0 ..< jobTitleArray.count {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(index: i)
                allCards.append(newCard)
                print("all cards append = \(allCards.count)")
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            //if loaded cards is 0 put 2 cards in loaded cards, if loaded cards is 1 put 1 loaded cards
            for i in 0 ..< loadedCards.count {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }

    func loadNewCards(){
        
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        cardsSum = 10
        cardsLoadedIndex = 0
        idArray.removeAll()
        employerIDArray.removeAll()
        jobTitleArray.removeAll()
        interestArray.removeAll()
        employmentTypeArray.removeAll()
        distanceArray.removeAll()
        salaryArray.removeAll()
        endDateArray.removeAll()
        companyLogoArray.removeAll()
        experienceArray.removeAll()
        descriptionArray.removeAll()
        companyImageArray.removeAll()
        jobsScoreArray.removeAll()
        allCards.removeAll()
        loadedCards.removeAll()
        print("cards Sum in load new cards: \(cardsSum), cards start ID = \(cardsStartID)")
        swipeCardData.resetAllData()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        var locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        swipeCardData.getDataFromServer(dataToGet: "\(String(describing: (userDictionary?["userID"])!))/1/\(cardsSum)/\(locValue.latitude)/\(locValue.longitude)")
    }

    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.remove(at: 0)

        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
        if loadedCards.isEmpty{
            loadNewCards()
        }else{
        cardIsSwiped(requestType: "reject", indexToSend: (10 - cardsSum), jobScoreToSend: "job_score=\(jobsScoreArray[10 - cardsSum])")
        }
        
        cardsSum -= 1
    }
    
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
            print(cardsSum)
        }
        
        if loadedCards.isEmpty{
            loadNewCards()
        }else{
        
            cardIsSwiped(requestType: "apply", indexToSend: (10 - cardsSum), jobScoreToSend: "jobscore=\(jobsScoreArray[10 - cardsSum])")
        }
        
        cardsSum -= 1
    }

    func swipeRight() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeRight)
        UIView.animate(withDuration: 0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        print(cardsSum)
        dragView.rightClickAction()
    }

    func swipeLeft() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeLeft)
        UIView.animate(withDuration: 0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        print(cardsSum)
        dragView.leftClickAction()
    }
    
    func loadList(notification: NSNotification){
        //load data here
        jobTitleArray = swipeCardData.jobTitleToSend
        interestArray = swipeCardData.interestToSend
        employmentTypeArray = swipeCardData.employmentTypeToSend
        distanceArray = swipeCardData.distanceToSend
        salaryArray = swipeCardData.salaryToSend
        companyLogoArray = swipeCardData.companyLogoToSend
        experienceArray = swipeCardData.experienceToSend
        endDateArray = swipeCardData.endDateToSend
        descriptionArray = swipeCardData.descriptionToSend
        jobsScoreArray = swipeCardData.jobsScoreToSend
        idArray = swipeCardData.idToSend
        
        self.loadCards()
    }
    
    func cardIsSwiped(requestType: String, indexToSend: Int, jobScoreToSend: String){
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/job/\(requestType)")!)
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        //check login
        request.httpMethod = "POST"
        print("userid=\(String(describing: (userDictionary?["userID"])!))&jobid=\(idArray[indexToSend])&\(jobScoreToSend)")
        
        let postString = "userid=\(String(describing: (userDictionary?["userID"])!))&jobid=\(idArray[indexToSend])&\(jobScoreToSend)"
        request.httpBody = postString.data(using: .utf8)
        print("card is swiped post string: \(postString)")
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
                        let currentErrorMessage = errorMessage["message"] as! String
                        print("status code: \(httpStatus.statusCode)")
                    }else{
                        let jsonData = json["data"] as! [String:Any]
                        print("job score= \(jsonData["job_score"]), job id = \(jsonData["jobid"]), user id = \(jsonData["userid"])")
                    } // if else
                } //if json
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        } //end task
        task.resume()
    }
    
    func tapForMorePressed(button:UIButton) -> Void {
        let viewController = JobSwipingViewController()
        let indexToSend = 10 - cardsSum
        viewController.doTapForMore(jobTitle: jobTitleArray[indexToSend], interest: interestArray[indexToSend], employmentType: employmentTypeArray[indexToSend], distance: distanceArray[indexToSend], salary: salaryArray[indexToSend], endDate: endDateArray[indexToSend], companyLogo: companyImageArray[indexToSend], experience: experienceArray[indexToSend], descriptionJob: descriptionArray[indexToSend], idJob: idArray[indexToSend])
    }
}
