//
//  OmdbApiService.swift
//  OMDBClient
//
//  Created by Sahin Yesilyurt on 16.06.2020.
//  Copyright © 2020 sahiny. All rights reserved.
//

import Foundation
import Alamofire

class OmdbApiService: NSObject {
    private static let apiKey = "317b63e1"
    private static let apiUrl = "https://www.omdbapi.com/?"
    private static var sharedOmdbApiService: OmdbApiService = {
        return OmdbApiService()
    }()

    class func shared() -> OmdbApiService {
        return sharedOmdbApiService
    }

    private override init() {
        super.init()
    }
    
    static func search(_ searchText:String, completed: @escaping ([Movie]) -> Void) {
        AF.request(OmdbApiService.apiUrl, method: .get, parameters:[
            "apiKey": OmdbApiService.apiKey,
            "s": searchText,
            "type": "movie"
        ]).validate().responseDecodable(of: MovieSearch.self) { response in
            guard let movies = response.value else {
                completed([])
                return
            }
            if (movies.response == "False") {
                completed([])
            } else {
                completed(movies.search)
            }
            
            
        }
        
    }
    
    static func getMovie(_ imdbId:String, completed: @escaping (MovieDetail?) -> Void) {
        AF.request(OmdbApiService.apiUrl, method: .get, parameters:[
                   "apiKey": OmdbApiService.apiKey,
                   "i": imdbId,
                   "plot":"full"
        ]).validate().responseDecodable(of: MovieDetail.self) { response in
            guard let movie = response.value else {
                completed(nil)
                return
            }
            if(movie.response == "False"){
                completed(nil)
            } else {
                completed(movie)
            }
           
           
        }
    }
}
