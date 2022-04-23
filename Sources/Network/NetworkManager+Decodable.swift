//
//  NetworkManager+Decodable.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 23/03/22.
//

import Foundation
import Combine

public extension NetworkManager {
    
    static func decodeData<Element: Decodable>(responseData: Data?, error: Error?) -> Result<Element, RequestError>{
        if let data = responseData {
            if UtilityPackage.enableLog { NetworkManager.logResponse(from: data) }
            
            do {
                let result = try JSONDecoder.dateDecoder.decode(Element.self, from: data)
                return .success(result)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                return .failure(.decodingError(error: DecodingError.dataCorrupted(context)))
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                return .failure(.errorWith(data: data))
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                return .failure(.decodingError(error: DecodingError.valueNotFound(value, context)))
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                return .failure(.decodingError(error: DecodingError.typeMismatch(type, context)))
            } catch let error{
                print("error: ", error.localizedDescription)
                return .failure(.decodingError(error: error))
            }
            
        } else if let error = error {
            return .failure(.requestError(error: error))
        } else {
            return .failure(.unknown)
        }
    }
    
}
