//
//  SettingsController.swift
//  FrietApp
//
//  Created by User on 08/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var sortByActive: Bool?
    var vibrate: Bool?
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortByActive = defaults.valueForKey("sortByActive") as? Bool
        println(sortByActive)
        vibrate = defaults.valueForKey("vibrate") as? Bool
        if (sortByActive == nil ) {
            defaults.setValue(true, forKey: "sortByActive")
            sortByActive = true
        }
        if(vibrate == nil) {
            defaults.setValue(true, forKey: "vibrate")
            vibrate = true
        }
        println(sortByActive)
        
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            var cell = tableView.dequeueReusableCellWithIdentifier("orderByActiveCell") as! SortByActiveCell
            cell.mySwitch.on = sortByActive as Bool!
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("vibrateCell") as! VibrateCell!
            cell.mySwitch.on = vibrate as Bool!
            return cell
        }
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0:
            return "Bestellingen"
        case 1:
            return "Vibreren"
        default:
            return ""
        }
    }
}
