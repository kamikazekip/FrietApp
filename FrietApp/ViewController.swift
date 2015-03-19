//
//  ViewController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 05/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func register(sender: UIButton) {
        
    }
    
    func registerAttemptDone(outcome: Bool){
        if(outcome){
            self.performSegueWithIdentifier("register", sender: nil)
        } else {
            warningLabel.hidden = false
            warningLabel.text = "Deze gebruikersnaam bestaat al!"
            usernameTextfield.text = ""
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "register"){
            var overviewVC: OverviewController = segue.destinationViewController as OverviewController
            overviewVC.receivedUsername = usernameTextfield.text
        }
    }
}

