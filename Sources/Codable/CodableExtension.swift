//
//  File.swift
//  
//
//  Created by Irshad Ahmad on 24/04/22.
//

import Foundation

// MARK: - KeyedDecodingContainer
public extension KeyedDecodingContainer {
    
    func safeDecodeValue<T: SafeDecodable & Decodable>(forKey key: Self.Key) -> T {
    
        if let value = try? self.decodeIfPresent(T.self, forKey: key) {
            return value
        } else if let value = try? self.decodeIfPresent(String.self, forKey: key) {
            return value.cast()
        } else if let value = try? self.decodeIfPresent(Int.self, forKey: key) {
            return value.cast()
        } else if let value = try? self.decodeIfPresent(Float.self, forKey: key) {
            return value.cast()
        } else if let value = try? self.decodeIfPresent(Double.self, forKey: key) {
            return value.cast()
        } else if let value = try? self.decodeIfPresent(Bool.self, forKey: key) {
            return value.cast()
        }
        return T.default
       
    }
    
    func optionalDecodeValue<T: DecodeOptimizer>(forKey key: Self.Key) -> T? {
        if let value = try? self.decodeIfPresent(T.self, forKey: key) {
            return value
        } else if let value = try? self.decodeIfPresent(String.self, forKey: key) {
            return value.decodeTo()
        } else if let value = try? self.decodeIfPresent(Int.self, forKey: key) {
            return value.decodeTo()
        } else if let value = try? self.decodeIfPresent(Float.self, forKey: key) {
            return value.decodeTo()
        } else if let value = try? self.decodeIfPresent(Double.self, forKey: key) {
            return value.decodeTo()
        } else if let value = try? self.decodeIfPresent(Bool.self, forKey: key) {
            return value.decodeTo()
        }
        do {
            let value = try self.decodeIfPresent(T.self, forKey: key)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            
        } catch let error{
            print("error: ", error.localizedDescription)
            
        }
        return nil
    }
    
    func optionDecodeArray<T: DecodeOptimizer>(forKey key: Self.Key) -> [T]? {
        if let value = try? self.decodeIfPresent([T].self, forKey: key) {
            return value
        }
        do {
            let value = try self.decodeIfPresent(T.self, forKey: key)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            
        } catch let error{
            print("error: ", error.localizedDescription)
            
        }
        return nil
    }
   
}

public protocol DecodeOptimizer: Decodable {
    func decodeTo<T>() -> T?
}

extension DecodeOptimizer {
    public func decodeTo<T>() -> T? {
        return nil
    }
}

// MARK: - protocol SafeDecodable
public protocol Initializable {
    init()
}

public protocol DefaultValue: Initializable {}
extension DefaultValue {
    static var `default` : Self{ return Self() }
}

public protocol SafeDecodable: DefaultValue {}
extension SafeDecodable{
    func cast<T: SafeDecodable>() -> T { return T.default }
}
// MARK: - Int
extension Int: SafeDecodable{
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.default
    }
}
// MARK: - Double
extension Double: SafeDecodable{
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.default
    }
}
// MARK: - Float
extension Float: SafeDecodable{
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.default
    }
}
// MARK: - String
extension String: SafeDecodable{
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is Int.Type:
            castValue = Int(self.description) as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = ["true", "yes", "1"]
                .contains(self.lowercased()) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.default
    }
}
// MARK: - Bool
extension Bool: SafeDecodable{
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Bool.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Float.Type:
            castValue = (self ? 1 : 0) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.default
    }
}
// MARK: - Array
extension Array: SafeDecodable{
    public static var `default`: [Element] { return [Element]() }
    public func cast<T>() -> T where T: SafeDecodable {
       return T.default
    }
}

// MARK: - Array
extension Array where Element == DecodeOptimizer {
    public func decodeTo<T>() -> T? where T: DecodeOptimizer {
      return self as? T
    }
}

// MARK: - String

extension String: DecodeOptimizer {
    
    public func decodeTo<T>() -> T? where T: DecodeOptimizer {
        let castValue: T?
        switch T.self {
        case let x where x is Int.Type:
            castValue = Int(self.description) as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = ["true", "yes", "1"]
                .contains(self.lowercased()) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue
    }
}

// MARK: - Int
extension Int: DecodeOptimizer {
    
    public func decodeTo<T>() -> T? where T: DecodeOptimizer {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue
    }
}
// MARK: - Double

extension Double: DecodeOptimizer{
    public func decodeTo<T>() -> T? where T: DecodeOptimizer {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue
    }
}
// MARK: - Float

extension Float: DecodeOptimizer{
    public func decodeTo<T>() -> T? where T: DecodeOptimizer {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue
    }
}

// MARK: - Bool

extension Bool: DecodeOptimizer{
    public func decodeTo<T>() -> T? where T: DecodeOptimizer {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Bool.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Float.Type:
            castValue = (self ? 1 : 0) as? T
        default:
            castValue = self as? T
        }
        return castValue
    }
}
