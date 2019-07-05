//
//  MovieSearchViewController.swift
//  MovieDBAssessmentiOS27
//
//  Created by Austin West on 7/5/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Any] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCellTableViewCell
        guard let movie = movies[indexPath.row] as? AJDWMovie else { return UITableViewCell() }
        AJDWMovieController.sharedInstance().fetchPoster(for: movie) { (image) in
            DispatchQueue.main.async {
                cell.moviePosterImageView.image = image
            }
        }
        cell.movieTitleLabel.text = movie.movieTitle
        if let unwrappedRating = movie.rating {
            cell.ratingLabel.text = "Average rating: \(unwrappedRating)"
        } else {
            cell.ratingLabel.text = "Average rating: (not rated, yet)"
        }
        cell.summaryLabel.text = movie.movieDescription
        return cell
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        AJDWMovieController.sharedInstance().fetchMovies(withSearch: searchText) { (moviesReturn) in
            guard !moviesReturn.isEmpty else { return }
            self.movies = moviesReturn
        }
    }
}
