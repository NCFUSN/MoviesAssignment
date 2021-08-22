//
//  MoviesViewPresenter.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import Foundation
import UIKit

enum Rating {
    case high
    case low
}

protocol MoviesViewPresenterDelegate: class {
    func didRequestReloadData()
    func didFail(error: Error)
    func notify(message: String)
    func showTitle(title: String)
}

class MoviesViewPresenter: NSObject {
    private var model: ResponseItem
    let backgroundColor: UIColor = .white
    private var mediaItemsStorage = [ShortListMediaItem]()
    private let cellIdentifier = "MediaItemCell"
    private var rating: Rating = .high
    weak var delegate: MoviesViewPresenterDelegate?
    var currentMovieListType: MovieListType = .popular
    var title = "Popular Movies"
    
    var mediaItems: [ShortListMediaItem] {
        return mediaItemsStorage
    }
    var count: Int {
        return mediaItemsStorage.count
    }
    
    required init(model: ResponseItem) {
        self.model = model
        if let mediaItems = model.mediaItems {
            mediaItemsStorage += mediaItems
            delegate?.showTitle(title: "Popular Movies")
        }
    }
    
    func registerCells(for collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "MoviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
      }
    
    func sortByRating() {
        if rating == .high {
            fetchMovies()
            delegate?.showTitle(title: "Sorted by popularity ASC")
            return
        }
        fetchMovies()
        rating = .high
        delegate?.showTitle(title: "Sorted by popularity DESC")
    }
    
    private func fetchMovies(page: Int = 1) {
        NetworkAPI().fetchMovies(page: page, movieListType: currentMovieListType, rating: rating) { [self] (responseItem, error) in
            if error != nil {
                self.delegate?.didFail(error: error!)
                return
            }
            if responseItem?.mediaItems == nil {
                delegate?.notify(message: "No movies found. Please, try another search criteria")
                return
            }
            self.mediaItemsStorage.removeAll()
            self.mediaItemsStorage += responseItem!.mediaItems!
            self.delegate?.didRequestReloadData()
        }
    }
    
    func sortByFavourites() {
        currentMovieListType = .favourites
        fetchMovies()
        delegate?.showTitle(title: "Favourites")
    }
    
    func fetchPlayingNowMovies() {
        currentMovieListType = .nowPlaying
        fetchMovies()
        delegate?.showTitle(title: "Now Playing")
    }
    
    func fetchNextMoviesPage() {
        if model.currentPage == model.allPages {
            return
        }
        NetworkAPI().fetchMovies(page: self.model.currentPage! + 1 , movieListType: currentMovieListType, rating: rating) { [self] (responseItem, error) in
            if let error = error {
                self.delegate?.didFail(error: error)
                return
            }
            if responseItem?.mediaItems == nil {
                self.delegate?.notify(message: "No movies found. Please, try another search criteria")
                return
            }
            self.model = responseItem!
            self.mediaItemsStorage += responseItem!.mediaItems!
            self.delegate?.didRequestReloadData()
        }
    }
    
    func fetchPopularMovies() {
        currentMovieListType = .popular
        fetchMovies()
        delegate?.showTitle(title: "Popular")
    }
}

extension MoviesViewPresenter: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MoviewCollectionViewCell
    let mediaItem = mediaItems[indexPath.row]
    return presentCell(cell: cell, mediaItem: mediaItem)
  }
    
    func presentCell(cell: MoviewCollectionViewCell, mediaItem: ShortListMediaItem) -> MoviewCollectionViewCell {
        if model.currentPage == 1 {
            if let _ = mediaItem.posterPath {
                let data = try? Data(contentsOf: URL(string: mediaItem.posterUrl!)!)
                cell.ivPoster.alpha = 0
                    DispatchQueue.main.async(execute: {
                        UIView.animate(withDuration: 1.0) {
                            cell.ivPoster.image = UIImage(data: data!)
                            cell.ivPoster.alpha = 1.0
                        }
                    });
            } else {
                // no-image-icon
                DispatchQueue.main.async(execute: {
                    UIView.animate(withDuration: 1.0) {
                        cell.ivPoster.image = UIImage(named: "no-image-icon")
                        cell.ivPoster.alpha = 1.0
                    }
                });
            }
            cell.lblTitle.alpha = 0
            DispatchQueue.main.async(execute: {
                UIView.animate(withDuration: 1.0) {
                    cell.lblTitle.text = mediaItem.title
                    cell.lblTitle.alpha = 1.0
                }
            });
            cell.contentView.layer.cornerRadius = 20.0
            return cell
        }
        if let _ = mediaItem.posterPath {
            let data = try? Data(contentsOf: URL(string: mediaItem.posterUrl!)!)
            cell.ivPoster.image = UIImage(data: data!)
        } else {
            cell.ivPoster.image = UIImage(named: "no-image-icon")
        }
        cell.lblTitle.text = mediaItem.title
        cell.contentView.layer.cornerRadius = 20.0
        return cell
    }
}

extension MoviesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaItem = presenter.mediaItems[indexPath.row]
        if let id = mediaItem.id {
            NetworkAPI().getMoviewById(id: id) { [self] (fullMediaItemInfo, error) in
                guard error == nil else {
                    // show error
                    return
                }
                let presenter = MovieDetailsPresenter(model: fullMediaItemInfo!)
                let controller = MovieDetailsViewController(presenter: presenter)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
  }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            presenter.fetchNextMoviesPage()
        }
    }
}


