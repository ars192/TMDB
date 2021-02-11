//
//  Movies.swift
//  TMDB
//
//  Created by Arystan on 2/9/21.
//

import Foundation

struct Movies: Codable {
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var results: [Movie]?
}
