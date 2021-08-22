//
//  NetworkAPI.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import Foundation
import Alamofire

enum MovieListType {
    case popular
    case nowPlaying
    case favourites
}

class NetworkAPI {
    
    private let timeout = 60.0
    
    func fetchMovies(page: Int, movieListType: MovieListType, rating: Rating, completion: @escaping (ResponseItem?, Error?) -> Void) {
        var popularity: String
        if rating == .high {
            popularity = ".desc"
        } else {
            popularity = ".asc"
        }
        if let apiKey = Utils.APIKEY {
            var url: URL
            switch movieListType {
            case .popular:
                url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity\(popularity)&include_adult=false&include_video=false&page=\(page)")!
                break
            case .nowPlaying:
                url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&sort_by=popularity\(popularity)&include_adult=false&include_video=false&page=\(page)")!
            case .favourites:
                url = URL(string: "https://api.themoviedb.org/3/favorite/movies?api_key="+apiKey+"&language=en-US&include_adult=false&include_video=false&sort_by=created_at.asc&page="+String(page))!
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval =  timeout
            urlRequest.allowsConstrainedNetworkAccess = false
            AF.request(urlRequest).response { response in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
                if let data = response.data {
                    let item: ResponseItem = try! JSONDecoder().decode(ResponseItem.self, from: data)
                    completion(item, nil)
                }
            }
        }
    }
    func getMoviewById(id: Int, completion: @escaping (FullMediaItemInfo?, Error?) -> Void) {
        if let apiKey = Utils.APIKEY {
            let url = URL(string: "https://api.themoviedb.org/3/movie/"+String(id)+"?api_key="+apiKey+"&language=en-US")
            var urlRequest = URLRequest(url: url!)
            urlRequest.timeoutInterval =  timeout
            urlRequest.allowsConstrainedNetworkAccess = false
            AF.request(urlRequest).response { response in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
                if let data = response.data {
                    let item: FullMediaItemInfo = try! JSONDecoder().decode(FullMediaItemInfo.self, from: data)
                    completion(item, nil)
                }
            }
        }
    }
    
    func getAuthToken(completion: @escaping (AuthToken?, Error?)-> Void) {
        if let apiKey = Utils.APIKEY {
            let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key="+apiKey)
            var urlRequest = URLRequest(url: url!)
            urlRequest.timeoutInterval =  timeout
            urlRequest.allowsConstrainedNetworkAccess = false
            AF.request(urlRequest).response { response in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
                if let data = response.data {
                    let item: AuthToken = try! JSONDecoder().decode(AuthToken.self, from: data)
                    completion(item, nil)
                }
            }
        }
    }
    
    func favouriteMovie(movieId: Int, completion: @escaping (AddToFavouriteResponse?, Error?)-> Void) {
        if let apiKey = Utils.APIKEY {
            getAuthToken { (token, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                if let token = token?.requestToken {
                    let url = URL(string: "https://api.themoviedb.org/3/favorite?api_key="+apiKey+"&session_id="+token)
                    var urlRequest = URLRequest(url: url!)
                    urlRequest.timeoutInterval =  self.timeout
                    urlRequest.allowsConstrainedNetworkAccess = false
                    urlRequest.httpMethod = HTTPMethod.post.rawValue
                    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    let body: NSMutableDictionary? = [
                        "media_type": "movie",
                        "media_id": movieId,
                        "favorite": true
                    ]
                    let bodyData = try! JSONSerialization.data(withJSONObject: body!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    urlRequest.httpBody = bodyData
                    AF.request(urlRequest).response { response in
                    guard response.error == nil else {
                        completion(nil, response.error)
                        return
                    }
                        if let data = response.data {
                            let item: AddToFavouriteResponse = try! JSONDecoder().decode(AddToFavouriteResponse.self, from: data)
                            completion(item, nil)
                        }
                    }
                }
            }
        }
    }
}
