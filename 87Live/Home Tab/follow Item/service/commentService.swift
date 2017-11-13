//
//  messageService.swift
//  87Live
//
//  Created by 黃恩祐 on 2017/11/11.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct commentService {
    static func create(for post: Post, success: @escaping (Bool) -> Void) {
        // 1
        guard let key = post.key else {
            return success(false)
        }
        
        // 2
        let currentUID = User.current.uid
        
        // 3 code to message a post
        let msgRef = Database.database().reference().child("comments").child(key).child(currentUID)
        msgRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            return success(true)
        }
    }
    
    static func delete(for post: Post, success: @escaping (Bool) -> Void) {
        guard let key = post.key else {
            return success(false)
        }
        
        let currentUID = User.current.uid
        
        let msgRef = Database.database().reference().child("comments").child(key).child(currentUID)
        msgRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            return success(true)
        }
    }
}
