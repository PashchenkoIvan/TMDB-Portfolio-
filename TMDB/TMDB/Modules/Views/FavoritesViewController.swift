//
//  GenresViewController.swift
//  TMDB
//
//  Created by Пащенко Иван on 12.04.2024.
//

import UIKit

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
        
        tableView.dataSource = self
        
        if let savedData = UserDefaults.standard.object(forKey: "userData") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(ReturnUserDataStruct.self, from: savedData) {
                self.userData = loadedData
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var page: Int = 1
        
        RequestClass.request(adress: .GetFavoriteMovies, params: .GetFavoriteMoviesParam(.init(requestType: .get, sessionId: userData.session_id, sort_by: "created_at.asc", page: page, language: "en-US", account_id: userData.user_data.id))) { (responce: Result<FavoritesStruct, Error>) in
            
            switch responce {
            case .success(let result):
                self.requestResponce = result
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (requestResponce.total_results == 0) {
            return 1
        } else {
            return requestResponce.results.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        if (requestResponce.total_results == 0) {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .label
            cell.textLabel?.text = "You dont have any favorite movie yet"
        } else {
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.text = requestResponce.results[indexPath.row].title
        }
//        cell.textLabel?.text = movieList[indexPath.row].title
        return cell
    }
}
