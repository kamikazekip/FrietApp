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

    var oldController: OrderListController!
    let locationManager = CLLocationManager()
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var lastStatusCode = 1
    var data: NSMutableData = NSMutableData()
    var snackbars: [Snackbar]! = []
    
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
        println(latitude)
        println(longtitude)
        let base64LoginString = defaults.valueForKey("authHeader") as! String
        println(base64LoginString)
        // create the request
        var urlString = "https://desolate-bayou-9128.herokuapp.com/snackbars/?lat=\(latitude)&long=\(longtitude)"

        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        
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
            let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            println(json)
            let receivedSnackbars = json as! [[String :AnyObject]]!
            println(receivedSnackbars)
            for snackbar in receivedSnackbars {
                let name = snackbar["snackbar"]! as! String
                let url  = snackbar["url"]! as! String
                snackbars.insert(Snackbar(name: name, url: url), atIndex: 0)
            }
            println(snackbars)
        } else {
            println("Something went wrong, statusCode wasn't 200")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snackbars.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("snackbarCell") as! OrderCell
        
        return cell
    }
}
