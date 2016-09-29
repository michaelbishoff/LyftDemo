import Mapper

/// The details of a ride type offered by the Lyft platform
public struct RideType {
    /// The unique ride type key
    public let kind: RideKind
    /// A human readable description of the ride type
    public let displayName: String
    /// Icon representing this ride type
    public let imageURL: String?
    /// The number of passengers a car can fit
    public let numberOfSeats: Int
    /// Pricing information related to this ride type
    public let pricingDetails: PricingDetails
}

extension RideType: Mappable {

    public init(map: Mapper) throws {
        try kind            = map.from("ride_type")
        try displayName     = map.from("display_name")
        try numberOfSeats   = map.from("seats")
        try pricingDetails  = map.from("pricing_details")
        imageURL            = map.optionalFrom("image_url")
    }
}
