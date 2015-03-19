//
//  OverviewController.swift
//  FrietApp
//
//  Created by User on 11/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class OverviewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    var receivedUsername: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = receivedUsername
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
