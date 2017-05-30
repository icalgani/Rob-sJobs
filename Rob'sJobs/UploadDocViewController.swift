//
//  UploadDocViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/9/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices

class UploadDocViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var UserPicture: UIView!
    @IBOutlet weak var UserPhotoIcon: UIImageView!
    
    @IBOutlet weak var FieldOfWorkTextfield: UITextField!
    @IBOutlet weak var Certificate1: UIImageView!
    @IBOutlet weak var Certificate2: UIImageView!
    @IBOutlet weak var Certificate3: UIImageView!
    @IBOutlet weak var PortfolioTextfield: UITextField!
    
    let imagePicker = UIImagePickerController()
    var imagePickedTag = 0
    var imageToSend: UIImage!
    
    @IBAction func DoneButtonPressed(_ sender: UIButton) {
        
        UploadRequest()
    }
    
    func UploadRequest()
    {
        let userDefaults = UserDefaults.standard
        var userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]

        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/user/uploadphoto")!)
        
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        //define the multipart request type
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (imageToSend == nil)
        {
            return
        }
        
        let image_data = UIImageJPEGRepresentation(imageToSend, 0.5)!
        
        var body = Data()
        let mimetype = "image/jpeg"
        
        //define the data post parameter
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        body.append("Content-Disposition:form-data; name=\"userid\" \r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        body.append("\(String(describing: (userDictionary?["userID"])!))\r\n".data(using: .utf8, allowLossyConversion: true)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        body.append("Content-Disposition:form-data; name=\"photo\"; filename=\"profile.jpeg\"\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        body.append("Content-Type: \(mimetype)".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        body.append(image_data)
//        print(image_data)
        body.append("\r\n\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)

        request.httpBody = body as Data
        
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
                        print("status code: \(httpStatus.statusCode)")
                        print("error message: \(errorMessage["message"] as! String)")
                        //set alert if email or password is wrong
                    }else{
                        let httpStatus = response as? HTTPURLResponse
                        let errorMessage = json["data"] as! [String:Any]
                        print("message: \(errorMessage)")
                    }
                } //if json
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        } //end task
        task.resume()

    }
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.pickUserImage(sender:)))
        UserPicture.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.pickUserImage1(sender:)))
        Certificate1.isUserInteractionEnabled = true
        Certificate1.addGestureRecognizer(gesture1)

        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.pickUserImage2(sender:)))
        Certificate2.isUserInteractionEnabled = true
        Certificate2.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector (self.pickUserImage3(sender:)))
        Certificate3.isUserInteractionEnabled = true
        Certificate3.addGestureRecognizer(gesture3)
    }
    
    func pickUserImage(sender : UITapGestureRecognizer) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        imagePickedTag = 0

        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickUserImage1(sender : UITapGestureRecognizer) {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
        documentPickerController.delegate = self
        present(documentPickerController, animated: true, completion: nil)
    }
    
    func pickUserImage2(sender : UITapGestureRecognizer) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        imagePickedTag = 2
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickUserImage3(sender : UITapGestureRecognizer) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        imagePickedTag = 3
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            switch imagePickedTag {
            case 0:
                UIGraphicsBeginImageContext(self.UserPicture.frame.size)
                pickedImage.draw(in: self.UserPicture.bounds)
                
                let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                
                UIGraphicsEndImageContext()
                self.UserPicture.backgroundColor = UIColor(patternImage: image)
                
                imageToSend = pickedImage
            case 1:
                self.Certificate1.contentMode = .scaleAspectFit
                self.Certificate1.image = pickedImage
            case 2:
                self.Certificate2.contentMode = .scaleAspectFit
                self.Certificate2.image = pickedImage
            case 3:
                self.Certificate3.contentMode = .scaleAspectFit
                self.Certificate3.image = pickedImage
            default:
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        // rounding user profile image
        self.UserPicture.roundingUIView()
        
        //set padding to placeholder
        self.PortfolioTextfield.setLeftPaddingPoints(20.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension UploadDocViewController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        print("The Url is : \(cico)")
        
        //optional, case PDF -> render
        //displayPDFweb.loadRequest(NSURLRequest(url: cico) as URLRequest)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("this is documentpicker")
    }
}
extension NSMutableData {
    
    public func appendString(string: String) {
            let stringData = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            append(stringData!)
        }
}
