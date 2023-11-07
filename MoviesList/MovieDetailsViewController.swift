//
//  MovieDetailsViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 26/10/23.
//

import UIKit
import youtube_ios_player_helper


class MovieDetailsViewController: UIViewController, YTPlayerViewDelegate {
    
    var movie: Movie?
    var configuration:ImageConfiguration?
    var trailers: [MovieTrailer] = []
    var additionalInfo: MovieInfo?
    var playerView:YTPlayerView!
    var isLiked = false
    
    @IBOutlet weak var FullTitle: UILabel!
    @IBOutlet weak var revLabel: UILabel!
    @IBOutlet weak var runLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    @IBAction func likedBtn(_ sender: Any) {
        isLiked.toggle()
        updateLikeButtonAppearance()
    }
    
    func updateLikeButtonAppearance() {
        if isLiked {
            img.image = UIImage(named: "heart_filled")
            likeBtn.tintColor = .clear
            
        } else {
            img.image = UIImage(named: "heart_empty")
            likeBtn.tintColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView = YTPlayerView()
        playerView.delegate = self

        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        let topConstraint = NSLayoutConstraint(item: playerView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: 60)
        
        let leadingConstraint = NSLayoutConstraint(item: playerView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: playerView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: playerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        
        NSLayoutConstraint.activate([topConstraint,leadingConstraint,trailingConstraint,heightConstraint])
        
        fetchTrailerData()
        fetchInfo()
        updateLikeButtonAppearance()
        
        if let movie = movie{
            FullTitle.text = movie.title
        }else{
            FullTitle.text = "Error fetching"
        }
    }
    
    func fetchTrailerData() {
        if let movie = movie, let movieId = movie.id {
            let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
            MovieService.fetchMovieTrailers(movieID: movieId, apiKey: apiKey) { [weak self] trailers in
                guard let self = self, let trailers = trailers else { return }
                self.trailers = trailers
                self.playTrailer(at: 0)
            }
        }
    }
    
    func fetchInfo() {
            guard let movie = movie, let movieId = movie.id else { return }
            let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
            
            MovieService.fetchAdditionalMovieInfo(movieID: movieId, apiKey: apiKey) { [weak self] movieInfo in
                self?.additionalInfo = movieInfo
                if let revenue = movieInfo?.revenue , let runtime = movieInfo?.runtime, let tagline = movieInfo?.tagline, let release_date = movieInfo?.release_date, let production_countries = movieInfo?.production_countries!, let spoken_lannguages = movieInfo?.spoken_languages!{
                    DispatchQueue.main.async {
                        self?.revLabel.text = "$\(revenue/1000000) Mil."
                        self?.runLabel.text = "\(runtime) Min."
                        self?.tagLabel.text = "# \(tagline)"
                        self?.releaseLabel.text = "\(release_date)"
                        let countryNames = production_countries.map { $0.name! }.joined(separator: ", ")
                        self?.countryLabel.text = countryNames
                        let languages = spoken_lannguages.map {$0.english_name
                        }.joined(separator: "\n")
                        self?.langLabel.text = languages
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.revLabel.text = "Revenue data not available"
                        self?.runLabel.text = "Runtime not available"
                    }
                }
            }
        }
    
    func playTrailer(at index: Int) {
        if let trailer = trailers.first ,let key = trailer.key {
            print("YouTube Video ID: \(key)")
            DispatchQueue.main.async { [weak self] in
                self?.playerView.load(withVideoId: key)
            }
        } else {
            print("Invalid trailer key")
        }
    }

    }
       




