//
//  MovieTrailers.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 31/10/23.
//

import Foundation

struct MovieTrailer:Codable{
    let name: String?
    let key: String?
}

struct MovieTrailersResponse: Codable {
    let results: [MovieTrailer]
}
