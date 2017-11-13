//
//  StorageService.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/10/15.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import FirebaseStorage

struct StorageService {
    // provide method for uploading images
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // change the image from an UIImage to Data and reduce the quality
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        //upload our media data to the path provided as a parameter to the method
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            //return the download URL for the image is succeed
            completion(metadata?.downloadURL())
        })
    }
}
