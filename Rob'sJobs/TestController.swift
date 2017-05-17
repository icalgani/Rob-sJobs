//
//  TestController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/16/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell{

    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var MessageView: UIView!
    
    func setConstraintEmployer(){
            MessageView.translatesAutoresizingMaskIntoConstraints = false
        
            NSLayoutConstraint(item: MessageView,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 10).isActive = true
        
            TimeLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: TimeLabel,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: MessageView,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: 10).isActive = true
    }
    
    func setConstraintUser(){
        MessageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: MessageView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -10).isActive = true
        
        TimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: TimeLabel,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: MessageView,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: -10).isActive = true
    }
}

class TestController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var TableViewOutlet: UITableView!
    
    @IBOutlet weak var MessageTextfield: UITextField!
    @IBOutlet weak var SendMessageButton: UIButton!
    @IBOutlet weak var MessageScrollView: UIScrollView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var TestCell: UITableViewCell!
    
    
    let chatData = ChatData()
    
    var messageArray: [String] = []
    var userTypeArray: [String] = []
    
    @IBAction func SendButtonPressed(_ sender: UIButton) {
        
        messageArray.append(MessageTextfield.text!)
        userTypeArray.append("user")
        self.TableViewOutlet.reloadData()
        MessageTextfield.text = ""
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewOutlet.rowHeight = UITableViewAutomaticDimension
        TableViewOutlet.estimatedRowHeight = 100
        
        chatData.getDataFromServer(dataToGet: "9143/0/5")
        
        MessageTextfield.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadChatData), name:NSNotification.Name(rawValue: "loadChatData"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func loadChatData(){
        messageArray = chatData.messageToSend
        userTypeArray = chatData.userTypeToSend
        self.TableViewOutlet.reloadData()
    }
    
    //adjust keyboard so you can see what you fill in
    func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        MessageScrollView.contentInset.bottom = adjustmentHeight
        MessageScrollView.scrollIndicatorInsets.bottom = adjustmentHeight
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: Notification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: false, notification: notification as Notification)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath) as! TestCell
        
        cell.MessageLabel?.text = messageArray[indexPath.row]
        if(userTypeArray[indexPath.row] == "employer"){
            cell.setConstraintEmployer()
        }else{
            cell.setConstraintUser()
        }
        return cell
    }
    
}


