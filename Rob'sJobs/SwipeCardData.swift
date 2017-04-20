//
//  SwipeCardData.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/20/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class SwipeCardData{
    var idToSend: [String] = []
    var employerIDToSend: [String] = []
    var jobTitleToSend: [String] = []
    var interestToSend: [String] = []
    var employmentTypeToSend: [String] = []
    var distanceToSend: [String] = []
    var salaryToSend: [String] = []
    var endDateToSend: [String] = []
    var companyLogoToSend: [String] = []
    var logoImages: [UIImage] = []
    
    func getDataFromServer(dataToGet: String){
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/match/\(dataToGet)")!)
        //create the session object
        
        request.httpMethod = "GET"
        
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
//                            self.idToSend.append(aObject["id"] as! String)
//                            self.employerIDToSend.append(aObject["employer_id"] as! String)
                            self.jobTitleToSend.append(aObject["job_title"] as! String)
                            self.interestToSend.append(aObject["interests"] as! String)
                            self.employmentTypeToSend.append(aObject["employment_type"] as! String)
//                            self.distanceToSend.append(aObject["distance"] as! String )
                            self.salaryToSend.append(aObject["salary"] as! String)
                            self.endDateToSend.append(aObject["end_date"] as! String)
                            self.companyLogoToSend.append(aObject["company_logo"] as! String)
                            
                        }// end for
                        
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        }
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
