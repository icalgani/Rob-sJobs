//
//  Page4ViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/11/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class Page4ViewController: UIViewController {

    @IBAction func ExitFromTutorial(_ sender: UIButton) {
    
    }
    
    @IBOutlet weak var FinishButton: ButtonCustom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set white border
        FinishButton.whiteBorder()
        
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
