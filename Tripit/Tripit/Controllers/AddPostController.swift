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
    private var isEditMode:Bool = false
    private var postToEdit:Post? = nil
    private var isImageSelected:Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var BuisyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var DescriptionText: UITextField!
    @IBOutlet weak var ImageTapIndicationLabel: UILabel!
    @IBOutlet var postButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var controller: UINavigationItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(AddPostController.tapDetected))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        
        if(isEditMode) {
            if(postToEdit != nil) {
                initializeEditMode()
            }
            else {
                 present(Consts.General.getCancelAlertController(title: "Edit Post", messgae: "Error while openning edit view"), animated: true)
                 self.dismiss(animated: true, completion: nil)
            }
        }
        else {
            BuisyIndicator.isHidden = true

            deleteButton?.isEnabled = false
            deleteButton?.tintColor = UIColor.clear
        }
    }
    
    private func initializeEditMode() {
        postButton.title = "Save"
        backButton.title = "Back"
        controller.title = "Edit Post"
        
        self.BuisyIndicator.isHidden = false
        self.BuisyIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        LocationText.text = postToEdit!.location
        DescriptionText.text = postToEdit!.description
        
        if postToEdit!.imageUrl != "" {
            Model.instance.getImage(url: postToEdit!.imageUrl!) { (image:UIImage?) in
                if image != nil {
                    self.imageView.image = image
                    self.ImageTapIndicationLabel.isHidden = true
                    
                    self.BuisyIndicator.isHidden = true
                    self.BuisyIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func enterEditMode(post:Post) {
        isEditMode = true
        postToEdit = post
    }
    
    @objc func tapDetected(){
        showImagePicker()
    }
    
    @IBAction func OnCancelSubmit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnPostSubmit(_ sender: Any) {
        if LocationText.text?.isEmpty ?? true || DescriptionText.text?.isEmpty ?? true {
            self.present(Consts.General.getCancelAlertController(title: "Post", messgae: "Please write something"), animated: true, completion: nil)
            return
        }
        
        if let image = imageView.image {
            self.BuisyIndicator.isHidden = false
            self.BuisyIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            let userId = Model.instance.currentUser()?.uid
            
            if userId != nil {
                if(isEditMode) {
                    EditPost(image)
                } else {
                    UploadPost(userId!, image)
                }
            } else {
                self.present(Consts.General.getCancelAlertController(title: "Post - ERROR", messgae: "Current user wasn't found"), animated: true, completion: nil)
            }
        }
        else {
            self.present(Consts.General.getCancelAlertController(title: "Post", messgae: "Please select an image"), animated: true, completion: nil)
        }
    }
    
    func EditPost(_ image:UIImage) {
        postToEdit!.location = LocationText!.text!
        postToEdit!.description = DescriptionText!.text!
        
        Model.instance.updatePost(postToEdit!, image, isImageSelected, { (url) in
            self.BuisyIndicator.isHidden = true
            self.BuisyIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func UploadPost(_ userId:String, _ image:UIImage) {
        let postId:String = "" //Temp id for the post
        let post = Post(_userID: userId, _id: postId, _location: LocationText.text!, _description: DescriptionText.text!)
        Model.instance.updatePost(post, image, true, { (url) in
            self.BuisyIndicator.isHidden = true
            self.BuisyIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
                
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func onDeletePostSubmit(_ sender: Any) {
        //Create the alert controller and actions
        let alert = UIAlertController(title: "Delete Post", message: "Are you sure?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                if(self.postToEdit != nil) {
                    Model.instance.setPostAsDeleted(self.postToEdit!.id)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.present(Consts.General.getCancelAlertController(title: "Delete Post", messgae: "Error while trying to deleted post"), animated: true)
                }
            }
        }
        
        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        //Present the alert controller
        present(alert, animated: true, completion: nil)
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
        
        isImageSelected = true
        self.dismiss(animated: true, completion: nil)
    }
}
