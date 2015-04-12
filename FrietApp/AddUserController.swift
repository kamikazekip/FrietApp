//
//  AddUserController.swift
//  FrietApp
//
//  Created by User on 12/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class AddUserController: UIViewController, NSURLConnectionDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var receivedGroup: Group!
    var lastStatusCode: Int!
    var lastOperation: String!
    var data: NSMutableData = NSMutableData()
    var defaults = NSUserDefaults.standardUserDefaults()
    var lastAddedUser: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = receivedGroup.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addUser(sender: UIButton) {
        if(count(userTextField.text) == 0){
            var alert = UIAlertController(title: "Oeps!", message: "Gebruiker mag niet leeg zijn!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Sluiten", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            lastAddedUser = userTextField.text
            let base64LoginString = defaults.valueForKey("authHeader") as! String
            // create the request
            var urlString = "https://desolate-bayou-9128.herokuapp.com/groups/\(receivedGroup._id)/addUser/\(userTextField.text)"
            
            let url = NSURL(string: urlString)
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
            lastOperation = "addUser"
            activityIndicator.hidden = false
            let urlConnection = NSURLConnection(request: request, delegate: self)
        }
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
        if(self.lastStatusCode == 200){
            switch(lastOperation){
            case "addUser":
                afterAddUser()
            default:
                println("Default method called on lastOperation switch!")
            }
        } else {
            println("Something went wrong, statusCode wasn't 200")
        }
    }
    
    func afterAddUser(){
        activityIndicator.hidden = true
        var alert = UIAlertController(title: "Gelukt!", message: "\(lastAddedUser) is toegevoegd aan de groep \(receivedGroup.name)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        self.view.endEditing(true)
        self.userTextField.text = ""
    }
}