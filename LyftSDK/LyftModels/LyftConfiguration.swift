import Foundation

/// Lyft SDK configuration
public struct LyftConfiguration {
    /// Represents the current developer using the LyftSDK. Must be set before any API calls can be made
    public static var developer: (token: String, clientId: String)?
}
