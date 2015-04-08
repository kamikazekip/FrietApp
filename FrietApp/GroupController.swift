//
//  GroupController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 20/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class GroupController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var receivedGroups: [[String: AnyObject]]!
    var groups: [Group]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groups = []
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        myBackButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("Uitloggen", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        for group in receivedGroups {
            let _id = group["_id"]! as String
            let creator = group["creator"]! as String
            let name = group["name"]! as String
            let orders = group["orders"]! as [String]
            let users = group["users"]! as [String]
            groups.append(Group(_id: _id, creator: creator, name: name, orders: orders, users: users))
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as GroupCell
        cell.groupName.text = groups[indexPath.row].name
        cell.numberOfOrders.text = "\(groups[indexPath.row].numberOfOrders)"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toGroupOrders"){
            var cell = sender as GroupCell!
            var secondController = segue.destinationViewController as OrderListController
            secondController.receivedGroupname = cell.groupName.text
        }
    }
}
