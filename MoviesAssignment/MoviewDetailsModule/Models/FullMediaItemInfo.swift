//
//  FullMediaItemInfo.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import UIKit

protocol LongList: ShortList {
    var id: Int? { get }
    var isAdult: Bool? { get }
    var budget: Int? { get }
    var genres: [Genre]? { get }
    var homePage: String? { get }
    var originalTitle: String? { get }
    var overview: String? { get }
    var popularity: Double? { get }
    var posterPath: String? { get }
    var releaseDate: String? { get }
    var runtime: Double? { get }
    var status: String? { get }
    var tagLine: String? { get }
    var title: String? { get }
    var voteAverage: Double? { get }
}

struct FullMediaItemInfo: Decodable, LongList {
    
    var id: Int?
    let isAdult: Bool?
    let budget: Int?
    let genres: [Genre]?
    let homePage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Double?
    let status: String?
    let tagLine: String?
    let title: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case isAdult = "adult"
        case budget = "budget"
        case genres = "genres"
        case homePage = "homepage"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime = "runtime"
        case status = "status"
        case tagLine = "tagline"
        case title = "title"
        case voteAverage = "vote_average"
    }
    
    var posterUrl: String? {
        if let path = self.posterPath {
            return "https://image.tmdb.org/t/p/w500/"+path
        }
        return nil
    }
}
