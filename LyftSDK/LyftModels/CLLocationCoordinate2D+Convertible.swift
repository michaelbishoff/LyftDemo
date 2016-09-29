import CoreLocation
import Mapper

extension CLLocationCoordinate2D: Convertible {

    public static func fromMap(_ value: Any) throws -> CLLocationCoordinate2D {
        guard let location = value as? NSDictionary,
            let latitude = (location["lat"] ?? location["latitude"]) as? Double,
            let longitude = (location["lng"] ?? location["longitude"]) as? Double else
        {
            throw MapperError.convertibleError(value: value, type: NSDictionary.self)
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
