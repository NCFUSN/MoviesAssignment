//
//  MovieDetailsViewController.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import UIKit

class MovieDetailsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOriginalTitle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblMetaData: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var ivPoster: UIImageView!
    
    let presenter: MovieDetailsPresenter!
    
    init(presenter: MovieDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: "MovieDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        self.view.backgroundColor = presenter.backgroundColor
        lblTitle.text = presenter.title
        lblOriginalTitle.text = presenter.originalTitle
        lblOverview.text = presenter.overview
        lblMetaData.text = presenter.rating
        lblGenres.text = presenter.genres
        btnLike.setTitle(presenter.likeButtonTitle, for: .normal)
        presenter.downloadPoster { [self] (image) in
            ivPoster.image = image
        }
        //scrollView.resizeScrollViewContentSize()
    }
    
    @IBAction func btnLikePressed(sender: UIButton) {
        presenter.likeMediaItem()
    }
}

extension MovieDetailsViewController: MovieDetailsPresenterDelegate {
    
    func didFail(error: Error) {
        Utils.presentError(error: error, for: self)
    }
    
    func didLikeMediaItem() {
        btnLike.setTitle(presenter.likeButtonTitle, for: .normal)
    }
    
    func didDislikeMediaItem() {
        btnLike.setTitle(presenter.likeButtonTitle, for: .normal)
    }
}

extension UIScrollView {

    func resizeScrollViewContentSize() {
        var contentRect = CGRect.zero
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}
