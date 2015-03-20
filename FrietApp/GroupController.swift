//
//  GroupController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 20/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class GroupController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var groups : [String] = ["Vrienden", "Werk", "Familie"]
    var numbers: [String] = ["25", "2", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as UITableViewCell
        cell.textLabel?.text = groups[indexPath.row]
        cell.detailTextLabel?.text = numbers[indexPath.row]
        return cell
    }
}
