//
//  StrageReference.swift
//  87Live
//
//  Created by 黃恩祐 on 2017/11/10.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        let uid = User.current.uid
        //        let uid = Me.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
