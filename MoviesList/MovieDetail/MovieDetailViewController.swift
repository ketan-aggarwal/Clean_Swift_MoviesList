//
//  MovieDetailViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 20/11/23.
//

import UIKit
import youtube_ios_player_helper

protocol MovieDetailDisplayLogic {
    func displayMovieInfo(viewModel: MovieDetailViewModels.MovieInfoViewModel)
   // func displayTrailer(vieModel: MovieDetailViewModels.MovieTrailerViewModel)
}



class MovieDetailViewController: UIViewController , MovieDetailDisplayLogic,MovieListDataPassing {
    
    var dataStore: MovieListDataStore?
    var isLiked = false
    var interactor: MovieDetailBusinessLogic?
    var movieID: Int?
    var router: MovieDetailRoutingLogic?
    
    func passMovieData(_ movie: Movie) {
        dataStore?.selectedMovie = movie
    }
    
    @IBOutlet weak var FullTitle: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var revLabel: UILabel!
    @IBOutlet weak var runLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var eyeImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchMovieData()
    }
    
//    func setupPlayer(){
//        playerView = YTPlayerView()
//        playerView.delegate = self
//
//        playerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(playerView)
//        let topConstraint = NSLayoutConstraint(item: playerView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: 60)
//        let leadingConstraint = NSLayoutConstraint(item: playerView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
//        let trailingConstraint = NSLayoutConstraint(item: playerView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
//        let heightConstraint = NSLayoutConstraint(item: playerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
//        NSLayoutConstraint.activate([topConstraint,leadingConstraint,trailingConstraint,heightConstraint])

//    }
    
    private func setup() {
        let movieDetailviewController = self
        let presenter = MovieDetailPresenter()
        let worker = MovieDetailWorker()
        let interactor = MovieDetailInteractor(worker: worker, presenter: presenter)
         
//        // Initialize MovieListRouter and MovieDetailRouter
//                let movieListRouter = MovieListRouter()
//                let movieDetailRouter = MovieDetailRouter()
//        
//        movieDetailviewController.router = router
//        movieDetailviewController.interactor = interactor
        movieDetailviewController.interactor = router as? any MovieDetailBusinessLogic
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.movieDetailViewController = movieDetailviewController
        
    }
   
    func fetchMovieData(){
        guard let selectedMovie = dataStore?.selectedMovie else {
            print("movie id \(dataStore?.selectedMovie?.title)")
            return
        }
        guard let movieID = selectedMovie.id else{
            print("Id is nil")
            return
        }
        let request = MovieDetailModel.FetchInfo.Request(apiKey: "e3d053e3f62984a4fa5d23b83eea3ce6", movieID: Int(movieID))
        interactor?.fetchMovieInfo(request: request)
    }
    
    func displayMovieInfo(viewModel: MovieDetailViewModels.MovieInfoViewModel) {
        tagLabel.text = viewModel.movieInfo.tagline
        revLabel.text = "$\(viewModel.movieInfo.revenue!/1000000) Mil."
        runLabel.text = "\(viewModel.movieInfo.runtime ?? 0) Min."
        releaseLabel.text = "\(viewModel.movieInfo.release_date)"
        
        if let productionCountries = viewModel.movieInfo.production_countries,
           let spokenLanguages = viewModel.movieInfo.spoken_languages {
            let countryNames = productionCountries.map { $0.name ?? "" }.joined(separator: ", ")
            countryLabel.text = countryNames
            
            let languages = spokenLanguages.map { $0.english_name }.joined(separator: ", ")
            langLabel.text = languages
        }
    }

}
