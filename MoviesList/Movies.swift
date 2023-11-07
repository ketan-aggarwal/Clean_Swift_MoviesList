//
//  Movies.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 26/10/23.
//

import Foundation
import UIKit





struct Movie: Codable {
    let title: String?
    let overview: String?
    let vote_average: Double?
    let poster_path: String?
    let page: String?
    let id : Int?
    
}



struct MovieData: Codable {
    let results: [Movie]
}








