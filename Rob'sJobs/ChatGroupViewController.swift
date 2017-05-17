//
//  ChatGroupViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/17/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ChatGroupCell: UITableViewCell{
    @IBOutlet weak var CompanyImageView: UIImageView!
    @IBOutlet weak var CompanyLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var NotificationLabel: UIImageView!

}

class ChatGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var TableViewOutlet: UITableView!
    
    var companyNameArray: [String] = ["test"]
    var companyImageArray: [String] = []
    var companyUserNameArray: [String] = ["test"]

    let chatGroupData = ChatGroupData()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewOutlet.rowHeight = UITableViewAutomaticDimension
        TableViewOutlet.estimatedRowHeight = 100
        chatGroupData.getDataFromServer(dataToGet: "313/0/5")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadChatGroupData), name:NSNotification.Name(rawValue: "loadChatGroupData"), object: nil)
    }
    
    func loadChatGroupData(){
        companyNameArray = chatGroupData.companyNameToPass
        companyImageArray = chatGroupData.companyImageToPass
        companyUserNameArray = chatGroupData.companyUserNameToPass
        
        print("loadchatgroupdata: \(companyNameArray)")

        self.TableViewOutlet.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TABLE FUNCTION
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return companyNameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroup", for: indexPath) as! ChatGroupCell
        
        cell.CompanyLabel?.text = companyNameArray[indexPath.row]
        cell.NameLabel?.text = companyUserNameArray[indexPath.row]
        
        if(companyImageArray[indexPath.row] != "No Data"){
            if let checkedUrl = URL(string: companyImageArray[indexPath.row]) {
                downloadImage(url: checkedUrl, imageCell: cell)
            }
        }
        return cell
    }
    
    func downloadImage(url: URL, imageCell: ChatGroupCell) {
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                imageCell.CompanyImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
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
