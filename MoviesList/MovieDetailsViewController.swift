//
//  MovieDetailsViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 26/10/23.
//

import UIKit
import youtube_ios_player_helper
//import AVKit

class MovieDetailsViewController: UIViewController, YTPlayerViewDelegate {
    
    var movie: Movie?
    var configuration:ImageConfiguration?
    var trailers: [MovieTrailer] = []
    
    var playerView:YTPlayerView!
 
 
    
    
    
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


       func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
           playerView.playVideo()
       }

       func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
           // Handle state changes (playing, paused, etc.)
       }

       func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
           // Handle any errors
           print("YouTube player error: \(error.rawValue)")
       }
  
    }
       




