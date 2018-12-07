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

    override func viewDidLoad() {
        super.viewDidLoad()

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(AddPostController.tapDetected))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
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
    
    private func TryUploadImage(_ image:UIImage) {
        //Creating an instance of the uploadManager and uploading the picture
        let imageUploadManager = ImageUploadManager()
        imageUploadManager.UploadImage(image, progressBlock: { (precentage) in
            print(precentage) //Printing the upload precentage
        }, { (fileURL, errorMessage) in
            print(fileURL ?? "no URL was found")
            print(errorMessage ?? "no error exist")
            
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
