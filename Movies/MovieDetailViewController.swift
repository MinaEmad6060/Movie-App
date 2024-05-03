//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Mina Emad on 01/05/2024.
//

import UIKit
import Cosmos

class MovieDetailViewController: UIViewController {

    var movie: Movie?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!

    lazy var cosmosView :CosmosView = {
        var view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.starSize = 40
        view.settings.fillMode = .precise
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cosmosView)
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cosmosView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cosmosView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])


        if let unWrappedMovie = movie {
            cosmosView.rating = unWrappedMovie.rating

            titleLabel.text = unWrappedMovie.title
            if let imageData = unWrappedMovie.image, let image = UIImage(data: imageData) {
                imageView.image = image
            } else {
                imageView.image = UIImage(named: "holder")
            }

            releaseYearLabel.text = String(unWrappedMovie.releaseYear)
            genreLabel.text = unWrappedMovie.genre
        }
        
    }
}
