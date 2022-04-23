//
//  Request.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 10/03/22.
//

import Foundation

public protocol Request {
    /// HTTP Methods
    var method: HTTPMethod { get }
    
    /// Base `URL` for request
    var baseURLString: String { get }
    
    /// End Point for `URL` request
    var endPoint: String { get }
    
    /// HTTP Request Body
    func body() throws -> Data?
    
    /// HTTP Request Headers
    func headers() -> [String: String]
}

extension Request {
    
    private var finalUrl: String { baseURLString + endPoint }
    
    @discardableResult
    func asHttpRequest() -> URLRequest? {
        var urlString = finalUrl
        if urlString.contains(" ") {
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        guard let url = URL(string: urlString) else {
            
            return nil
        }
        print("Request URL -> \(finalUrl)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = try? body()
        request.allHTTPHeaderFields = headers()
        
        return request
    }
}

public enum RequestError: Error {
    case unknown
    case invalidRequest
    case decodingError(error: Error)
    case requestError(error: Error)
    case customError(errorStr: String)
    case errorWith(data: Data)
}
