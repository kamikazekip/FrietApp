//
//  MakeOrderController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 10/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit
import CoreLocation

class MakeOrderController: UIViewController, NSURLConnectionDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var snackbarsTableView: UITableView!
    var oldController: OrderListController!
    var receivedGroup: Group!
    let locationManager = CLLocationManager()
    var activityIndicator: UIActivityIndicatorView!
    var lastOperation: String!
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var lastStatusCode = 1
    var data: NSMutableData = NSMutableData()
    var snackbars: [Snackbar]! = [Snackbar(name: "Overig", url: "Sorry, geen url")]
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue : CLLocationCoordinate2D = manager.location.coordinate
        locationManager.stopUpdatingLocation()
        getSnackbars(locValue.latitude, longtitude: locValue.longitude)
    }
    
    func getSnackbars(latitude: Double, longtitude: Double){
        startActivityIndicator()
        let base64LoginString = defaults.valueForKey("authHeader") as! String
        // create the request
        var urlString = "https://desolate-bayou-9128.herokuapp.com/snackbars/?lat=\(latitude)&long=\(longtitude)"

        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        lastOperation = "getSnackbars"
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
        if(self.lastStatusCode == 200){
            switch(lastOperation){
            case "getSnackbars":
                makeSnackbars()
            case "postSnackbar":
                addSnackbar()
            default:
                println("Default method called on lastOperation switch!")
            }
        } else {
            println("Something went wrong, statusCode wasn't 200")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snackbars.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("snackbarCell") as! SnackbarCell
        cell.snackbar = self.snackbars[indexPath.row]
        cell.snackbarLabel.text = self.snackbars[indexPath.row].name
        if(self.snackbars[indexPath.row].name == "Overig"){
            cell.websiteButton.hidden = true
            println("hidden: \(snackbars[indexPath.row].name)")
        } else {
            cell.websiteButton.hidden = false
            println("revealed: \(snackbars[indexPath.row].name)")
        }
        if indexPath.row % 2 != 0 {
            cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            cell.websiteButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // create the request
        let base64LoginString = defaults.valueForKey("authHeader") as! String
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://desolate-bayou-9128.herokuapp.com/groups/\(receivedGroup._id)/order")!)
        request.HTTPMethod = "POST"
        let postString = "snackbar=" + snackbars[indexPath.row].name + "&url=" + snackbars[indexPath.row].url
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        lastOperation = "postSnackbar"
        let urlConnection = NSURLConnection(request: request, delegate: self)
    }
    
    func makeSnackbars(){
        let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let receivedSnackbars = json as! [[String :AnyObject]]!
        for snackbar in receivedSnackbars {
            let name = snackbar["snackbar"]! as! String
            let url  = snackbar["url"]! as! String
            if(name != "Overig"){
                snackbars.insert(Snackbar(name: name, url: url), atIndex: 0)
            }
        }
        activityIndicator.removeFromSuperview()
        snackbarsTableView.reloadData()
    }
    
    func addSnackbar(){
        let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! [String: AnyObject]!
        let order = json["order"] as! [String: AnyObject]!
        let _id = order["_id"]! as! String
        let active = order["active"]! as! Bool
        let group_id = order["group_id"]! as! String
        let creator = order["creator"]! as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(order["date"]! as! String)!
        let snackbarName = order["snackbar"]!["snackbar"]! as! String
        let snackbarUrl = order["snackbar"]!["url"]! as! String
        let dishes = order["dishes"]! as! [String]
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var niceDate = dateFormatter.stringFromDate(date)
        var newOrder = Order(_id: _id, active: active, group_id: group_id, date: date, creator: creator, snackbarName: snackbarName, snackbarUrl: snackbarUrl, dishes: dishes, niceDate: niceDate)
        finishUp(newOrder)
    }
    
    func finishUp(order: Order){
        self.oldController.orders.insert(order, atIndex: 0)
        self.oldController.tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func startActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.frame = self.view.frame
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor(red: 251/255, green: 169/255, blue: 7/255, alpha: 1)
        activityIndicator.startAnimating()
        self.view.addSubview( activityIndicator )
    }
}
