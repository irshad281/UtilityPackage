//
//  JSONDecoder.swift
//  
//
//  Created by Irshad Ahmad on 24/04/22.
//

import Foundation

public extension JSONDecoder {
    static var dateDecoder: JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        
        let jsonDecoder = JSONDecoder()
        
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
            "yyyy-MM-dd'T'HH:mm:ssZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd"
        ]
        
        jsonDecoder.dateDecodingStrategy = .custom({ decoder -> Date in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            
            for format in dateFormats {
                dateFormatter.dateFormat = format
                
                if let date = dateFormatter.date(from: string) {
                    return date
                }
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unable to parse a Date from the string \(string)."
            )
        })
        
        return jsonDecoder
    }
}
