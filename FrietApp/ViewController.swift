//
//  ViewController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 05/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Inloggen"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapMainView(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func inloggen(sender: UIButton) {
        println("Evaluate: " + usernameField.text + " pass: " + passwordField.text)
        var outcome = true
        //Asynchroon
        dealWithOutcome(outcome)
        
    }
    
    func dealWithOutcome(outcome: Bool){
        if(outcome){
            self.performSegueWithIdentifier("toGroups", sender: self)
        }
        else{
            //Geef error message
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toGroups"){
            self.navigationItem.title = "Uitloggen"
        }
    }
}

