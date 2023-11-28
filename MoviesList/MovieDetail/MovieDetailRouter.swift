//
//  MovieDetailRouter.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 22/11/23.
//

import Foundation

protocol MovieDetailRoutingLogic {
}

protocol MovieDetailDataPassing {
    var dataStore: MovieDetailDataStore? { get set }
    //func setDataStore(dataStore: MovieListDataStore?)
    func setDataStore(dataStore: MovieDetailDataStore?)
}

class MovieDetailRouter: MovieDetailRoutingLogic, MovieDetailDataPassing {
   
    
    weak var viewController: MovieDetailViewController?
    var dataStore: MovieDetailDataStore?
    

   
    func setDataStore(dataStore: MovieDetailDataStore?) {
        self.dataStore = dataStore
        print(dataStore!.selectedMovie!.id!)
    }
    
    // Add any additional routing methods as needed
}

