//
//  MovieViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 16/11/23.
//

import UIKit
import SDWebImage



protocol MovieDisplayLogic: AnyObject {
    func displayMovies(viewModel: MovieListViewModels.MovieListViewModel)
    func displayConfiguration(viewModel: MovieListViewModels.ImageConfigurationViewModel)
}

class MovieViewController: UIViewController , MovieDisplayLogic, UITableViewDelegate, UITableViewDataSource, MovieListDataPassing{
    
    
    var dataStore: MovieListDataStore?
    
    @IBOutlet weak var myTable: UITableView!
    
    var apiKey: String = "e3d053e3f62984a4fa5d23b83eea3ce6"
    var movies:[Movie]?
    var configuration : ImageConfiguration?
    var interactor: MovieListInteractor?
    var router: MovieListRouter?
   
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setup()
        setupButton()
        fetchConfiguration(apiKey: apiKey)
        fetchMovies(apiKey: apiKey)
    }
    
    private func setup() {
        let viewController = self
        let presenter = MoviePresenter()
        let interactor = MovieListInteractor(presenter: presenter)
        let worker = MovieListWorker()
        let router = MovieListRouter(viewController: viewController)
        router.dataStore = interactor
        viewController.interactor = interactor
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
    }
    
    func setupTable(){
        myTable.delegate = self
        myTable.dataSource = self
        
    }
    
    func setupButton(){
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        button.backgroundColor = .systemBlue
        button.setTitle("Load More", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        myTable.tableFooterView = button
    }
    
    @objc func buttonTapped(){
        let page = interactor?.incrementCurrentPage() ?? 1
        interactor!.fetchMovies(request: MovieListModels.FetchMovies.Request(apiKey: apiKey, page: page))
    }
    
    func fetchMovies(apiKey: String){
        interactor!.fetchMovies(request: MovieListModels.FetchMovies.Request(apiKey: apiKey, page: 1))
    }
    
    func fetchConfiguration(apiKey: String){
        interactor!.fetchConfiguration(request: MovieListModels.FetchImageConfiguration.Request(apiKey: apiKey))
    }
    
    func displayMovies(viewModel: MovieListViewModels.MovieListViewModel) {
        movies = movies ?? []
        movies?.append(contentsOf: viewModel.movies)
        
        DispatchQueue.main.async {
            self.myTable.reloadData()
        }
    }
    
    func displayConfiguration(viewModel: MovieListViewModels.ImageConfigurationViewModel) {
        configuration = viewModel.imageConfig
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        cell.title?.text = movie.title ?? "hello"
        cell.desc?.text = movie.overview
        cell.rating?.text = String(movie.vote_average!)
        
        if let configuration = configuration, let posterPath = movie.poster_path {
            
            DispatchQueue.main.async {
                if let fullPosterURL = URL(string: configuration.base_url)?
                    .appendingPathComponent(configuration.poster_sizes[5])
                    .appendingPathComponent(posterPath) {
                    //print(fullPosterURL)
                    cell.img.sd_setImage(with: fullPosterURL, placeholderImage: UIImage(named: "placeholderImage"))
                }
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ketan")
        if let selectedMovie = movies?[indexPath.row] {
            passMovieData(selectedMovie)
            if let storedMovie = dataStore?.selectedMovie {
                           print("Recently Selected Movie: \(storedMovie.title ?? "N/A")")
                       } else {
                           print("Selected Movie is nil in dataStore")
                       }
        }
    }
    func passMovieData(_ movie: Movie) {
        dataStore?.selectedMovie = movie
//        print("dataStrore is set: \(dataStore?.selectedMovie?.overview)")
        router?.navigateToMovieDetail(movie: movie)
        print("ListDataStrore value:\(dataStore?.selectedMovie?.overview)")
    }
    
    
}
