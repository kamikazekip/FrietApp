//
//  GroupController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 20/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class GroupController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var receivedGroups: AnyObject!
    var groups : [String] = ["Vrienden", "Werk", "Familie"]
    var numbers: [String] = ["25", "2", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        myBackButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("Uitloggen", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popToRoot(sender:UIBarButtonItem){
        println("Uitloggen")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as GroupCell
        cell.groupName.text = groups[indexPath.row]
        cell.numberOfOrders.text = numbers[indexPath.row]
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
