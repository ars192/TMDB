//
//  DetailedMovie.swift
//  TMDB
//
//  Created by Arystan on 2/10/21.
//

import Foundation

struct DetailedMovie: Codable {
    var adult: Bool?
    var posterPath, backdropPath: String?
    var genres: [Genre]?
    var id, imbdId: Int?
    var originalTitle, overview: String?
    var popularity: Double?
    var releaseDate: String?
    var runtime: Int?
    var voteAverage: Double?
    var voteCount: Int?
}
