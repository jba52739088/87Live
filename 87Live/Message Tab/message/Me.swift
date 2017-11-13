//
//  Me.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/10/1.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import FirebaseAuth

class Me {
    
    static var uid: String{
        return Auth.auth().currentUser!.uid
    }
    
}
