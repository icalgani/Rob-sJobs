//
//  UploadDocViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/9/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class UploadDocViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var UserPicture: UIView!
    @IBOutlet weak var UserPhotoIcon: UIImageView!
    
    @IBOutlet weak var FieldOfWorkTextfield: UITextField!
    @IBOutlet weak var Certificate1: UIImageView!
    @IBOutlet weak var Certificate2: UIImageView!
    @IBOutlet weak var Certificate3: UIImageView!
    @IBOutlet weak var PortfolioTextfield: UITextField!
    
    let imagePicker = UIImagePickerController()
    var imagePickedTag = 0
    
    @IBAction func DoneButtonPressed(_ sender: UIButton) {
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
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        imagePickedTag = 1
        
        present(imagePicker, animated: true, completion: nil)
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
        self.FieldOfWorkTextfield.setLeftPaddingPoints(20.0)
        self.PortfolioTextfield.setLeftPaddingPoints(20.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
