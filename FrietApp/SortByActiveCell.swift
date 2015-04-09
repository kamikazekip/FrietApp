//
//  SettingsCell.swift
//  FrietApp
//
//  Created by Erik Brandsma on 09/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class SortByActiveCell: UITableViewCell {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    @IBAction func onChange(sender: UISwitch) {
        defaults.setValue(sender.on, forKey: "sortByActive")
        defaults.synchronize()
    }
}
