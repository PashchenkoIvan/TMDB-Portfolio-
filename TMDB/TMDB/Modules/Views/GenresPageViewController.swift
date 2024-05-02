//
//  ViewController.swift
//  TMDB
//
//  Created by Пащенко Иван on 10.04.2024.
//

import UIKit
import Kingfisher

class GenresPageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var movieList:[Movie] = []
    
    var userData: ReturnUserDataStruct
    
    init(userData: ReturnUserDataStruct) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        if let savedData = UserDefaults.standard.object(forKey: "userData") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(ReturnUserDataStruct.self, from: savedData) {
                self.userData = loadedData
            } else {
                fatalError("Unable to decode userData")
            }
        } else {
            fatalError("No userData found in UserDefaults")
        }
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "GeneralCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RequestClass.request(address: .GetTrendMovies, params: .GetTrendMovies(.init(requestType: .get, language: "en-US"))) { (responce: Result<TrendingMovieStruct, Error>) in
            switch responce {
            case .success(let result):
                result.results.forEach { movie in
                    self.movieList.append(movie)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

extension GenresPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentify", for: indexPath) as? Cell else {
            print("Error with creating cell")
            return UICollectionViewCell()
        }
        
        let movieData = movieList[indexPath.row]
        let url = URL(string: "https://image.tmdb.org/t/p/original\(movieData.backdrop_path!)")
        
        cell.titleLabel.text = movieData.title
        cell.descriptionLabel.text = movieData.overview
        cell.dateLabel.text = movieData.release_date
        cell.vote_averageLabel.text = "\(movieData.vote_average!)"
        cell.vote_countLabel.text = "\(movieData.vote_count!)"
        cell.backgroundImageView.kf.setImage(with: url)
        
        return cell
    }


    
    
}

extension GenresPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movieList[indexPath.row]
        
        // Создайте экземпляр MovieDataViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieDataViewController = storyboard.instantiateViewController(withIdentifier: "MovieDataViewController") as? MovieDataViewController else {
            return
        }
        
        // Передайте выбранный фильм в MovieDataViewController
        movieDataViewController.movieData = movie
        movieDataViewController.userData = self.userData
        
        // Перейдите на MovieDataViewController
        navigationController?.pushViewController(movieDataViewController, animated: true)
    }
}


