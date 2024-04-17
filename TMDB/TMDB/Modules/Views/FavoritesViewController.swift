//
//  GenresViewController.swift
//  TMDB
//
//  Created by Пащенко Иван on 12.04.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var genresList: [Genres] = []
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        RequestsStaticClass.get { result in
//            switch result {
//            case .success(let response):
//                response.genres!.forEach({ genre in
//                    self.genresList.append(genre)
//                })
//                self.tableView.reloadData()
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        RequestsStaticClass.getMovieList { result in
            switch result {
            case .success(let responce):
                responce.results!.forEach({movie in
                    self.movieList.append(movie)
                })
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(movieList.count)
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        cell.backgroundColor = .black
//        cell.textLabel?.backgroundColor = .black
//        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        cell.textLabel?.text = movieList[indexPath.row].title
        return cell
    }
}
