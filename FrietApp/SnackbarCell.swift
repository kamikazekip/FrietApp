//
//  SnackBarCellTableViewCell.swift
//  FrietApp
//
//  Created by User on 10/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class SnackbarCell: UITableViewCell {

    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var snackbarLabel: UILabel!
    var snackbar: Snackbar!
    
    @IBAction func openUrl(sender: UIButton) {
        if let url = NSURL(string: snackbar.url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
