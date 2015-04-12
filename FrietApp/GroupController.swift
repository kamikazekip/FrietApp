//
//  GroupController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 20/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class GroupController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupTableView: UITableView!
    var receivedGroups: [[String: AnyObject]]!
    var oldController: LoginController!
    var groups: [Group]! = []
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var selectedIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for group in receivedGroups {
            let _id = group["_id"]! as! String
            let creator = group["creator"]! as! String
            let name = group["name"]! as! String
            let orders = group["orders"]! as! [String]
            let users = group["users"]! as! [String]
            self.groups.append(Group(_id: _id, creator: creator, name: name, orders: orders, users: users))
        }
        var backgroundView = UIView(frame: CGRectZero)
        self.groupTableView.tableFooterView = backgroundView
        self.groupTableView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController() == true){
            oldController.usernameField.text = ""
            oldController.passwordField.text = ""
            defaults.setValue("", forKey: "authHeader")
            defaults.synchronize()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if(selectedIndex != nil){
            groupTableView.deselectRowAtIndexPath(selectedIndex!, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as! GroupCell
        cell.groupName.text = groups[indexPath.row].name
        cell.numberOfOrders.text = "\(groups[indexPath.row].numberOfOrders)"
        cell.group = groups[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toGroupOrders"){
            var cell = sender as! GroupCell!
            var secondController = segue.destinationViewController as! OrderListController
            secondController.receivedGroup = cell.group
        }
        if(segue.identifier == "toMakeGroup"){
            var secondController = segue.destinationViewController as! NewGroupController
            secondController.oldController = self
        }
    }
}
