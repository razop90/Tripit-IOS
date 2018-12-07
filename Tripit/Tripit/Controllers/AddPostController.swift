//
//  AddPostController.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import UIKit

class AddPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var BuisyIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(AddPostController.tapDetected))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        
        BuisyIndicator.isHidden = true
        //Progress.isHidden = true
    }
    
    @objc func tapDetected(){
        showImagePicker()
    }
    
    @IBAction func OnCancelSubmit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnPostSubmit(_ sender: Any) {
        UploadPost()
    }
    
    @IBOutlet weak var Progress: UIProgressView!
    
    private func TryUploadImage(_ image:UIImage) {
        BuisyIndicator.startAnimating()
        BuisyIndicator.isHidden = false
        //Progress.isHidden = false
        view.isUserInteractionEnabled = false
        
        //Creating an instance of the uploadManager and uploading the picture
        let imageUploadManager = ImageUploadManager()
        //var imageUrl: URL? = nil
        imageUploadManager.UploadImage(image, progressBlock: { (precentage) in
            //self.Progress.progress = Float(precentage) / 100
            print(precentage) //Printing the upload precentage
        }, { (fileURL, errorMessage) in
            //imageUrl = fileURL
            
            print(fileURL ?? "no URL was found")
            print(errorMessage ?? "no error exist")
            
            self.BuisyIndicator.isHidden = true
            self.BuisyIndicator.stopAnimating()
            //self.Progress.isHidden = true
            self.view.isUserInteractionEnabled = true
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func UploadPost() {
        if let image = imageView.image {
            TryUploadImage(image)
            
            
        }
    }
    
    @objc private func showImagePicker(){
        //Creating an instance of the image picker controller and using it
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Cloasing the picker in case of a cancelation request from the user
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //picker.dismiss(animated: false, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    //If the user picked an image, wer'e grabbing the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        } else {
            imageView.image = nil
        }
         self.dismiss(animated: true, completion: nil)
    }
}
