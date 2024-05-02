//
//  GenresViewController.swift
//  TMDB
//
//  Created by Пащенко Иван on 12.04.2024.
//

import UIKit
import Kingfisher

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userData: ReturnUserDataStruct
    var requestResponce: FavoritesStruct = FavoritesStruct(page: 0, results: [], total_pages: 0, total_results: 0)
    var movieList: Array<Movie> = []
    
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
        
//        tableView.dataSource = self
        
        if let savedData = UserDefaults.standard.object(forKey: "userData") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(ReturnUserDataStruct.self, from: savedData) {
                self.userData = loadedData
            }
        }
        
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var page: Int = 1
        
        RequestClass.request(address: .GetFavoriteMovies, params: .GetFavoriteMoviesParam(.init(requestType: .get, sessionId: userData.session_id, sort_by: "created_at.asc", page: page, language: "en-US", account_id: userData.user_data.id))) { (responce: Result<FavoritesStruct, Error>) in
            
            switch responce {
            case .success(let result):
                self.requestResponce = result
                self.movieList = result.results
                self.tableView.reloadData()
//                print(result)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        if (requestResponce.total_results == 0) {
            return 1
        } else {
            return requestResponce.results.count
        }
    }

    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if requestResponce.total_results == 0 {
            let emptyCell = UITableViewCell()
            emptyCell.selectionStyle = .none
            emptyCell.textLabel?.textAlignment = .center
            emptyCell.textLabel?.textColor = .label
            emptyCell.textLabel?.text = "You don`t have any favorites movie yet"
            return emptyCell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = movieList[indexPath.row].title
            cell.selectionStyle = .none
//            guard let customCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as? FavoriteTableViewCell else {
//                print("Error with creating cell")
//                return UITableViewCell()
//            }
//            let movie = movieList[indexPath.row]
//            customCell.selectionStyle = .none
//            customCell.titleLabel.text = movie.title
//            print(movie.backdrop_path!)
//            if let backdropPath = movie.backdrop_path, !backdropPath.isEmpty {
//                let url = URL(string: "https://image.tmdb.org/t/p/original\(movie.backdrop_path!)")
//                customCell.favoriteImageView.kf.setImage(with: url)
//            } else {
//                // Установите изображение по умолчанию, если backdrop_path отсутствует или пуст
//                customCell.favoriteImageView.image = UIImage(named: "defaultImage")
//            }
//            return customCell
            return cell
        }
    }


}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movieList[indexPath.row]
        
        let movieStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = movieStoryBoard.instantiateViewController(withIdentifier: "MovieDataViewController") as? MovieDataViewController {
            viewController.userData = userData
            viewController.movieData = movieList[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
