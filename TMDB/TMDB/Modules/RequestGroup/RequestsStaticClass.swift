//
//  RequestsStaticClass.swift
//  TMDB
//
//  Created by Пащенко Иван on 11.04.2024.
//

import Foundation
import Alamofire

class RequestsStaticClass {
    
    static func loginUser(username: String, password: String, completion: @escaping (Result<ReturnUserDataStruct, Error>) -> ()) {
        
        var session_id: String = ""
        
        RequestClass.request(adress: .GetRequestToken, params: .GetRequestTokenParam(.init(requestType: .get))) { (FRresponce: Result<RequestTokenStruct, Error>) in
            
            switch FRresponce {
            case .success(let result):
                
                RequestClass.request(adress: .CreateRequestToken, params: .CreateRequestTokenParam(.init(requestType: .post, username: username, password: password, requestToken: result.request_token))) { (SRresponce: Result<RequestTokenStruct, Error>) in
                    
                    switch SRresponce {
                    case .success(let result):
                        
                        RequestClass.request(adress: .CreateSessionId, params: .CreateSessionIdParam(.init(requestType: .post, requestToken: result.request_token))) { (Sresponce:Result<SessionIdStruct, Error>) in
                            
                            switch Sresponce {
                            case .success(let result):
                                
                                session_id = result.session_id
                                
                                RequestClass.request(adress: .GetUserInfo, params: .GetUserInfoParam(.init(requestType: .get, sessionId: result.session_id))) { (UIresponce:Result<UserDataStruct, Error>) in
                                    
                                    switch UIresponce {
                                    case .success(let result):
                                        
                                        completion(.success(ReturnUserDataStruct(session_id: session_id, user_data: result)))
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            case.failure(let error):
                                print(error)
                            }
                        }
                    case.failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
