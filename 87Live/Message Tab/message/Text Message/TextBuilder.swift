//
//  TextBuilder.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/9/20.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions


class ViewModel: TextMessageViewModel<TextModel> {
    
    override init(textMessage: TextModel, messageViewModel: MessageViewModelProtocol) {
        super.init(textMessage: textMessage, messageViewModel: messageViewModel)
    }
}

class TextBuilder: ViewModelBuilderProtocol{

    let defaultBuilder = MessageViewModelDefaultBuilder()

    
    func canCreateViewModel(fromModel decoratedTextMessage: Any) -> Bool {
        
        return decoratedTextMessage is TextModel
    }
    
    func createViewModel(_ decoratedTextMessage:TextModel) -> ViewModel {
        
        let textmessageViewModel = ViewModel(textMessage: decoratedTextMessage, messageViewModel: defaultBuilder.createMessageViewModel(decoratedTextMessage))
            textmessageViewModel.avatarImage.value = #imageLiteral(resourceName: "avatar")
        return textmessageViewModel
    }
    
}
