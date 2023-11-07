//
//  MoviesInfo.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 02/11/23.
//

import Foundation

struct ProductionCountry: Codable {
    let iso_3166_1: String?
    let name: String?
}

struct SpokenLanguage: Codable {
    let english_name: String
    let iso_639_1: String
    let name: String
}

struct MovieInfo: Codable {
    let spoken_languages: [SpokenLanguage]?
    let production_countries: [ProductionCountry]?
    let revenue: Int?
    let runtime: Int?
    let tagline: String?
    let release_date: String?
   
}


