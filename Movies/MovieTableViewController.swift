//
//  MovieTableViewController.swift
//  Movies
//
//  Created by Mina Emad on 01/05/2024.
//

import UIKit
//import SDWebImage


class MovieTableViewController: UITableViewController,DetailsProtocol {
    
    var movieList : [Movie] = []

    
    @IBOutlet var movieTableView: UITableView!
    
    @IBAction func btnPlus(_  sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            viewController.detailsProtocol = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieList = DataBaseManager.dataBase.query()
        for record in movieList {
            print("Title: \(record.title)")
        }
        view.setNeedsDisplay()
        movieTableView.reloadData()
    }
    
    func addMovie(movie: Movie) {
        movieList.append(movie)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = movieList[indexPath.row]
        cell.textLabel?.text = movie.title
        if let imageData = movie.image, let image = UIImage(data: imageData) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(named: "holder") // Placeholder image if no image data is available
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showAlert(title: "Are You Sure?", message: "Do you want delete this Movie?", indexPath: indexPath)
        }
    }


    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            movieDetailViewController.movie = movieList[indexPath.row]
            movieDetailViewController.cosmosView.rating = movieList[indexPath.row].rating
            present(movieDetailViewController, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String, indexPath: IndexPath) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            DataBaseManager.dataBase.delete(title: self.movieList[indexPath.row].title)
            self.movieList.remove(at: indexPath.row)
            self.movieTableView.deleteRows(at: [indexPath], with: .fade)
        }))
        present(alertController, animated: true, completion: nil)
    }
}
