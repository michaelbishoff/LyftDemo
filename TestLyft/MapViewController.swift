import UIKit
import MapKit
import CoreLocation
import LyftAPI
import LyftModels
import PromiseKit

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

    @IBAction func selectRideType(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Select ride type", message: nil, preferredStyle: .actionSheet)
        for rideType in rideTypes {
            alert.addAction(UIAlertAction(title: rideType.displayName, style: .default) { (action: UIAlertAction) in
                self.setRideType(rideType)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

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

    @IBAction func actionButtonPressed(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
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

                LyftAPI.rideTypes(at: location.coordinate, completion: { result in
                    switch result {
                    case .success(let rideTypes):
                        self.rideTypes = rideTypes
                        self.setRideType(rideTypes.first!)
                    case .failure(let error):
                        print(error)
                    }
                })

                CLGeocoder().reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
                    if let placemark = placemarks?.first {
                        self.pickupLabel.text = "Pickup: " + (placemark.name ?? "")
                        self.pickupPlacemark = placemark
                    }
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let coordinate = mapView.region.center
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if let placemark = placemarks?.first {
                self.dropoffLabel.text = "Dropoff: " + (placemark.name ?? "")
                self.dropoffPlacemark = placemark
            }
        }
    }
}


