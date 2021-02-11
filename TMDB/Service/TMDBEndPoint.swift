//
//  MarketplaceEnpoint.swift
//  Chocofood-iOS-Internship-App
//
//  Created by Arystan on 1/12/21.
//

import Foundation


enum TMDBEndPoint {
    case fetchMovies(_ page: Int)
    case fetchMovieDetail(_ id: Int)
    case searchMovies(_ page: Int, _ query: String)
}

extension TMDBEndPoint: EndPoint {
    var task: HTTPTask {
        switch self {
        case .fetchMovies(let page):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["api_key": apiKey, "page" : page])
        case .fetchMovieDetail(_):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["api_key": apiKey])
        case .searchMovies(let page, let query):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["api_key": apiKey, "query": query,"page": page])
        }
        
    }
    
    
    var url: URL {
        guard let url = Foundation.URL(string: "https://api.themoviedb.org/3/") else { fatalError("invalidURL") }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchMovies(_):
            return "movie/popular/"
        case .fetchMovieDetail(let id):
            return "movie/\(id)"
        case .searchMovies(_, _):
            return "search/movie"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMovies(_):
            return HTTPMethod.get
        case .fetchMovieDetail(_):
            return HTTPMethod.get
        case .searchMovies(_, _):
            return HTTPMethod.get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchMovies(_):
            return nil
        case .fetchMovieDetail(_):
            return nil
        case .searchMovies(_, _):
            return nil
        }
        
    }
}

private var apiKey: String {
  get {
    guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
      fatalError("Couldn't find file 'TMDB-Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("down 'API_KEY' in 'TMDB-Info.plist'.")
    }
    return value
  }
}

public enum Constants {
    enum Url {
        static let imageURL = "https://image.tmdb.org/t/p/w500/"
    }
}
//static let imageURL = "https://image.tmdb.org/t/p/w500/"
