//
//  DishesController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 10/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit
import AudioToolbox

class DishesController: UIViewController, NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dishTextField: UITextField!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var dishesTableView: UITableView!
    var noOrdersLabel: UILabel?
    var receivedOrder: Order!
    var dishes: [Dish]! = []
    var lastStatusCode = 1
    var data: NSMutableData = NSMutableData()
    var loaded: Bool! = false
    var lastOperation: String!
    var activityIndicator: UIActivityIndicatorView!
    var oldController: OrderListController!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!loaded){
            dishesTableView.hidden = true
            titleBar.title = "\(receivedOrder.niceDate)"
            startActivityIndicator()
        }
        
        let base64LoginString = defaults.valueForKey("authHeader") as! String
        
        // create the request
        let url = NSURL(string: "https://desolate-bayou-9128.herokuapp.com/orders/\(receivedOrder._id)/dishes")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        
        var backgroundView = UIView(frame: CGRectZero)
        self.dishesTableView.tableFooterView = backgroundView
        self.dishesTableView.backgroundColor = UIColor.clearColor()
        
        if(!loaded){
            lastOperation = "getDishes"
            let urlConnection = NSURLConnection(request: request, delegate: self)
        }
        loaded = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if(receivedOrder.snackbarName != "Overig"){
            dishTextField.placeholder = receivedOrder.snackbarName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapMainView(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func finish(sender: UIButton) {
        // create the request
        let base64LoginString = defaults.valueForKey("authHeader") as! String
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://desolate-bayou-9128.herokuapp.com/orders/\(receivedOrder._id)")!)
        request.HTTPMethod = "PUT"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        lastOperation = "finish"
        startActivityIndicator()
        let urlConnection = NSURLConnection(request: request, delegate: self)
    }
    
    @IBAction func place(sender: UIButton) {
        if(count(dishTextField.text) > 0){
            // create the request
            let base64LoginString = defaults.valueForKey("authHeader") as! String
            
            let request = NSMutableURLRequest(URL: NSURL(string: "https://desolate-bayou-9128.herokuapp.com/orders/\(receivedOrder._id)/dish")!)
            request.HTTPMethod = "POST"
            let postString = "dish=" + dishTextField.text
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
            lastOperation = "placeDish"
            startActivityIndicator()
            let urlConnection = NSURLConnection(request: request, delegate: self)
        } else {
            var alert = UIAlertController(title: "Oeps!", message: "De bestelling moet ingevuld zijn!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Sluiten", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
                case "getDishes":
                afterGetDishes()
                case "placeDish":
                afterPlaceDish()
                case "finish":
                afterFinish()
            default:
                println("Default case called in lastOperation switch")
            }
        } else {
            println(data)
            println(lastStatusCode)
            println("Something went wrong, statusCode wasn't 200")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as! DishCell
        cell.dishLabel.text = "\(dishes[indexPath.row].dish)"
        cell.creatorLabel.text = "\(dishes[indexPath.row].creator)"
        return cell
    }
    
    func startActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.frame = self.view.frame
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor(red: 251/255, green: 169/255, blue: 7/255, alpha: 1)
        activityIndicator.startAnimating()
        self.view.addSubview( activityIndicator )
    }
    
    func noOrdersYet(){
        noOrdersLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
        noOrdersLabel!.frame = self.scrollView.frame
        noOrdersLabel!.center = self.scrollView.center
        noOrdersLabel!.textAlignment = NSTextAlignment.Center
        noOrdersLabel!.text = "Nog geen bestellingen!"
        noOrdersLabel!.textColor = UIColor.blackColor()

        self.scrollView.addSubview(noOrdersLabel!)
    }
    
    func afterPlaceDish(){
        var vibrate = true
        if(defaults.valueForKey("vibrate") != nil){
            vibrate = defaults.valueForKey("vibrate") as! Bool
        }
        if(vibrate == true){
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        dishTextField.text = ""
        let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! [String: AnyObject]!
        let receivedDish = json["dish"] as! [String: AnyObject]!
        let _id = receivedDish["_id"]! as! String
        let order_id = receivedDish["order_id"]! as! String
        let creator = receivedDish["creator"]! as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(receivedDish["date"]! as! String)!
        let dish = receivedDish["dish"]! as! String
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var niceDate = dateFormatter.stringFromDate(date)
        self.dishes.append(Dish(_id: _id, order_id: order_id, creator: creator, date: date, dish: dish, niceDate: niceDate))
        self.dishesTableView.reloadData()
        self.view.endEditing(true)
        activityIndicator.removeFromSuperview()
        decideToShowTableViewOrNot()
    }
    
    func afterGetDishes(){
        let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let receivedDishes = json as! [[String :AnyObject]]!
        
        //Iterate through the received dishes to make actual dish objects
        for  dish in receivedDishes {
            let _id = dish["_id"]! as! String
            let order_id = dish["order_id"]! as! String
            let creator = dish["creator"]! as! String
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date = dateFormatter.dateFromString(dish["date"]! as! String)!
            let dish = dish["dish"]! as! String
            dateFormatter.dateFormat = "dd-MM-yyyy"
            var niceDate = dateFormatter.stringFromDate(date)
            self.dishes.append(Dish(_id: _id, order_id: order_id, creator: creator, date: date, dish: dish, niceDate: niceDate))
            dishesTableView.reloadData()
        }
        activityIndicator.removeFromSuperview()
        decideToShowTableViewOrNot()
    }
    
    func decideToShowTableViewOrNot(){
        if(dishes.count == 0 && noOrdersLabel == nil){
            noOrdersYet()
        }
        else if (dishes.count != 0 && noOrdersLabel != nil){
            noOrdersLabel?.removeFromSuperview()
            dishesTableView.hidden = false
            dishesTableView.reloadData()
        } else {
            dishesTableView.hidden = false
            dishesTableView.reloadData()
        }
    }
    
    func afterFinish(){
        receivedOrder.active = false
        oldController.tableView.reloadData()
        activityIndicator.removeFromSuperview()
        var alert = UIAlertController(title: "Gelukt!", message: "Deze bestelling is nu afgerond!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func callSnackbar(sender: UIButton) {
        if(receivedOrder.snackbarName != "Overig" && receivedOrder.snackbarPhone != nil && receivedOrder.snackbarPhone != "0"){
            var phoneNumber = receivedOrder.snackbarPhone
            var phone = phoneNumber.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
           
            var phoneString = "tel://\(phone)"
            var url:NSURL = NSURL(string: phoneString)!
            UIApplication.sharedApplication().openURL(url)
        }
        else{
            var alert = UIAlertController(title: "Sorry!", message: "Deze snackbar heeft geen telefoonnummer!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
