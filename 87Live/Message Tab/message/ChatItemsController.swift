//
//  ChatItemsController.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/9/20.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions
import FirebaseDatabase
import SwiftyJSON

class ChatItemsController:NSObject {

    var items = [ChatItemProtocol]()
    var initialMessages = [ChatItemProtocol]()
    var loadMore = false
    var userUID: String!
    typealias completeLoading = () -> Void
    
    func loadIntoItemsArray(messagedNeeded: Int, moreToLoad: Bool) {
        
        for index in stride(from: initialMessages.count - items.count, to: initialMessages.count - items.count - messagedNeeded, by: -1){
            self.items.insert(initialMessages[index - 1], at: 0)
            self.loadMore = moreToLoad
        }
    }
    
    func inserItem(message: ChatItemProtocol) {
        self.items.append(message)
//        self.initialMessages.append(message)
    }
    
    func loadPrevious(Completion: @escaping completeLoading) {
//        self.loadIntoItemsArray(messagedNeeded: min(initialMessages.count - items.count, 50))
        Database.database().reference().child("User-messages").child(Me.uid).child(userUID).queryEnding(atValue: nil, childKey: self.items.first!.uid).queryLimited(toLast: 51).observeSingleEvent(of: .value, with: { [weak self](snapshot) in

            var messages = Array(JSON(snapshot.value as Any).dictionaryValue.values).sorted(by: { (lhs, rhs) -> Bool in
                return lhs["date"].doubleValue < rhs["date"].doubleValue
            })
            
            messages.removeLast()
            self?.loadMore = messages.count > 50
            let converted = self!.convertToChatItemProtocol(messages: messages)
            for index in stride(from: converted.count, to: converted.count - min(messages.count, 50), by: -1) {
                self?.items.insert(converted[index - 1], at: 0)
            }
            Completion()
            //45
            messages.filter({ (message) -> Bool in
                return message["type"].stringValue == PhotoModel.chatItemType
            }).forEach({ (message) in
                self?.parseURLs(UID_URL: (key: message["uid"].stringValue, value: message["image"].stringValue))
            })
        })
    }
    
    func adjustWindow(){
        self.items.removeFirst(200)
        self.loadMore = true
    }
}
