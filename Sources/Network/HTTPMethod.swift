//
//  HTTPMethod.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 10/03/22.
//

import Foundation

public struct HTTPMethod: RawRepresentable, Hashable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension HTTPMethod {
    /// The `POST` method
    static let post = HTTPMethod(rawValue: "POST")
    
    /// The `GET` method
    static let get = HTTPMethod(rawValue: "GET")
    
    /// The `PUT` method
    static let put = HTTPMethod(rawValue: "PUT")
    
    /// The `DELETE` method
    static let delete = HTTPMethod(rawValue: "DELETE")
    
    /// The `PATCH` method
    static let patch = HTTPMethod(rawValue: "PATCH")
}
