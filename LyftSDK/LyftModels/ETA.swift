import Mapper

/// Represents the estimated time in seconds it will take for the nearest driver to reach the specified
/// location for a given ride type
public struct ETA {
    /// The ride type represented by this ETA
    public let rideKind: RideKind
    /// Seconds estimation for the nearest driver to reach a given location
    public let seconds: Int
    /// Minutes estimation for the nearest driver to reach a given location
    public var minutes: String {
        return String(max(self.seconds / 60, 1))
    }
}

extension ETA: Mappable {
    public init(map: Mapper) throws {
        try rideKind = map.from("ride_type")
        try seconds  = map.from("eta_seconds")
    }
}
