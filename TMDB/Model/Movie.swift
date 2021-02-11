//
//  Movie.swift
//  TMDB
//
//  Created by Arystan on 2/9/21.
//

import Foundation

struct Movie: Codable {
    var popularity: Double?
    var voteCount, id: Int?
    var video, adult: Bool?
    var posterPath, backdropPath: String?
    var originalLanguage, originalTitle: String?
    var genreIds: [Int]?
    var title: String?
    var voteAverage: Double?
    var overview: String?
    var releaseDate: String?
}
