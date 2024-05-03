//
//  SearchViewController.swift
//  TMDB
//
//  Created by Пащенко Иван on 12.04.2024.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userData: ReturnUserDataStruct
    var resultData: Array<Movie> = []
    
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

    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            RequestClass.request(address: .searchMovie, params: .searchMovie(.init(requestType: .get, query: searchText))) { (responce: Result<FavoritesStruct, Error>) in
                switch responce {
                case .success(let result):
                    self.resultData.removeAll()
                    
                    result.results.forEach { movie in
                        self.resultData.append(movie)
                    }
                    
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error with search: \(error)")
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultData.count == 0 {
            return 1
        } else {
            return resultData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        if resultData.count == 0 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Couldn't find a movie with the same name"
        } else {
            cell.textLabel?.text = resultData[indexPath.row].title
        }
        
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if resultData.count != 0 {
            let movie = resultData[indexPath.row]
            
            print(movie)
            
            let movieStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = movieStoryBoard.instantiateViewController(withIdentifier: "MovieDataViewController") as? MovieDataViewController {
                viewController.userData = userData
                viewController.movieData = resultData[indexPath.row]
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
