//
//  MarketplaceAPI.swift
//  Chocofood-iOS-Internship-App
//
//  Created by Arystan on 1/10/21.
//

import Foundation


class API {
    
    static let shared = API()
    
    private init() {}
    
    func fetchItems<T:Codable>(endPoint: EndPoint, type: T.Type, completion: @escaping (Result<T, ServiceError>) -> () ) {
        NetworkManager.shared.request(endPoint: endPoint) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                    do {
                        let items = try decoder.decode(T.self, from: data!)
                        completion(.success(items))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                    
                } else {
                    completion(.failure(.domainError(description: response.debugDescription)))
                }
            }
        }
    }
}
