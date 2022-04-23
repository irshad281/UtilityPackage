//
//  AnyValueDecodable.swift
//  
//
//  Created by Irshad Ahmad on 24/04/22.
//

import Foundation

public enum AnyValueDecodable: Codable, Equatable {
    case integer(Int)
    case string(String)
    case double(Double)
    case float(Float)
    case bool(Bool)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(Float.self) {
            self = .float(x)
            return
        }
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        throw DecodingError.typeMismatch(AnyValueDecodable.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AnyValueDecodable"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .double(let x):
            try container.encode(x)
        case .float(let x):
            try container.encode(x)
        case .bool(let x):
            try container.encode(x)
        }
    }
    
    public var intValue: Int? {
        switch self {
        case .integer(let value):
            return value
        default:
            return  nil
        }
    }
    
    public var stringValue: String? {
        switch self {
        case .string(let value):
            return value
        case .integer(let value):
            return String(value)
        case .float(let value):
            return String(value)
        case .double(let value):
            return String(value)
        case .bool(let value):
            if value == true {
                return "1"
            }
            return "0"
        }
    }
    
    public var doubleValue: Double? {
        switch self {
        case .double(let value):
            return value
        case .float(let value):
            return Double(value)
        case .string(let value):
            return Double(value)
        default:
            return nil
        }
    }
    
    public var floatValue: Float? {
        switch self {
        case .float(let value):
            return value
        default:
            return nil
        }
    }
    
    public var boolValue: Bool? {
        switch self {
        case .bool(let value):
            return value
        default:
            return nil
        }
    }
}
