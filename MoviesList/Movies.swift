//
//  Movies.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 26/10/23.
//

import Foundation
import UIKit



//struct SpokenLanguage: Codable {
//    let english_name: String
//    let iso_639_1: String
//    let name: String
//}

struct Movie: Codable {
    let title: String?
    let overview: String?
    let vote_average: Double?
    let poster_path: String?
    let page: String?
    let id : Int?
//    let spoken_languages: [SpokenLanguage]?
//    let revenue: Int?
//    let runtime: Int?
//    let release_date: Date?
//    let tagline: String?
}



struct MovieData: Codable {
    let results: [Movie]
}








