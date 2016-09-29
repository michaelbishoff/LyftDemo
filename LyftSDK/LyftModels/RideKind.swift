/// A kind of ride offered by the Lyft platform in a given area. May include special promotional ride types.
public struct RideKind: RawRepresentable, Hashable {
    /// The string value of the actual ride kind. For example "lyft_line".
    public var rawValue: String

    public var hashValue: Int { return self.rawValue.hashValue }

    fileprivate init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// Standard lyft ride kind
    public static let Standard = RideKind("lyft")
    /// Lyft Line ride kind
    public static let Line = RideKind("lyft_line")
    /// Lyft plus ride kind
    public static let Plus = RideKind("lyft_plus")
}
