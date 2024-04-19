//
//  requestClass.swift
//  TMDB
//
//  Created by Пащенко Иван on 19.04.2024.
//

import Foundation
import Alamofire



enum Adress: String {
    case GenresList = "genre/movie/list"
    case MovieList = "discover/movie"
    case GetRequestToken = "authentication/token/new"
    case CreateRequestToken = "authentication/token/validate_with_login"
    case CreateSessionId = "authentication/session/new"
    case GetUserInfo = "account"
    case GetFavoriteMovies = "account/"
}

enum Params {
    case GenresListParam(GetGenresListParams)
    case GetMovieParam(GetMovieParams)
    case GetRequestTokenParam(GetRequestTokenParams)
    case CreateRequestTokenParam(CreateRequestTokenParams)
    case CreateSessionIdParam(CreateSessionIdParams)
    case GetUserInfoParam(GetUserInfoParams)
    case GetFavoriteMoviesParam(GetFavoritesParams)
}


class RequestClass {
    private static let defaultUrl = "https://api.themoviedb.org/3/"
    private static let apiKey = ProcessInfo.processInfo.environment["api_key"]!
    
    static func request<T: Codable>(adress: Adress, params: Params, completion: @escaping (Result<T, Error>) -> ()) {
        var url:String
        var method:HTTPMethod
        
        switch params {
            
        case .GenresListParam(let param):
            url = "\(defaultUrl)\(adress.rawValue)?api_key=\(self.apiKey)&language=\(param.language)"
            method = param.requestType
            
        case .GetMovieParam(let param):
            url = "\(defaultUrl)\(adress.rawValue)?api_key=\(self.apiKey)"
            method = param.requestType
            
        case .GetRequestTokenParam(let param):
            url = "\(defaultUrl)\(adress.rawValue)?api_key=\(self.apiKey)"
            method = param.requestType
            
        case .CreateRequestTokenParam(let param):
            url = "\(defaultUrl)\(adress.rawValue)?api_key=\(self.apiKey)&username=\(param.username)&password=\(param.password)&request_token=\(param.requestToken)"
            method = param.requestType
            
        case .CreateSessionIdParam(let param):
            url = "\(defaultUrl)\(adress.rawValue)?api_key=\(self.apiKey)&request_token=\(param.requestToken)"
            method = param.requestType
            
        case .GetUserInfoParam(let param):
            url = "\(defaultUrl)\(adress.rawValue)?api_key=\(self.apiKey)&session_id=\(param.sessionId)"
            method = param.requestType
            
        case .GetFavoriteMoviesParam(let param):
            url = "\(defaultUrl)\(adress.rawValue)/\(param.account_id)/favorite/movies?api_key=\(self.apiKey)&language=\(param.language)&page=\(param.page)&sort_by=\(param.sort_by)&session_id=\(param.sessionId)"
            method = param.requestType
            
        }
        
        
        AF.request(url, method: method)
            .validate()
            .responseJSON { responce in
                switch responce.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else {
                        print("Invalid data format")
                        return
                    }
                    
                    let jsonData = try! JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    
                    do {
                        let resultData = try decoder.decode(T.self, from: jsonData)
                        completion(.success(resultData))
                    } catch {
                        print("Decode error: \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
