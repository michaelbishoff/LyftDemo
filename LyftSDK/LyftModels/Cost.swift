// swiftlint:disable documentation_comments
import Mapper

/// Cost and detail estimations for a pickup and destination
public struct RideCostEstimate {
    /// Maximum estimated cost
    public let maxEstimate: Money
    /// Minimum estimated cost
    public let minEstimate: Money
    /// Duration in seconds
    public let durationSeconds: Int
    /// Distance in miles
    public let distanceMiles: Double
}

extension RideCostEstimate: Mappable {
    public init(map: Mapper) throws {
        let currency: String? = map.optionalFrom("currency")
        let transform = Transform.toMoney(currencyCode: currency)

        try durationSeconds = map.from("estimated_duration_seconds")
        try distanceMiles   = map.from("estimated_distance_miles")
        try maxEstimate    = map.from("estimated_cost_cents_max", transformation: transform)
        try minEstimate     = map.from("estimated_cost_cents_min", transformation: transform)
    }
}

/// Cost estimation for a ride
public struct Cost {
    /// The unique ride type key
    public let rideKind: RideKind
    /// A human readable description of the ride type
    public let displayName: String
    /// A human readable prime time percentage text
    public let primeTimePercentageText: String
    /// The estimated costs and information. Requires have a destination in the request.
    public let estimate: RideCostEstimate?
}

extension Cost: Mappable {
    public init(map: Mapper) throws {
        try rideKind                = map.from("ride_type")
        try primeTimePercentageText = map.from("primetime_percentage")
        try displayName             = map.from("display_name")
        estimate                    = map.optionalFrom("")
    }
}
