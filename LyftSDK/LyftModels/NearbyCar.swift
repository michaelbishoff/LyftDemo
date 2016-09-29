import CoreLocation
import Mapper

/// Locations of drivers near a location by ride type
public struct NearbyDrivers {
    /// Nearby drivers organized by ride kind
    let driversByKind: [RideKind: [NearbyDriver]]

    /// Subscript returns the nearby cars for a given ride kind
    ///
    /// - parameter kind:   The ride kind to get the nearby cars for
    ///
    /// - returns:  The cars nearby a position for a give ride kind
    public subscript(kind: RideKind) -> [NearbyDriver]? {
        return self.driversByKind[kind]
    }
}

extension NearbyDrivers: Mappable {
    public init(map: Mapper) throws {
        try driversByKind = map.from("nearby_drivers", transformation: driversByKindFromObject)
    }
}

/// Representation of a driver nearby a position
public struct NearbyDriver {
    /// The positions of a driver in ascending order
    public let recentPositions: [CLLocationCoordinate2D]
    /// The most recent position of the driver
    public var position: CLLocationCoordinate2D? { return self.recentPositions.last }
}

extension NearbyDriver: Mappable {
    public init(map: Mapper) throws {
        try recentPositions = map.from("locations")
    }
}

private func driversByKindFromObject(object: Any) throws -> [RideKind: [NearbyDriver]] {
    guard let objects = object as? [NSDictionary] else {
        throw MapperError.convertibleError(value: object, type: [NSDictionary].self)
    }

    var dictionary = [RideKind: [NearbyDriver]]()
    for object in objects {
        let map = Mapper(JSON: object)
        let kind: RideKind = try map.from("ride_type")
        let cars: [NearbyDriver] = try map.from("drivers")
        dictionary[kind] = cars
    }

    return dictionary
}
