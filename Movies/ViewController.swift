//
//  ViewController.swift
//  Movies
//
//  Created by Mina Emad on 01/05/2024.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var inTitle: UITextField!
    
    @IBOutlet weak var inYear: UITextField!
    
    @IBOutlet weak var inGenre: UITextField!
    
    @IBOutlet weak var inRating: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var detailsProtocol :DetailsProtocol!

    
    @IBAction func btnImage(_ sender: Any) {
        let imgPicker : UIImagePickerController = UIImagePickerController()
        imgPicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }else{
            print("Can't pick image")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = img
        self.dismiss(animated: true)
    }
    
  
    @IBAction func btnAdd(_ sender: Any) {
        print("Button Add Clicked")
        guard let title = inTitle.text,
              let genre = inGenre.text,
              let releaseYearText = inYear.text,
              let intYear = Int(releaseYearText),
              let ratingText = inRating.text,
              let rating = Double(ratingText)
        else {
            return
        }
        
        guard let image = imageView.image else {
            print("no image")
              return
          }
  guard let imageData = image.jpegData(compressionQuality: 1.0) else {
      print("not jpegData image")
              return
          }
        
        let movie = Movie(title: title, image: imageData, releaseYear: intYear, genre: genre, rating: rating)
        DataBaseManager.dataBase.insert(title: title, image: imageData, genre: genre, rating: rating, releaseDate: intYear)

        detailsProtocol?.addMovie(movie: movie)
        showAlert()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func showAlert() {
        let alertController = UIAlertController(title: "Added!", message: "Movie has been added successfully to your watch list", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alertController, animated: true, completion: nil)
    }

}

