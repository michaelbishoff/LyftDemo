import UIKit
import CoreLocation

/// Collection of deep links into the main Lyft application
public struct LyftDeepLink {
    /// Prepares to request a ride with the given parameters
    ///
    /// - parameter kind:                   The kind of ride to create a request for
    /// - parameter pickup:                 The pickup position of the ride
    /// - parameter destination:            The destination position of the ride
    /// - parameter couponCode              A coupon code to be applied to the user
    ///
    /// - returns:  true if the deeplink was successfully launched
    @discardableResult public static func requestRide(_ kind: RideKind,
                                                      from pickup: CLLocationCoordinate2D? = nil,
                                                      to destination: CLLocationCoordinate2D? = nil,
                                                      couponCode: String? = nil) -> Bool
    {
        var parameters = ["id": kind.rawValue]

        if let pickup = pickup {
            parameters["pickup[latitude]"] = String(pickup.latitude)
            parameters["pickup[longitude]"] = String(pickup.longitude)
        }

        if let destination = destination {
            parameters["destination[latitude]"] = String(destination.latitude)
            parameters["destination[longitude]"] = String(destination.longitude)
        }

        parameters["partner"] = LyftConfiguration.developer?.clientId
        parameters["credits"] = couponCode

        return self.launch("ridetype", parameters: parameters)
    }

    fileprivate static func launch(_ action: String, parameters: [String: String]?) -> Bool {
        var requestURLComponents = URLComponents()
        requestURLComponents.scheme = "lyft"
        requestURLComponents.host = action
        requestURLComponents.queryItems = parameters?.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        if let url = requestURLComponents.url {
            return UIApplication.shared.openURL(url)
        } else {
            return false
        }
    }
}
