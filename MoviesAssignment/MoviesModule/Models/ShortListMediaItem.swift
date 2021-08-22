//
//  ShortListMediaItem.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import Foundation

protocol ShortList {
    var id: Int? { get }
    var originalTitle: String? { get }
    var title: String? { get }
    var popularity: Double? { get }
    var posterPath: String? { get }
    var voteAverage: Double? { get }
}

class ShortListMediaItem: Codable, ShortList {
    
    let id: Int?
    let originalTitle: String?
    let title: String?
    let popularity: Double?
    let posterPath: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case originalTitle = "original_title"
        case title = "title"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    var posterUrl: String? {
        if let path = self.posterPath {
            return "https://image.tmdb.org/t/p/w500/"+path
        }
        return nil
    }
}
