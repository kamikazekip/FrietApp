//
//  NewGroupController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 20/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class NewGroupController: UIViewController, NSURLConnectionDelegate {
    
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var data: NSMutableData = NSMutableData()
    var oldController: GroupController!
    var lastStatusCode = 1
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onTapMainView(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func createGroup(sender: UIButton) {
        createButton.enabled = false
        activityIndicator.hidden = false
        let groupName = groupNameField.text
        if(count(groupName) > 2){
            postGroup(groupName)
        }
    }
    
    func postGroup(groupName: String){
        let loginString = NSString(format: "%@:%@", "admin", "admin")
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = "Basic " + loginData.base64EncodedStringWithOptions(nil)
        
        // create the request
        var urlString = "https://desolate-bayou-9128.herokuapp.com/groups/\(groupName)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let urlConnection = NSURLConnection(request: request, delegate: self)
    }
    
    func buildGroup(newGroup: [String: AnyObject]){
        let _id = newGroup["_id"]! as! String
        let creator = newGroup["creator"] as! String
        let name = newGroup["name"] as! String
        let orders = newGroup["orders"] as! [String]
        let users = newGroup["users"] as! [String]
        group = Group(_id: _id, creator: creator, name: name, orders: orders, users: users)
        success()
    }
    
    func success(){
        // Create the alert controller
        var alertController = UIAlertController(title: "Groep aangemaakt!", message: "\(group.name), is toegevoegd aan uw account", preferredStyle: .Alert)
        
        // Create the actions
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.finishUp()
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func finishUp(){
        self.groupNameField.text = ""
        self.oldController.groups.append(self.group)
        self.oldController.groupTableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
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
        createButton.enabled = true
        activityIndicator.hidden = true
        if(self.lastStatusCode == 200){
            let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! [String: AnyObject]!
            let newGroup = json["data"] as! [String: AnyObject]!
            buildGroup(newGroup)
        } else {
            var alert = UIAlertController(title: "Oh nee!", message: "Er is iets mis gegaan tijdens het aanmaken van uw groep!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Sluiten", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
