//
//  AddFavoriteMovieStruct.swift
//  TMDB
//
//  Created by Пащенко Иван on 01.05.2024.
//

import Foundation

struct AddFavoriteMovieStruct: Encodable, Decodable {
    let status_code: Int
    let status_message: String
}
