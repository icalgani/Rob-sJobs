//
//  ProvincePickerTableViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/4/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ProvincePickerTableViewController: UITableViewController, UITextFieldDelegate {
    var province: [String] = []
    var ProvinceID: [String] = []
    var valueToPass: String = ""
    var idToPass: String = ""
    let jsonRequest = JsonRequest()
    
    var selectedProvince:String? {
        didSet {
            if let selected = selectedProvince {
                selectedProvinceIndex = province.index(of: selected)!
            }
        }
    }
    var selectedProvinceIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        getProvinceFromServer()
    }
    
    func getProvinceFromServer(){
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/init/province")!)
        //create the session object
        
        request.httpMethod = "GET"
        //        let postString = "province"
        //        request.httpBody = postString.data(using: .utf8)
        
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
                        let jsonData = json["data"] as! [[String:Any]]
                        for index in 0...jsonData.count-1 {
                            
                            let aObject = jsonData[index]
                            
                            self.province.append(aObject["province_name"] as! String)
                        }
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async(execute: {self.tableView.reloadData()})

        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return province.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "provinceCell", for: indexPath)
        cell.textLabel?.text = province[indexPath.row]
        
        if indexPath.row == selectedProvinceIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedProvinceIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedProvince = province[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedProvince = province[indexPath.row]
        
        //update the checkmark for the current row
        let cellUpdate = tableView.cellForRow(at: indexPath)
        cellUpdate?.accessoryType = .checkmark
        
        // Get Cell Label
        valueToPass = province[(indexPath.row)]
        idToPass = String(province.index(of: valueToPass)! + 1)
    }
    
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! SetupProfileViewController
        
            // your new view controller should have property that will store passed value
            let sendID = sender as! String
            viewController.passedProvinceValue = valueToPass
            viewController.provinceID = idToPass
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }

}
