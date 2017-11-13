//
//  Decorator.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/9/20.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class Decorator: ChatItemsDecoratorProtocol {
    
    func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
        
        var decoratedItems = [DecoratedChatItem]()
        let calender = Calendar.current  //48
        for (index, item) in chatItems.enumerated() {
            var addTimestamp = false    //48
            var showsTail = false
            let nextMessage: ChatItemProtocol? = (index + 1 < chatItems.count) ? chatItems[index + 1] : nil
            let previousMessage: ChatItemProtocol? = (index > 0) ? chatItems[index - 1] : nil  //48
            // 48
            if let previousMessage = previousMessage as? MessageModelProtocol {
                
                addTimestamp = !calender.isDate((item as! MessageModelProtocol).date, inSameDayAs: previousMessage.date)
            }else{
                addTimestamp = true
            }
            
            
            // if it's the last message -> show tail
            if let nextMessage = nextMessage as? MessageModelProtocol {
                showsTail = (item as! MessageModelProtocol).senderId != nextMessage.senderId
            }else{
                showsTail = true
            }
            
            if addTimestamp == true {
                let timeSepatorModel = TimeSeparatorModel(uid: UUID().uuidString, date: (item as! MessageModelProtocol).date.toWeekDayAndDateString())
                decoratedItems.append(DecoratedChatItem(chatItem: timeSepatorModel, decorationAttributes: nil))
            }
            
            
            let bottomMargin = separationAfterItem(current: item, next: nextMessage)
            let decoratedItem = DecoratedChatItem(chatItem: item, decorationAttributes: ChatItemDecorationAttributes(bottomMargin: bottomMargin, canShowTail: showsTail, canShowAvatar: false, canShowFailedIcon: true))
            //showsTail: chat bubble's style
            
            decoratedItems.append(decoratedItem)
            
            if let status = (item as? MessageModelProtocol)?.status, status != .success {
                let statusModel = SendingStatusModel(uid: UUID().uuidString, status: status)
                decoratedItems.append(DecoratedChatItem(chatItem: statusModel, decorationAttributes: nil))
            }
         }
        
        return decoratedItems
        
    }
    
    
    //if current message and next one are same user's , bottomMargin is 3, otherwise is 10
    func separationAfterItem(current: ChatItemProtocol?, next: ChatItemProtocol?) -> CGFloat {
        guard let next = next else{return 0}
        
        let currentMessage = current as? MessageModelProtocol
        let nextMessage = next as? MessageModelProtocol
        
        if let status = currentMessage?.status, status != .success {
            return 10
        }
        else if currentMessage?.senderId != nextMessage?.senderId {
            return 10
        }else{
            return 3
        }
    }
    
    
}
