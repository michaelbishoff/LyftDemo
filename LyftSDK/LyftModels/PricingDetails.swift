import Mapper

/// Pricing information related to a ride type
public struct PricingDetails {
    /// The initial charge for a ride. This is the fee applied before ride specific costs
    public let baseCharge: Money
    /// The charge amount if cancel penalty is involved
    public let cancelPenalty: Money
    /// The minimum price a ride with this ride type will cost
    public let costMinimum: Money
    /// The cost per mile during a ride
    public let costPerMile: Money
    /// The cost per minute during a ride
    public let costPerMinute: Money
    /// The trust and service fee
    public let trustAndServiceFee: Money
}

extension PricingDetails: Mappable {
    public init(map: Mapper) throws {
        let currencyCode: String = try map.from("currency")
        let transform = Transform.toMoney(currencyCode: currencyCode)

        try baseCharge          = map.from("base_charge", transformation: transform)
        try cancelPenalty       = map.from("cancel_penalty_amount", transformation: transform)
        try costMinimum         = map.from("cost_minimum", transformation: transform)
        try costPerMile         = map.from("cost_per_mile", transformation: transform)
        try costPerMinute       = map.from("cost_per_minute", transformation: transform)
        try trustAndServiceFee  = map.from("trust_and_service", transformation: transform)
    }
}
