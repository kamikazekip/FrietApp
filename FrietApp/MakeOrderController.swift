//
//  MakeOrderController.swift
//  FrietApp
//
//  Created by Erik Brandsma on 10/04/15.
//  Copyright (c) 2015 Erik Brandsma. All rights reserved.
//

import UIKit
import CoreLocation

class MakeOrderController: UIViewController, CLLocationManagerDelegate {

    var oldController: OrderListController!
    let locationManager = CLLocationManager()
    
    var latitude: Double!
    var longtitude: Double!
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("HALLO")
        var locValue : CLLocationCoordinate2D = manager.location.coordinate
        println(locValue)
        locationManager.stopUpdatingLocation()
        getSnackbarsWithLocation(locValue.latitude, longtitude: locValue.longitude)
    }
    
    func getSnackbarsWithLocation(latitude: Double, longtitude: Double){
        println(latitude)
        println(longtitude)
    }
}
