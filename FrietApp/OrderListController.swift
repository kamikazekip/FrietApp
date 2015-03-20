//
//  OrderListController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 20/03/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit

class OrderListController: UIViewController {

    var receivedGroupname : String!
    
    @IBOutlet weak var titleBarTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBarTitle.title = receivedGroupname
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
