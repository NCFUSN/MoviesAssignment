//
//  AuthToken.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import Foundation

class AuthToken: Codable {
    let requestToken: String?
    let expiresAt: String?
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
        case expiresAt = "expires_at"
    }
}
