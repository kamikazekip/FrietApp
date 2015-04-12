//
//  OrderListController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 20/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class OrderListController: UIViewController, NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate {

    var lastStatusCode = 1
    var data: NSMutableData = NSMutableData()
    var orders: [Order]! = []
    @IBOutlet weak var tableView: UITableView!
    var receivedGroup : Group!
    var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleBarTitle: UINavigationItem!
    var sortByActive: Bool?
    let defaults = NSUserDefaults.standardUserDefaults()
    var loaded: Bool! = false
    var selectedIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var backgroundView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = backgroundView
        self.tableView.backgroundColor = UIColor.clearColor()
        sortByActive = defaults.valueForKey("sortByActive") as? Bool
        if (sortByActive == nil ) {
            sortByActive = true
        }
        if(!loaded){
            startActivityIndicator()
        }
        
        
        let base64LoginString = defaults.valueForKey("authHeader") as! String
        
        // create the request
        var urlString = "https://desolate-bayou-9128.herokuapp.com/groups/\(receivedGroup._id)/orders"
        if(sortByActive == true){
            urlString += "?orderBy=active"
        }
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        if(!loaded){
            let urlConnection = NSURLConnection(request: request, delegate: self)
        }
        loaded = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        activityIndicator.removeFromSuperview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if(selectedIndex != nil){
            tableView.deselectRowAtIndexPath(selectedIndex!, animated: true)
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
            let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            let receivedOrders = json as! [[String :AnyObject]]!
        
            for order in receivedOrders {
                let _id = order["_id"]! as! String
                let active = order["active"]! as! Bool
                let group_id = order["group_id"]! as! String
                let creator = order["creator"]! as! String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let date = dateFormatter.dateFromString(order["date"]! as! String)!
                let snackbarName = order["snackbar"]!["snackbar"]! as! String
                let snackbarUrl = order["snackbar"]!["url"]! as! String
                let snackbarPhone = order["snackbar"]!["telephone"]! as! String
                let dishes = order["dishes"]! as! [String]
                dateFormatter.dateFormat = "dd-MM-yyyy"
                var niceDate = dateFormatter.stringFromDate(date)
                self.orders.append(Order(_id: _id, active: active, group_id: group_id, date: date, creator: creator, snackbarName: snackbarName, snackbarUrl: snackbarUrl, snackbarPhone: snackbarPhone, dishes: dishes, niceDate: niceDate))
            }
            activityIndicator.hidden = true
            tableView.hidden = false
            tableView.reloadData()
        } else {
            println("Something went wrong, statusCode wasn't 200")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("orderCell") as! OrderCell
        cell.title.text = "\(orders[indexPath.row].niceDate)"
        var creator = orders[indexPath.row].creator
        cell.creator.text = "\(creator)"
        cell.order = orders[indexPath.row]
        var active: Bool! = orders[indexPath.row].active
        if(active == true){
            cell.title.textColor = UIColor(red: 13/255, green: 212/255, blue: 0/255, alpha: 1)
            cell.creator.textColor = UIColor(red: 13/255, green: 212/255, blue: 0/255, alpha: 1)
        } else {
            cell.title.textColor = UIColor.blackColor()
            cell.creator.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    func startActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.frame = self.view.frame
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor(red: 251/255, green: 169/255, blue: 7/255, alpha: 1)
        activityIndicator.startAnimating()
        self.view.addSubview( activityIndicator )
        tableView.hidden = true
        titleBarTitle.title = "\(receivedGroup.name)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toDishes"){
            var dishesController = segue.destinationViewController as! DishesController
            var cellOrder = sender as! OrderCell
            dishesController.receivedOrder = cellOrder.order
            dishesController.oldController = self
        }
        if(segue.identifier == "toAddOrder"){
            var makeOrderController = segue.destinationViewController as! MakeOrderController
            makeOrderController.oldController = self
            makeOrderController.receivedGroup = self.receivedGroup
        }
        if(segue.identifier == "toAddUser"){
            var addUserController = segue.destinationViewController as! AddUserController
            addUserController.receivedGroup = self.receivedGroup
        }
    }
}