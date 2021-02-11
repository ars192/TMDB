//
//  ServiceError.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import Foundation

enum ServiceError: Error {
    case domainError(description: Any)
    case decodingError
}
