import Foundation

/// Generic error struct. It contains the message returned by the server and the reason for the error. When
/// `isUnprocessable` == false it means that the server returned an status code other than 422.
public struct LyftAPIError: Error, Hashable, Equatable {
    /// The error message from the server
    public let message: String?
    /// The error reason from the server
    public let reason: String
    /// The original error JSON from the server
    public let response: NSDictionary?
    /// The response status from the server
    public let status: ResponseType?
    /// true if the server returns a 422, false otherwise
    public var isUnprocessable: Bool {
        return self != .ServerError
    }
    /// Generic server error
    public static let ServerError = LyftAPIError("serverError")
    /// Generic unknown error
    public static let UnknownError = LyftAPIError("unknown")

    /// Initialize a new instance of LyftAPIError.
    ///
    /// - parameter reason:     The error reason from the server
    /// - parameter message:    The error message from the server
    ///
    /// - returns: New instance of LyftAPIError.
    public init(_ reason: String, message: String? = nil) {
        self.reason = reason
        self.message = message
        self.response = nil
        self.status = nil
    }

    /// Parses the error type from the server response and returns the instance that represents the first
    /// error.
    ///
    /// - parameter response:           The NSDictionary created from a JSON response.
    /// - parameter status:             The type defined by the status code (see the ResponseType enum for
    ///                                 more information).
    /// - parameter allowEmptyResponse: Treat an empty response as successful with a Succeeded response type.
    /// - parameter handledResponses:   The response types that can be handled with specific information.
    ///
    /// - returns: The newly created LyftAPIError instance representing the first error found.
    public init?(response: NSDictionary?, status: ResponseType, allowEmptyResponse: Bool = true,
                 handledResponses: Set<ResponseType> = [.unprocessable, .badRequest])
    {
        self.response = response
        self.status = status

        if status == .succeed && (response != nil || allowEmptyResponse) {
            return nil
        }

        if !handledResponses.contains(status) {
            self.reason = LyftAPIError.ServerError.reason
            self.message = nil
            return
        }

        let firstError = (self.response?["errors"] as? NSArray)?.firstObject as? NSDictionary
        self.reason = firstError?["reason"] as? String
            ?? response?["error"] as? String
            ?? LyftAPIError.UnknownError.reason
        self.message = firstError?["message"] as? String
    }

    public var hashValue: Int {
        return self.reason.hashValue
    }
}

/// Equatable implementation of LyftAPIError.
///
/// - parameter lhs: The LyftAPIError to be compared.
/// - parameter rhs: The LyftAPIError to be compared.
///
/// - returns: If the 2 error objects are equal
public func == (lhs: LyftAPIError, rhs: LyftAPIError) -> Bool {
    return lhs.reason == rhs.reason
}
