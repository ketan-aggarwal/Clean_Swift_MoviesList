//
//  ViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 26/10/23.
//

import UIKit
import SDWebImage
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var myTable: UITableView!
    
    var configuration: ImageConfiguration?
    var movies: [Movie] = []
    var movieInfoArray: [MovieInfo?] = []
    var movie: Movie?
    var currentPage = 1
    
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        setupButton()
        
        setupTableView()
        fectchConfig()
        fetchMovieData()
    }
    
    func setupButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        button.backgroundColor = .systemBlue
        button.setTitle("Load More", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        myTable.tableFooterView = button
    }
    
    @objc func buttonTapped() {
        currentPage += 1
        fetchMoviesForCurrentPage()
    }
    
    func setupTableView() {
        
        myTable.dataSource = self
        myTable.delegate = self
    }
    
    func fetchMoviesForCurrentPage() {
        let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
        MovieService.fetchMovies(apiKey: apiKey, page: currentPage) { [weak self] movies in
            guard let self = self else { return }
            if let movies = movies {
                
                DispatchQueue.main.async {
                    self.movies += movies
                    self.myTable.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
    
    func fetchMovieData() {
        let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
        MovieService.fetchMovies(apiKey: apiKey,page: currentPage) { [weak self] movies in
            guard let self = self else { return }
            
            if let movies = movies {
                self.movies = movies
                
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                    //self.movie = self.movies[0]
                    //self.fetchInfo()
                }
            } else {
                DispatchQueue.main.async {
                }
            }
        }
        
    }

    func fectchConfig(){
        
        let apiKey = "e3d053e3f62984a4fa5d23b83eea3ce6"
        MovieService.fetchConfiguration(apiKey: apiKey){ [weak self] configuration in
            guard let self = self else { return }
            
            if configuration != nil{
                self.configuration = configuration
                DispatchQueue.main.sync {
                    self.myTable.reloadData()
                }
            }else{
                DispatchQueue.main.async {
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        
        
        
        cell.title?.text = movie.title
        cell.desc?.text = movie.overview
        cell.rating?.text = String(movie.vote_average!)

        
        
        if let configuration = configuration, let posterPath = movie.poster_path {
            
            if let fullPosterURL = URL(string: configuration.base_url)?
                .appendingPathComponent(configuration.poster_sizes[5])
                .appendingPathComponent(posterPath) {
                cell.img.sd_setImage(with: fullPosterURL, placeholderImage: UIImage(named: "placeholderImage"))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        
        let movie = movies[indexPath.row]
        vc.movie = movie
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


