//
//  MoviesCollectionViewController.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class MoviesCollectionViewController: UICollectionViewController {
    
    let presenter: MoviesViewPresenter!
    
    init(presenter: MoviesViewPresenter) {
        self.presenter = presenter
        super.init(nibName: "MoviesCollectionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = presenter.backgroundColor
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.dataSource = presenter
        presenter.registerCells(for: collectionView)
        presenter.delegate = self
        self.title = presenter.title
        self.navigationController?.navigationBar.topItem!.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Sort by Popularity", style: .default , handler:{ (UIAlertAction)in
                self.presenter.sortByRating()
                self.collectionView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Show My Favourites", style: .default , handler:{ (UIAlertAction)in
                self.presenter.sortByFavourites()
            }))

            alert.addAction(UIAlertAction(title: "Show Now Playing Movies", style: .destructive , handler:{ (UIAlertAction)in
                self.presenter.fetchPlayingNowMovies()
            }))
        
        alert.addAction(UIAlertAction(title: "Show Popular Movies", style: .default , handler:{ (UIAlertAction)in
            self.presenter.fetchPopularMovies()
        }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            }))

            
            //for iPad Support
            alert.popoverPresentationController?.sourceView = self.view

        self.present(alert.fixConstraints(), animated: true, completion: {
                
            })
    }

    // MARK: UICollectionViewDataSource
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let insetLeft: CGFloat = 5.0
        let insetRight: CGFloat = 5.0
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: insetLeft,
                                           bottom: 5.0,
                                           right: insetRight)
        let itemWidth = UIScreen.main.bounds.width / 2 - (insetLeft + insetRight)
        layout.itemSize = CGSize(width: itemWidth, height: 300.0)
        return layout
      }()
}

extension UIAlertController {
    // fixes the Apple bug when constsraints break as actionSheet appeares
   func fixConstraints() -> UIAlertController {
      view.callRecursively { subview in
         subview.constraints
            .filter({ $0.constant == -16 })
            .forEach({ $0.priority = UILayoutPriority(rawValue: 999)})
    }
    return self
    }
}

// fixes the Apple bug when constsraints break as actionSheet appeares
extension UIView {
   func callRecursively(_ body: (_ subview: UIView) -> Void) {
      body(self)
      subviews.forEach { $0.callRecursively(body) }
   }
}

extension MoviesCollectionViewController: MoviesViewPresenterDelegate {
    func showTitle(title: String) {
        self.title = title
    }
    
    func notify(message: String) {
        Utils.presentMessage(message: message, for: self)
    }
    
    func didRequestReloadData() {
        self.collectionView.reloadData()
    }
    
    func didFail(error: Error) {
        Utils.presentError(error: error, for: self)
    }
}
