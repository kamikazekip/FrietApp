//
//  orderCell.swift
//  FrietApp
//
//  Created by Erik Brandsma on 08/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class OrderCell : UITableViewCell {
    
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var title: UILabel!
    var order: Order!
}