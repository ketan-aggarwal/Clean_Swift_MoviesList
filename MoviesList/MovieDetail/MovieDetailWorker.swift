//
//  MovieDetailWorker.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 20/11/23.
//

import Foundation
import youtube_ios_player_helper

protocol MovieDetailWorkingLogic {
    func fetchMovieInfo(movieID: Int, apiKey: String , completion : @escaping (MovieInfo?) -> Void)
    //func fetchTrailer(movieID: Int, apiKey: String , completion : @escaping ([MovieTrailer]?) -> Void)
}

class MovieDetailWorker: MovieDetailWorkingLogic {
    
    func fetchMovieInfo(movieID: Int, apiKey: String, completion: @escaping (MovieInfo?) -> Void) {
        let url = URL(string : "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&append_to_response=videos")!
        let task = URLSession.shared.dataTask(with: url) { (data, respose, error) in
            if error != nil {
                print("Error in fetching MovieInfo")
                completion(nil)
                return
            }
            
            guard let data = data else{
                print("No data recieved while fetching MovieInfo")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieInfo = try decoder.decode(MovieInfo.self, from: data)
                completion(movieInfo)
            } catch {
                print("Error decoding additional movie data: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
//
//    func fetchTrailer(movieID: Int, apiKey: String, completion: @escaping ([MovieTrailer]?) -> Void) {
//        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)")!
//        let task = URLSession.shared.dataTask(with: url)  { (data,response,error) in
//            if let error = error{
//                print("Error fetching movie trailers data: \(error)")
//                completion(nil)
//                return
//            }
//            guard let data = data else {
//                print("No data received when fetching movie trailers.")
//                completion(nil)
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let trailersResponse = try decoder.decode(MovieTrailersResponse.self, from: data)
//                completion(trailersResponse.results)
//            } catch {
//                print("Error decoding movie trailers data: \(error)")
//                completion(nil)
//            }
//        }
//
//        task.resume()
//    }
    
    
}
