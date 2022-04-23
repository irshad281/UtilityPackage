//
//  CodablePropertyWrapper.swift
//  
//
//  Created by Irshad Ahmad on 24/04/22.
//

import Combine
import Foundation

@propertyWrapper
public struct CodablePropertyWrapper<Value: Codable> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    private let publisher = PassthroughSubject<Value, Never>()

    public var wrappedValue: Value {
        get {
            // Read value from UserDefaults
            guard let data = container.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let cdata = try? JSONDecoder().decode(Value.self, from: data)
            return cdata ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                // Convert newValue to data
                let data = try? JSONEncoder().encode(newValue)
                
                // Set value to UserDefaults
                container.set(data, forKey: key)
            }
        }
    }
    
    public var projectedValue: AnyPublisher<Value, Never> {
        return publisher.eraseToAnyPublisher()
    }
}

public extension CodablePropertyWrapper where Value: ExpressibleByNilLiteral {
    
    /// Creates a new User Defaults property wrapper for the given key.
    /// - Parameters:
    ///   - key: The key to use with the user defaults store.
    init(key: String, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}
