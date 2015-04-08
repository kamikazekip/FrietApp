//
//  RegistrerenController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 08/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class RegistrerenController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapMainView(sender: UITapGestureRecognizer) {
        self.view.endEditing(true);
    }
    @IBAction func register(sender: UIButton) {
        var username = usernameField.text
        var password = passwordField.text
        var confirm = passwordConfirmField.text
        if(username.isEmpty || password.isEmpty || confirm.isEmpty){
            var alert = UIAlertController(title: "Oeps!", message: "Alle velden moeten ingevuld zijn!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Sluiten", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            passwordField.text = ""
            passwordConfirmField.text = ""
        }
        else if(password != confirm){
            var alert = UIAlertController(title: "Oeps!", message: "Het bevestig wachtwoord komt niet overeen met het wachtwoord!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Sluiten", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            passwordField.text = ""
            passwordConfirmField.text = ""
        }
        else {
            
        }
    }
}
