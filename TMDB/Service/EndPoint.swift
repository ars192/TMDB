//
//  EndPointType.swift
//  Chocofood-iOS-Internship-App
//
//  Created by Arystan on 1/10/21.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public protocol EndPoint {
    var url: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var task: HTTPTask { get }
//    var cookie: HTTPCookie { get set}
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case update = "UPDATE"
    case delete = "DELETE"
}

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}
