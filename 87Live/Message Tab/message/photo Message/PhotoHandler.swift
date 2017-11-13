//
//  PhotoHandler.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/9/21.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class PhotoHandler: BaseMessageInteractionHandlerProtocol {
    
    
    func userDidTapOnFailIcon(viewModel: photoViewModel, failIconView: UIView) {
        print("tap on fail")
    }
    
    func userDidTapOnAvatar(viewModel: photoViewModel) {
        print("tap on avatar")
    }
    
    func userDidTapOnBubble(viewModel: photoViewModel) {
        print("tap on bubble")
        print(viewModel.imageSize)
    }
    
    
    func userDidBeginLongPressOnBubble(viewModel: photoViewModel) {
        print("being long press")
    }
    
    
    func userDidEndLongPressOnBubble(viewModel: photoViewModel) {
        print("end long press")
    }
    
    
}
