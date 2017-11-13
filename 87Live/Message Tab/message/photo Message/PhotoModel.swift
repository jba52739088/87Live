//
//  PhotoModel.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/9/21.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class PhotoModel: PhotoMessageModel<MessageModel> {
    
    static let chatItemType = "photo"
    
    override init(messageModel: MessageModel, imageSize: CGSize, image: UIImage) {
        
        super.init(messageModel: messageModel, imageSize: imageSize, image: image)
        print("==========PhotoModel===============")
    }
    
    
    var status: MessageStatus {
        get {
            return self._messageModel.status
        } set{
            self._messageModel.status = newValue
        }
    }
}
