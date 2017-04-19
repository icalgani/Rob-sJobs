//
//  JsonRequest.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/19/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation

class JsonRequest{
    
    func getProvinceFromServer() -> Array<String>{
        var arrayToPass: [String]=["province"]
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
                        var arrayTemp: [String] = []
                        
                        for index in 0...jsonData.count-1 {
                            
                            let aObject = jsonData[index] 
                            
                            arrayTemp.append(aObject["province_name"] as! String)
                        }
                        arrayToPass = arrayTemp
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        print("test after resume:\(arrayToPass.joined(separator: ", "))")

        return arrayToPass
    }
}
