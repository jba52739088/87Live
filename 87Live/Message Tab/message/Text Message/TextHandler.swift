//
//  TextHandler.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/9/21.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class TextHandler: BaseMessageInteractionHandlerProtocol {
    
    
    func userDidTapOnFailIcon(viewModel: ViewModel, failIconView: UIView) {
        print("tap on fail")
    }
    
    func userDidTapOnAvatar(viewModel: ViewModel) {
        print("tap on avatar")
    }
    
    func userDidTapOnBubble(viewModel: ViewModel) {
        print("tap on bubble")
    }
    
    
    func userDidBeginLongPressOnBubble(viewModel: ViewModel) {
        print("being long press")
    }
    
    
    func userDidEndLongPressOnBubble(viewModel: ViewModel) {
        print("end long press")
    }
    
    
}
