//
//  EncodableExtension.swift
//  
//
//  Created by Irshad Ahmad on 24/04/22.
//

import Foundation

public extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    func asRequestBody() throws -> Data { try JSONEncoder().encode(self) }
}
