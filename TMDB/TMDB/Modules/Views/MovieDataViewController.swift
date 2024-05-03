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
        
        var url = URL(string: "")
        if movie.backdrop_path == nil {
            url = URL(string: "http://designingpupilintermediary.com/canuthkx?qlru=62&refer=https%3A%2F%2Fwww.peakpx.com%2Fen%2Fhd-wallpaper-desktop-vmpiw&kw=%5B%22technology%22%2C%22error%22%2C%22404%22%2C%22not%22%2C%22found%22%2C%22black%22%2C%22white%22%2C%22minimalist%22%2C%22hd%22%2C%22wallpaper%22%2C%22peakpx%22%5D&key=1001c8ae384bf3571ef4f7a804d4d9c9&scrWidth=1440&scrHeight=900&tz=3&v=24.5.6485&ship=&psid=www.peakpx.com,www.peakpx.com&sub3=invoke_layer&res=14.29&dev=r&uuid=e801db1e-8957-47ca-9e96-e11856d8a250%3A2%3A1")
        } else {
            url = URL(string: "https://image.tmdb.org/t/p/original\(movie.backdrop_path!)")
        }
        
        navigationController?.topViewController?.title = movie.title
        
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
