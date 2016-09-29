import Foundation

/// An interface defining a value that can be requested as a URL.
protocol Routable {
    /// The url used to construct an HTTP request
    var url: URL { get }
    /// A dictionary of key, values to append to the HTTP request headers. Authentication should be included.
    var extraHTTPHeaders: [String: String] { get }
}

/// HTTP method definitions.
///
/// See https://tools.ietf.org/html/rfc7231#section-4.3
enum HTTPMethod: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

/// The HTTP response type. The type of this enum is defined by the HTTP Status code.
///
/// - Succeed:         The request was successfully executed and doesn't need further processing.
/// - RetryableError:  The request failed and *could* be retried.
/// - Unauthorized:    The request failed because the user is not logged in.
/// - UpgradeRequired: The request failed because the app needs to be upgraded.
/// - Canceled:        The request was replaced by using the .ReplaceSilently option or canceled.
/// - NotFound:        The request failed because the requested resource wasn't found on the server.
/// - Unprocessable:   The request failed because an error on the information we sent.
/// - UnknownError:    The request failed with an unknown error that shouldn't be retried.
public enum ResponseType {
    case succeed
    case badRequest, unauthorized, upgradeRequired, forbidden
    case retryableError, canceled, timedOut, unprocessable, notFound, unknownError

    /// The response type for a given HTTP code.
    ///
    /// - parameter code: The HTTP code.
    ///
    /// - returns: The response code meaning.
    // swiftlint:disable:next cyclomatic_complexity
    public init(fromCode code: Int) {
        switch code {
            case 200 ..< 300:
                self = .succeed

            case 400:
                self = .badRequest

            case 401:
                self = .unauthorized

            case 403:
                self = .forbidden

            case 404:
                self = .notFound

            case 422:
                self = .unprocessable

            case 426:
                self = .upgradeRequired

            case NSURLErrorCancelled:
                self = .canceled

            case NSURLErrorTimedOut:
                self = .timedOut

            case 408, 409, 500, 502, 503, 504:
                self = .retryableError

            default:
                self = .unknownError
        }
    }
}

final class HTTPClient {

    fileprivate let session: URLSession

    /// Initializes a new instance of HTTPClient
    ///
    /// - parameter configuration: Configuration to be used in conjunction with the underlying URLSession
    ///
    /// - returns: New instance of HTTPClient.
    required init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }

    /// Creates and queue a network request for a given endpoint.
    ///
    /// The right hande side of the `Result` type created from this should probably be some sort of network
    /// error.
    ///
    /// - parameter method:      The HTTP method used in this request (POST, GET, PUT).
    /// - parameter route:       The API endPoint path. Example: /user/123/.
    /// - parameter parameters:  Are going to be sent to the server either as a JSON (post) or GET parameters.
    /// - parameter completion:  A closure that is called when the request is completed (either success or
    ///                          failure).
    func request(_ method: HTTPMethod, _ route: Routable, parameters: [String: Any]? = nil,
                 completion: @escaping (Any?, ResponseType) -> Void)
    {
        let request = self.urlRequest(method, route: route, parameters: parameters)
        let dataTask = self.session.dataTask(with: request) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            let status = ResponseType(fromCode: statusCode)

            let JSON = try? JSONSerialization.jsonObject(with: data ?? Data(), options: [])
            completion(JSON, status)
        }

        dataTask.resume()
    }

    fileprivate func urlRequest(_ method: HTTPMethod, route: Routable,
                            parameters: [String: Any]? = nil) -> URLRequest
    {
        var request = URLRequest(url: route.url)
        request.httpMethod = method.rawValue

        for (key, value) in route.extraHTTPHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return lyftURLEncodedInURL(request: request, parameters: parameters).0
    }
}
