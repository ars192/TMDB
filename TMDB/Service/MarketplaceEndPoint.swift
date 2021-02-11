//
//  MarketplaceEnpoint.swift
//  Chocofood-iOS-Internship-App
//
//  Created by Arystan on 1/12/21.
//

import Foundation


enum TMDBEndPoint {
    case fetchCateringList
    case postOrder
    case fetchRestaurantMenu(_ id: String)
}

extension TMDBEndPoint: EndPoint {
    var task: HTTPTask {
        switch self {
        case .fetchCateringList:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["longitude": "77.006425", "latitude" : "43.34061"])
        case .postOrder:
            return .request
        case .fetchRestaurantMenu(_):
            return .request
        }
    }
    
    
    var url: URL {
        guard let url = Foundation.URL(string: "https://hermes.chocofood.kz/api/") else { fatalError("invalidURL") }
        return url
    }
    
    var path: String {
        switch self {
        case .postOrder:
            return "post/id"
        case .fetchCateringList:
            return "delivery_areas/restaurants/"
        case .fetchRestaurantMenu(let id):
            return "extended_restaurants/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postOrder:
            return HTTPMethod.post
        case .fetchCateringList:
            return HTTPMethod.get
        case .fetchRestaurantMenu(_):
            return HTTPMethod.get
            
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .postOrder:
            return nil
        case .fetchCateringList:
            return nil
        case .fetchRestaurantMenu(_):
            return nil
        }
    }
}

private var apiKey: String {
  get {
    // 1
    guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
      fatalError("Couldn't find file 'TMDB-Info.plist'.")
    }
    // 2
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("down 'API_KEY' in 'TMDB-Info.plist'.")
    }
    return value
  }
}
