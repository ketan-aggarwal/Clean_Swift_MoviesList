//
//  ImageConfig.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 30/10/23.
//

import Foundation

struct  ImageConfiguration: Codable{
    let base_url: String
    let secure_base_url: String
    
    let poster_sizes: [String]
}

struct Images: Codable{
    let images: ImageConfiguration
}
