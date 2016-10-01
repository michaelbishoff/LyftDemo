import UIKit
import MapKit
import CoreLocation
import LyftAPI
import LyftModels
import PromiseKit

fileprivate enum LocationType {
    case pickup
    case dropoff
}

class MapViewController: UIViewController {

    @IBOutlet weak var rideTypeImageView: UIImageView!
    @IBOutlet weak var rideTypeLabel: UILabel!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    var firstLocation: CLLocation?
    var pickupPlacemark: CLPlacemark?
    var dropoffPlacemark: CLPlacemark?
    var rideTypes: [RideType] = []
    var selectedRideType: RideType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if we have permission to use location while app is in foreground
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // We already have permission:
            self.locationManager.startUpdatingLocation()
        } else {
            // Show prompt for location permission
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        // Set location manager delegate to self:
        self.locationManager.delegate = self
        self.mapView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // STEP 2: Select Ride Type Action
    
    
    
    fileprivate func setRideType(_ rideType: RideType) {
        self.selectedRideType = rideType
        self.rideTypeLabel.text = rideType.displayName
        self.rideTypeImageView.image = nil
        if let url = URL(string: rideType.imageURL ?? "") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    self.rideTypeImageView.image =  UIImage(data: data)
                } else {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    fileprivate func populateLocationLabel(location: CLLocation, type: LocationType) {
        // STEP 3: Set Drop-off / Pickup
        
        
    }
    
    // STEP 5: Deep Link to Lyft Action
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            print("Rejected location permission")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if self.firstLocation == nil {
                self.firstLocation = location
                let viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                let adjustedRegion = self.mapView.regionThatFits(viewRegion)
                self.mapView.setRegion(adjustedRegion, animated: true)
                manager.stopUpdatingLocation()

                // STEP 1: Populate Ride Types
                
                
                populateLocationLabel(location: location, type: .pickup)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    /*
     * Get the center of the map and set it as the pickup location
     */
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let coordinate = mapView.region.center
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        populateLocationLabel(location: location, type: .dropoff)
    }
}


