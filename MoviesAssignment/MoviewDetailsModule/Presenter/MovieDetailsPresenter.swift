//
//  MovieDetailsPresenter.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import Foundation
import UIKit
protocol MovieDetailsPresenterDelegate: class {
    func didLikeMediaItem()
    func didDislikeMediaItem()
    func didFail(error: Error)
}
class MovieDetailsPresenter: NSObject {
    
    private let mediaItem: FullMediaItemInfo!
    let backgroundColor: UIColor = .black
    weak var delegate: MovieDetailsPresenterDelegate?
    
    var originalTitle: String {
        if let originalTitle = mediaItem.originalTitle {
            return "Original Title: "+originalTitle
        }
        return "Original Title: Unknown"
    }
    
    var title: String {
        if let title = mediaItem.title {
            return "Title: "+title
        }
        return "Title: Unknown"
    }
    
    var overview: String {
        if let overview = mediaItem.overview {
            return overview
        }
        return ""
    }
    
    var rating: String {
        if let popularity = mediaItem.popularity {
            return "Popularity: "+String(popularity)
        }
        return ""
    }
    
    var genres: String {
        if let genresArray = mediaItem.genres {
            let mutableString = NSMutableString()
            genresArray.forEach { genre in
                if let name = genre.name {
                    mutableString.append(" "+name+" |")
                }
            }
            return mutableString as String
        }
        return ""
    }
    
    var likeButtonTitle: String {
        if isMediaItemLiked {
            return "Dislike"
        }
        return "Like"
    }
    
    private var isMediaItemLiked: Bool {
        return false
    }
    
    init(model: FullMediaItemInfo) {
        self.mediaItem = model
        super.init()
    }
    
    func likeMediaItem() {
        if let id = mediaItem.id {
            NetworkAPI().favouriteMovie(movieId: Int(id)) { (response, error) in
                if let success = response?.success {
                    if !success {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: response!.statusMessage as String]) as Error
                        self.delegate?.didFail(error: error)
                    }
                }
            }
        }
    }
    
    func downloadPoster(completion: @escaping (UIImage) -> Void) {
        DispatchQueue.main.async {
            if let url = self.mediaItem.posterUrl {
                let data = try? Data(contentsOf: URL(string: url)!)
                if let data = data {
                    if let image = UIImage(data: data) {
                        completion(image)
                    }
                }
            }
        }
    }
}
