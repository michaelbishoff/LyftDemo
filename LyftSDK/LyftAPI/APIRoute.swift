import Foundation

/// API request routes, each case is a string with optional parameters built off the baseURL.
enum APIRoute {
    /// Base API URL to create requests from
    static var baseURL = URL(string: "https://api.lyft.com")!

    case ETA
    case RideTypes
    case CostEstimates
    case NearbyDrivers
}

extension APIRoute: Routable {

    /// The URL string of the combined URL
    var url: URL {
        let path: String = {
            switch self {
                case .ETA:
                    return "/v1/eta"

                case .RideTypes:
                    return "/v1/ridetypes"

                case .CostEstimates:
                    return "/v1/cost"

                case .NearbyDrivers:
                    return "/v1/drivers"
            }
        }()

        return URL(string: path, relativeTo: APIRoute.baseURL)!
    }

    /// A dictionary of key, values to append to the HTTP request headers. Authentication should be included.
    var extraHTTPHeaders: [String: String] {
        var extraHeaders: [String: String] = [:]

        if let token = LyftConfiguration.developer?.token {
            extraHeaders["Authorization"] = "Bearer \(token)"
        }

        return extraHeaders
    }
}
