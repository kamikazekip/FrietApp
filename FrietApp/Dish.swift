//
//  Dish.swift
//  FrietApp
//
//  Created by Erik Brandsma on 10/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import Foundation

class Dish {
    //_id: _id, order_id: order_id, creator: creator, date: date, dish: dish, niceDate: niceDate
    var _id: String!
    var order_id: String!
    var creator: String!
    var date: NSDate!
    var dish: String!
    var niceDate: String!
    
    init(_id: String, order_id: String, creator: String, date: NSDate, dish: String, niceDate: String){
        self._id = _id
        self.order_id = order_id
        self.creator = creator
        self.date = date
        self.dish = dish
        self.niceDate = niceDate
    }
}
