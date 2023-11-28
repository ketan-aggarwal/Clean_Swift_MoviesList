import Foundation

protocol MovieDetailBusinessLogic {
    func fetchMovieInfo(request: MovieDetailModel.FetchInfo.Request)
    //func fetchTrailer(request: MovieDetailModel.FetchTrailer.Request)
}

protocol MovieDetailDataStore{
    var apiKey: String { get set }
    var movieID: Int { get set }
//    var trailer: [MovieTrailer]? { get set }
//    var movieInfo: MovieInfo? { get set }
    var selectedMovie: Movie? {get set}
    
}

class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore {
    
    
    var apiKey: String = "e3d053e3f62984a4fa5d23b83eea3ce6"
    var movieID: Int = 0
    var trailer: [MovieTrailer]?
    var movieInfo: MovieInfo?
    var selectedMovie: Movie?
    var worker: MovieDetailWorkingLogic?
    var presenter: MovieDetailPresentationLogic
    
    init(worker: MovieDetailWorkingLogic, presenter:MovieDetailPresentationLogic) {
        self.worker = worker
        self.presenter = presenter
    }
    
    func fetchMovieInfo(request: MovieDetailModel.FetchInfo.Request) {
        guard let movieID = self.selectedMovie?.id else {
            print("hello \(movieID)")
            return
        }
        
        worker?.fetchMovieInfo(movieID: Int(movieID), apiKey: apiKey) { [weak self] movieInfo in
            self?.movieInfo = movieInfo
            
            // Now that you have the movieInfo, you can pass it to the presenter
            if let movieInfo = movieInfo {
                let response = MovieDetailModel.FetchInfo.Response(movieInfo: movieInfo)
                self?.presenter.presentFetchInfo(response: response)
            }
        }
    }
    
    //    func fetchTrailer(request: MovieDetailModel.FetchTrailer.Request) {
    //        guard let movieID = request.movieID else {
    //            return
    //        }
    //
    //        worker?.fetchTrailer(movieID: movieID, apiKey: apiKey) { [weak self] trailers in
    //            self?.trailer = trailers
    //
    //        }
    //    }
    
}
