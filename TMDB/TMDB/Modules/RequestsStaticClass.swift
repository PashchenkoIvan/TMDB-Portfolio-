//
//  RequestsStaticClass.swift
//  TMDB
//
//  Created by Пащенко Иван on 11.04.2024.
//

import Foundation
import Alamofire

class RequestsStaticClass {
    static func getGenresList(completion: @escaping (Result<GenresListStruct, Error>) -> Void) {
        let url = ProcessInfo.processInfo.environment["GenresList"]!
        AF.request(url).responseJSON { response in
            do {
                let decoder = JSONDecoder()
                let resultData = try decoder.decode(GenresListStruct.self, from: response.data!)
                completion(.success(resultData))
            } catch {
                completion(.failure(error))
            }
        }
    }

}
