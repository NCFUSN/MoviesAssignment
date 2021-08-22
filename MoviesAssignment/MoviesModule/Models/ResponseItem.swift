//
//  ResponseItem.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import Foundation

struct ResponseItem: Codable {
    let currentPage: Int?
    let mediaItems: [ShortListMediaItem]?
    let allPages: Int?
    let allMediaItems: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case mediaItems = "results"
        case allPages = "total_pages"
        case allMediaItems = "total_results"
    }
}

