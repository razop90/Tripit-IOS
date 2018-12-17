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
    @IBOutlet weak var Progress: UIProgressView!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var DescriptionText: UITextField!
    @IBOutlet weak var ImageTapIndicationLabel: UILabel!
    
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

    func UploadPost() {
        if LocationText.text?.isEmpty ?? true || DescriptionText.text?.isEmpty ?? true {
            self.present(Consts.General.getCancelAlertController(title: "New Post", messgae: "Please write something"), animated: true, completion: nil)
            return
        }
        
        if let image = imageView.image {
        self.BuisyIndicator.isHidden = false
        self.BuisyIndicator.startAnimating()
        //self.Progress.isHidden = false
        self.view.isUserInteractionEnabled = false

        let postId:String = "\(Date().timeIntervalSince1970)" //Temp id for the post
        let post = Post(_userID: "1234", _id: postId, _location: LocationText.text!, _description: DescriptionText.text!)
            Model.instance.addNewPost(post, image, progressBlock: { (precentage) in
                //self.Progress.progress = Float(precentage) / 100
                print(precentage) //Printing the upload precentage
            }, { (fileURL, errorMessage) in
                self.BuisyIndicator.isHidden = true
                self.BuisyIndicator.stopAnimating()
                //self.Progress.isHidden = true
                self.view.isUserInteractionEnabled = true
                
                self.dismiss(animated: true, completion: nil)
            })
        } else {
             self.present(Consts.General.getCancelAlertController(title: "New Post", messgae: "Please select an image"), animated: true, completion: nil)
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
            ImageTapIndicationLabel.isHidden = true
        } else {
            imageView.image = nil
            ImageTapIndicationLabel.isHidden = false
        }
         self.dismiss(animated: true, completion: nil)
    }
}
