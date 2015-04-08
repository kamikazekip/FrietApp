//
//  Group.swift
//  FrietApp
//
//  Created by Erik Brandsma on 08/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import Foundation

class Group {
    var _id: String!
    var creator: String!
    var name: String!
    var orders: [String]!
    var users: [String]!
    var numberOfOrders = 0
    
    init(_id: String, creator: String, name: String, orders: [String], users: [String]){
        self._id = _id
        self.creator = creator
        self.name = name
        self.orders = orders
        self.users = users
        for order in orders{
            numberOfOrders++
        }
    }
}
