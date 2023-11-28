//
//  MovieListRouter.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 21/11/23.
//

import Foundation
import UIKit

protocol MovieListRoutingLogic {
    func navigateToMovieDetail(movie: Movie)
}

protocol MovieListDataPassing {
    var dataStore: MovieListDataStore? { get set}
    func passMovieData(_ movie: Movie)
}

class MovieListRouter: MovieListRoutingLogic, MovieListDataPassing {

    weak var viewController: MovieViewController?
    var dataStore: MovieListDataStore?
    
    init(viewController: MovieViewController) {
        self.viewController = viewController
    }
    
    func navigateToMovieDetail(movie: Movie) {
                if let movieDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
                           passMovieData(movie)
                           viewController?.navigationController?.pushViewController(movieDetailViewController, animated: true)
                       }
                   }
        //
        //    func passMovieData(_ movie: Movie) {
        //        dataStore?.selectedMovie = movie
        
//        if let movieDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
//            passMovieData(movie)
//
//
//                               let movieDetailRouter = MovieDetailRouter()
//                               movieDetailRouter.setDataStore(dataStore: dataStore)
//
//                               // Set the router of movieDetailViewController to movieDetailRouter
//                        movieDetailViewController.router = movieDetailRouter  as! any MovieDetailRoutingLogic
            
         
    
    
    func passMovieData(_ movie: Movie) {
        dataStore?.selectedMovie = movie
        print(dataStore!.selectedMovie!.title!)
        print(dataStore!.selectedMovie!.id!)
        }
}
        
        
        
        
    


