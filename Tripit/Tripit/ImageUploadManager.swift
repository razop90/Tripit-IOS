//
//  ImageUploadManager.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class ImageUploadManager: NSObject {
    
    func UploadImage(_ image:UIImage, progressBlock: @escaping (_ presentage: Double) -> Void, _ completionBlock:@escaping (_ url:URL?, _ errorMessage:String?)->Void){
        let storage = Storage.storage() //The birebase storage object
        let storageReference = storage.reference() //The firebase storage reference
        
        //Storage/postsImages/{customID}/image.jpg
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imageReference = storageReference.child(Consts.Posts.ImagesFolderName).child(imageName)
        
        //Starting the upload - trying to convert the image into Data by 0.8% quality
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg" //Letting firebase to know the we want to uplad an image
            //Uploading the image Data
            let uploadTask = imageReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if metadata != nil {
                    imageReference.downloadURL{ url, error in
                        //Returning the URL and reurn errors if exist
                        completionBlock(url, error?.localizedDescription)
                    }
                }else{
                    //No URL was found
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            //Getting the upload progress Data of the image
            uploadTask.observe(.progress, handler: { (snapshot) in
                //Checking if there is a progress in order to update the progress
                guard let progress = snapshot.progress else {
                    return
                }
                
                let precentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(precentage)
            })
        }else{
            completionBlock(nil, "Image couldn't be converted to Data.")
        }
        
    }

}
