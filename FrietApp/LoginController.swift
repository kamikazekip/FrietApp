//
//  ViewController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 05/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class LoginController: UIViewController, NSURLConnectionDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var data: NSMutableData = NSMutableData()
    var lastStatusCode = 1
    var groups: [[String: AnyObject]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        usernameField.text = "admin"
        passwordField.text = "admin"
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
        loginButton.enabled = false
        registerButton.enabled = false
        activityIndicator.hidden = false
        let username = usernameField.text
        let password = passwordField.text
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic " + loginData.base64EncodedStringWithOptions(nil)
        
        // create the request
        let url = NSURL(string: "https://desolate-bayou-9128.herokuapp.com/login")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let urlConnection = NSURLConnection(request: request, delegate: self)
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("Failed with error:\(error.localizedDescription)")
    }
    
    //NSURLConnection delegate method
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        //New request so we need to clear the data object
        self.lastStatusCode = response.statusCode;
        self.data = NSMutableData()
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        //Append incoming data
        self.data.appendData(data)
    }
    
    //NSURLConnection delegate method
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        loginButton.enabled = true
        registerButton.enabled = true
        activityIndicator.hidden = true
        if(self.lastStatusCode == 200){
            let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! [String: AnyObject]!
            let receivedGroups = json["groups"]! as! [[String :AnyObject]]!
            groups = receivedGroups
            dealWithOutcome(true)
        } else {
            dealWithOutcome(false);
        }
        
    }
    
    func dealWithOutcome(outcome: Bool){
        if(outcome){
            self.performSegueWithIdentifier("toGroups", sender: self)
        }
        else{
            var alert = UIAlertController(title: "Oeps!", message: "Ongeldige combinatie!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Sluiten", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            passwordField.text = ""
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toGroups"){
            self.navigationItem.title = "Uitloggen"
            var groupController = segue.destinationViewController as! GroupController
            groupController.receivedGroups = groups;
        }
    }
}


