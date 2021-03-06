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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var data: NSMutableData = NSMutableData()
    var lastStatusCode = 1
    var oldController: LoginController!
    
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
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            passwordField.text = ""
            passwordConfirmField.text = ""
        }
        else if(password != confirm){
            var alert = UIAlertController(title: "Oeps!", message: "Het bevestig wachtwoord komt niet overeen met het wachtwoord!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            passwordField.text = ""
            passwordConfirmField.text = ""
        }
        else if(count(password) < 3 || count(username) < 3){
            var alert = UIAlertController(title: "Oeps!", message: "Gebruikersnaam en wachtwoord moeten beide 3 of meer karakters bevatten!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.view.endEditing(true)
            self.activityIndicator.startAnimating()
            // create the request
            let request = NSMutableURLRequest(URL: NSURL(string: "https://desolate-bayou-9128.herokuapp.com/users")!)
            request.HTTPMethod = "POST"
            let postString = "username=" + username + "&password=" + password
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                self.activityIndicator.stopAnimating()
                if error != nil {
                    println("error=\(error)")
                    return
                }
                
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! [String: AnyObject]!
                let responseJSON = json as! [String: AnyObject]!
                let isSuccessfull = responseJSON["isSuccessfull"] as! Bool
                if(isSuccessfull == true){
                    // Create the alert controller
                    var alertController = UIAlertController(title: "Registreren gelukt!", message: "\(username), je bent een held!", preferredStyle: .Alert)
                    
                    // Create the actions
                    var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        self.goToLogin(username)
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // Present the controller
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    // Create the alert controller
                    var alertController = UIAlertController(title: "Oeps!", message: "Deze gebruikersnaam is al in gebruik!", preferredStyle: .Alert)
                    
                    // Create the actions
                    var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive) {
                        UIAlertAction in
                        self.resetView()
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // Present the controller
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            task.resume()
        }
    }
    func goToLogin(username: String!){
        oldController.usernameField.text = username
        oldController.passwordField.text = ""
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func resetView(){
        usernameField.text = ""
    }
}
