//
//  RequestsStaticClass.swift
//  TMDB
//
//  Created by Пащенко Иван on 11.04.2024.
//

import Foundation
import Alamofire

class RequestsStaticClass {
    
    static func getGenresList(completion: @escaping (Result<GenresListStruct, Error>) -> ()) {
        let url = "https://api.themoviedb.org/3/genre/movie/list?language=en&api_key=\(apiKey)"
        AF.request(url)
            .validate()
            .response { responce in
                guard let data = responce.data else {
                    if let error = responce.error {
                        completion(.failure(error))
                    }
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let genresResults = try? decoder.decode(GenresListStruct.self, from: data) else {
                    return
                }
                completion(.success(genresResults))
            }
    }
    
    static func getMovieList(completion: @escaping (Result<MovieListResponce, Error>) -> ()) {
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)"
        AF.request(url)
            .validate()
            .response { responce in
                guard let data = responce.data else {
                    if let error = responce.error {
                        completion(.failure(error))
                    }
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let movieResult = try? decoder.decode(MovieListResponce.self, from: data) else {
                    return
                }
                completion(.success(movieResult))
            }
    }
    
    
    static let apiKey = ProcessInfo.processInfo.environment["api_key"]!
    
    private static func getRequestTokenUrl(completion: @escaping (Result<RequestTokenStruct, Error>) -> ()) {
        let url:String = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)"
        
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else {
                        print("Invalid data format.")
                        return
                    }

                    let jsonData = try! JSONSerialization.data(withJSONObject: json)
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        let requestToken = try decoder.decode(RequestTokenStruct.self, from: jsonData)
//                        print("First request token: \(requestToken)")
                        completion(.success(requestToken))
                    } catch {
                        print("Decode error: \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private static func createRequestTokenWithLogin(username: String, password: String, request_token: String, completion: @escaping (Result<RequestTokenStruct, Error>) -> ()) {
        let url = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)&username=\(username)&password=\(password)&request_token=\(request_token)"
        
        AF.request(url, method: .post)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else {
                        print("Invalid data format.")
                        return
                    }
                    let jsonData = try! JSONSerialization.data(withJSONObject: json)
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        let requestToken = try decoder.decode(RequestTokenStruct.self, from: jsonData)
//                        print("Second request token: \(requestToken)")
                        completion(.success(requestToken))
                    } catch {
                        print("Decode error: \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private static func createSessionId(request_token: String, completion: @escaping (Result<SessionIdStruct, Error>) -> ()) {
        let url = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)&request_token=\(request_token)"
        
        AF.request(url, method: .post)
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
                        let sessionId = try decoder.decode(SessionIdStruct.self, from: jsonData)
//                        print("Session id: \(sessionId)")
                        completion(.success(sessionId))
                    } catch {
                        print("Decode error \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private static func getUserInfo(session_id: String, completion: @escaping (Result<ReturnUserDataStruct, Error>) -> ()) {
        let url = "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(session_id)"
        
        AF.request(url)
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
                        let userData = ReturnUserDataStruct(session_id: session_id, user_data: try decoder.decode(UserDataStruct.self, from: jsonData))
//                        print("User data: \(userData)")
                        completion(.success(userData))
                    } catch {
                        print("Decode error \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    static func loginUser(username: String, password: String, completion: @escaping (Result<ReturnUserDataStruct, Error>) -> ()) {
        getRequestTokenUrl { getingRequestTokenResponce in
            switch getingRequestTokenResponce {
                
            case .success(let result):
                
                createRequestTokenWithLogin(username: username, password: password, request_token: result.request_token) { creatingRequestTokenWithLoginResponce in
                    switch creatingRequestTokenWithLoginResponce {
                    case .success(let result):
                        
                        createSessionId(request_token: result.request_token) { sessionIdResponce in
                            switch sessionIdResponce {
                                
                            case .success(let result):
                                
                                getUserInfo(session_id: result.session_id) { userInfoResponce in
                                    switch userInfoResponce {
                                        
                                    case .success(let result):
                                        completion(.success(result))
                                    case .failure(let error):
                                        print("Error with getting user info: \(error)")
                                    }
                                }
                            case.failure(let error):
                                print("Error with creating sessionId: \(error)")
                            }
                        }
                    case .failure(let error):
                        print("Error with creating request token: \(error)")
                    }
                }
            case .failure(let error):
                print("Error with geting req.token: \(error)")
            }
        }
    }
    
}
