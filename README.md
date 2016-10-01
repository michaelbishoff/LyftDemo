# Lyft iOS SDK **Preview**
Setup: [Hard Mode](https://github.com/michaelbishoff/LyftDemo/tree/master/LyftSDK) (Integrate SDK into existing project)  

Setup: Easy Mode (Start with a clean projec that only includes the SDK)  
1. `git clone https://github.com/michaelbishoff/LyftDemo.git`  
2. `git checkout easy-mode`  
3. `pod install`  
4. `open TestLyft.xcworkspace` Convert/Next/Save/Unlock anything that pops up (it will fail at the end)  
5. Build LyftAPI  
6. [Create a Lyft API App](https://www.lyft.com/developers/manage)  
7. Copy your `token` and `client_id` to the file `TestLyft/Keys.swift`  
8. Use the TestLyft project in Xcode as your main project  

# Tutorial
Pre-setup:
[Install Xcode 8](https://developer.apple.com/download/)  

Step 0: Follow the Easy Mode setup above, and SKIP step 2  
Step 1: Populate Ride Types
```
LyftAPI.rideTypes(at: location.coordinate, completion: { result in
                    switch result {
                    case .success(let rideTypes):
                        self.rideTypes = rideTypes
                        self.setRideType(rideTypes.first!)
                    case .failure(let error):
                        print(error)
                    }
                })
```
Step 2: Select Ride Type Action
```
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
```
Step 3: Set Drop-off / Pickup
```
CLGeocoder().reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if let placemark = placemarks?.first {
                let label: UILabel = type == .pickup ? self.pickupLabel : self.dropoffLabel
                label.text = (type == .pickup ? "Pickup: " : "Dropoff: ") + (placemark.name ?? "")
                self.pickupPlacemark = placemark
            }
        }
```
Step 4: Add Request Button on Storyboard  
Step 5: Deep Link to Lyft Action
```
@IBAction func requestRideButtonPressed(_ sender: AnyObject) {
        guard let rideType = self.selectedRideType else {
            return
        }
        LyftDeepLink.requestRide(rideType.kind, from: self.pickupPlacemark?.location?.coordinate, to: self.dropoffPlacemark?.location?.coordinate, couponCode: "")
    }
```