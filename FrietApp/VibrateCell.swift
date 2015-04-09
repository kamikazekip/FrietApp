//
//  VibrateCell.swift
//  FrietApp
//
//  Created by Erik Brandsma on 09/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class VibrateCell: UITableViewCell {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    @IBAction func onSwitch(sender: UISwitch) {
        defaults.setValue(sender.on, forKey: "vibrate")
        defaults.synchronize()
    }
}
