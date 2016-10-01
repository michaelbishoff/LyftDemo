//
//  MainViewController.swift
//  TestLyft
//
//  Created by Michael Bishoff on 10/1/16.
//  Copyright © 2016 Michael Bishoff. All rights reserved.
//

import UIKit
import CoreLocation
import LyftAPI
import LyftModels

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the Lyft API!
        let location = CLLocationCoordinate2D(latitude: 39.253848, longitude: -76.714300)
        LyftAPI.rideTypes(at: location) { (result: Result<[RideType], LyftAPIError>) in
            switch result {
            case .success(let rideTypes):
                print(rideTypes)
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
