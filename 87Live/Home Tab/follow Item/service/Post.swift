//
//  Post.swift
//  87Live
//
//  Created by 黃恩祐 on 2017/11/10.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Post {
    var key: String?
    
    // for upload image
    let imageURL: String
    let imageHeight: CGFloat
    let creationDate: Date
    
    // for message
    var userMessage: String
    
    // for "like"
    var likeCount: Int
    let poster: User
    var isLiked = false
    

    
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        let userDict = ["uid" : poster.uid,
                        "name" : poster.username]
        
        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo,
                "like_count" : likeCount,
                "poster" : userDict,
                "userMessage" : userMessage]
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            // for upload image
            let imageURL = dict["image_url"] as? String,
            let imageHeight = dict["image_height"] as? CGFloat,
            let createdAgo = dict["created_at"] as? TimeInterval,
            
            // for "like"
            let likeCount = dict["like_count"] as? Int,
            let userDict = dict["poster"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["name"] as? String,
            /////
            let userMessage = dict["userMessage"] as? String
            /////
            else { return nil }
        
        
        self.key = snapshot.key
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        
        self.likeCount = likeCount
        self.poster = User(uid: uid, username: username)
        /////
        self.userMessage = userMessage
        /////
        
    }
    
    init(imageURL: String, imageHeight: CGFloat, userMessage: String) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        
        self.likeCount = 0
        self.poster = User.current
        
        /////
        self.userMessage = userMessage
        /////
    }
    
    
}

