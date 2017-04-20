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

    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290

    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!

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
        swipeCardData.getDataFromServer(dataToGet: "1/1/5/6/107")
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
//        draggableView.locationLabel.text = distanceArray[index]
        draggableView.salaryLabel.text = salaryArray[index]
        
        if let checkedUrl = URL(string: companyLogoArray[index]) {
        
            downloadImage(url: checkedUrl)
        }
        
        draggableView.delegate = self
        return draggableView
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let draggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - self.CARD_WIDTH)/2,y: (self.frame.size.height - self.CARD_HEIGHT)/2,width: self.CARD_WIDTH,height: self.CARD_HEIGHT))

                draggableView.companyLogoView.image = UIImage(data: data)
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
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
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
        dragView.leftClickAction()
    }
    
    func loadList(notification: NSNotification){
        //load data here
        jobTitleArray = swipeCardData.jobTitleToSend
        interestArray = swipeCardData.interestToSend
        employmentTypeArray = swipeCardData.employmentTypeToSend
//        distanceArray = swipeCardData.distanceToSend
        salaryArray = swipeCardData.salaryToSend
        companyLogoArray = swipeCardData.companyLogoToSend
        
        
        self.loadCards()
    }
}
