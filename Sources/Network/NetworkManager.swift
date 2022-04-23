//
//  NetworkManager.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 10/03/22.
//

import Foundation
import Combine

// MARK: - NetworkManager

final public class NetworkManager {
    
    /// This method is to make your serve call from Request and return a `Decodable Element`.
    public static func performRequest<Element: Decodable>(_ request: Request)
    -> Future<Element, RequestError>
    {
        Future<Element, RequestError> { promise in
            guard let httpRequest = request.asHttpRequest() else {
                return promise(.failure(.invalidRequest))
                
            }
            URLSession.shared.dataTask(with: httpRequest) { responseData, headerResponse, error in
                print((headerResponse as? HTTPURLResponse)?.statusCode as Any)
                DispatchQueue.main.async {
                    return promise(NetworkManager.decodeData(responseData: responseData, error: error))
                }
            }.resume()
        }
    }
    
    /// Print the response from server
    /// - Parameter data: Response Data in `binary`
    static func logResponse(from data: Data) {
        if let json = try? JSONSerialization.jsonObject(
            with: data,
            options: .mutableContainers) {
            debugPrint(json)
        } else if let data = String(data: data, encoding: .utf8) {
            debugPrint(data)
        }
    }
}
