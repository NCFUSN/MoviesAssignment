//
//  AddToFavouriteResponse.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import Foundation

class AddToFavouriteResponse: Codable {
    let success: Bool
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case statusMessage = "status_message"
    }
}
