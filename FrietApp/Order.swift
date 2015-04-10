//
//  Order.swift
//  FrietApp
//
//  Created by Erik Brandsma on 08/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import Foundation

class Order {
    var _id: String!
    var active: Bool!
    var group_id: String!
    var date: NSDate!
    var creator: String!
    var snackbarName: String!
    var snackbarUrl: String!
    var dishes: [String]!
    var niceDate: String!
    
    init(_id: String, active: Bool, group_id: String, date: NSDate, creator: String,
        snackbarName: String, snackbarUrl: String, dishes: [String], niceDate: String){
        self._id = _id
        self.active = active
        self.group_id = group_id
        self.date = date
        self.creator = creator
        self.snackbarName = snackbarName
        self.snackbarUrl = snackbarUrl
        self.dishes = dishes
        self.niceDate = niceDate
    }
}