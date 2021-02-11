//
//  NetworkError.swift
//  Chocofood-iOS-Internship-App
//
//  Created by Arystan on 1/18/21.
//

import Foundation

public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
