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
}

class TestController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TableViewOutlet: UITableView!
    
    @IBOutlet weak var MessageTextfield: UITextField!
    @IBOutlet weak var SendMessageButton: UIButton!
    
    var messageArray: [String] = ["test", "Lorem ipsum dolor sit amet, ex illud abhorreant mea. Mel at amet integre. In fugit putant pertinacia per. No ius veniam rationibus, id qualisque persecuti incorrupte mel. Quo unum adipiscing necessitatibus ex, modus assum numquam ea est."]

    @IBAction func SendButtonPressed(_ sender: UIButton) {
        
        messageArray.append(MessageTextfield.text!)
        self.TableViewOutlet.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewOutlet.rowHeight = UITableViewAutomaticDimension
        TableViewOutlet.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        return cell
    }
    
}


