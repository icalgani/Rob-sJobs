//
//  DraggableViewBackground.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

class DraggableViewBackground: UIView, DraggableViewDelegate {
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

    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290

    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    
    var cardsSum: Int = 5

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        swipeCardData.getDataFromServer(dataToGet: "1/1/\(cardsSum)/6/107")
    }

    func setupView() -> Void {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)

        //create pass button
        xButton = UIButton(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2 + 35,y: self.frame.size.height/2 + CARD_HEIGHT/2 + 10,width: 59,height: 59))
        xButton.setImage(UIImage(named: "icon_no"), for: UIControlState.normal)
        xButton.addTarget(self, action: #selector(self.swipeLeft), for: UIControlEvents.touchUpInside)
        
        //create ok button
        checkButton = UIButton(frame: CGRect(x: self.frame.size.width/2 + CARD_WIDTH/2 - 85,y: self.frame.size.height/2 + CARD_HEIGHT/2 + 10,width: 59,height: 59))
        checkButton.setImage(UIImage(named: "icon_yes"), for: UIControlState.normal)
        checkButton.addTarget(self, action: #selector(DraggableViewBackground.swipeRight), for: UIControlEvents.touchUpInside)

        self.addSubview(xButton)
        self.addSubview(checkButton)
    }

    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2,y: (self.frame.size.height - CARD_HEIGHT)/2,width: CARD_WIDTH,height: CARD_HEIGHT))
        
        //set new data
        //set Job Title
        draggableView.companyNameLabel.text = jobTitleArray[index]
        draggableView.companyNameLabel.font = UIFont(name: "Arial", size: 16)
        draggableView.companyNameLabel.numberOfLines = 0
        
        draggableView.requiredSkillLabel.text = interestArray[index]
        draggableView.typeLabel.text = employmentTypeArray[index]
        draggableView.locationLabel.text = distanceArray[index]
        draggableView.salaryLabel.text = salaryArray[index]
        draggableView.experienceLabel.text = experienceArray[index]
        draggableView.offerTimeLabel.text = "end in \(endDateArray[index]) days"
        
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
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }

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

    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.remove(at: 0)

        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
        cardsSum -= 1
        print(cardsSum)
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
        cardsSum -= 1
        print(cardsSum)

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
        cardsSum -= 1
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
        cardsSum -= 1
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
        
        self.loadCards()
    }
    
    func tapForMorePressed(button:UIButton) -> Void {
        let viewController = JobSwipingViewController()
        let indexToSend = 5 - cardsSum
        viewController.doTapForMore(jobTitle: jobTitleArray[indexToSend], interest: interestArray[indexToSend], employmentType: employmentTypeArray[indexToSend], distance: distanceArray[indexToSend], salary: salaryArray[indexToSend], endDate: endDateArray[indexToSend], companyLogo: companyImageArray[indexToSend], experience: experienceArray[indexToSend], descriptionJob: descriptionArray[indexToSend])
    }
}
