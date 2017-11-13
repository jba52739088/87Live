//
//  TextModel.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/9/20.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class TextModel: TextMessageModel<MessageModel> {
    
    
    static let chatItemType = "text"
    
    override init(messageModel: MessageModel, text: String) {
        
        super.init(messageModel: messageModel, text: text)
    }
    
    var status: MessageStatus {
        
        get {
            return self._messageModel.status
        } set{
            self._messageModel.status = newValue
        }
    }
    
    
}
