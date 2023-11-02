//
//  Networker.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 27/10/23.
//

import Foundation


class MovieService {
    
    
    static func fetchConfiguration(apiKey: String, completion: @escaping (ImageConfiguration?) -> Void) {
        ActivityIndicatorManager.shared.showActivityIndicator()
        let url = URL(string: "https://api.themoviedb.org/3/configuration?api_key=\(apiKey)")!
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error fetching configuration data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received when fetching configuration data.")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let configuration = try decoder.decode(Images.self, from: data)
                completion(configuration.images)
                
            } catch {
                print("Error decoding configuration data: \(error)")
                completion(nil)
            }
        }
        ActivityIndicatorManager.shared.hideActivityIndicator()
        task.resume()
    }
    
    
    static func fetchMovies(apiKey: String, page: Int, completion: @escaping ([Movie]?) -> Void) {
        fetchConfiguration(apiKey: apiKey){ configuration in
            if let configuration = configuration{
                
                let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&page=\(page)")!
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let movieData = try decoder.decode(MovieData.self, from: data)
                            let movies = movieData.results
                            completion(movies)
                        } catch {
                            print("Error decoding JSON: \(error)")
                            completion(nil)
                        }
                    } else if let error = error {
                        print("Error fetching data: \(error)")
                        completion(nil)
                    }
                }
                task.resume()
                
            }
            
            else{
                completion(nil)
            }
            
            
        }
    }
    static func fetchMovieTrailers(movieID: Int, apiKey:String , completion: @escaping ([MovieTrailer]?) -> Void){
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)")!
        let task = URLSession.shared.dataTask(with: url)  { (data,response,error) in
            if let error = error{
                print("Error fetching movie trailers data: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received when fetching movie trailers.")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let trailersResponse = try decoder.decode(MovieTrailersResponse.self, from: data)
                completion(trailersResponse.results)
            } catch {
                print("Error decoding movie trailers data: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
        
    }
    
   
}

