//
//  MapViewController.swift
//  TestLyft
//
//  Created by Michael Bishoff on 9/7/16.
//  Copyright © 2016 Michael Bishoff. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if we have permission to use location while app is in foreground
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            // We already have permission:
            self.locationManager.startUpdatingLocation()
        } else {
            // Show prompt for location permission
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        // Set location manager delegate to self:
        self.locationManager.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            print("Rejected location permission")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
            let adjustedRegion = self.mapView.regionThatFits(viewRegion)
            self.mapView.setRegion(adjustedRegion, animated: true)
        }
    }
}