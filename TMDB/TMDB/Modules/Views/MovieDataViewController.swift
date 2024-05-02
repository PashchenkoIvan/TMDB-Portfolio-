//
//  MovieDataViewController.swift
//  TMDB
//
//  Created by Пащенко Иван on 30.04.2024.
//

import UIKit
import Kingfisher

class MovieDataViewController: UIViewController {
    
    var movieData: Movie?
    var userData: ReturnUserDataStruct?
    
    
    
    var isFavouriteMovie: Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var vote_countLabel: UILabel!
    @IBOutlet weak var vote_averageLabel: UILabel!
    
    @objc func addTapped() {
        if (!isFavouriteMovie) {
            
            guard let user_data = userData as? ReturnUserDataStruct else {
                print("Error with getting user data")
                return
            }
            guard let movie_data = movieData as? Movie else {
                print("Error with getting movie data")
                return
            }
            
            RequestClass.request(address: Address.GetFavoriteMovies, params: Params.AddFavoriteMovie(AddMovieParams.init(requestType: .post, account_id: user_data.user_data.id, session_id: user_data.session_id, media_type: "movie", media_id: movie_data.id!, favorite: true))) { (responce: Result<AddFavoriteMovieStruct, Error>) in
                switch responce {
                case .success(let success):
                    print(success)
                    self.isFavouriteMovie = true
                case .failure(let failure):
                    print(failure)
                }
            }
        } else {
            print("This movie is already in favorite list")
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = addButton

        
        guard let movie = movieData as? Movie else {
            print("Error with getting movieData")
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/original\(movie.backdrop_path!)")
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        titleLabel.text = movie.title
        
        descriptionLabel.text = movie.overview
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        dateLabel.text = movie.release_date
        
        vote_averageLabel.text = "\(movie.vote_average!)"
        
        vote_countLabel.text = "\(movie.vote_count!)"
        
    }
    
}
