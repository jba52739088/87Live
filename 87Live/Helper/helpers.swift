//
//  helpers.swift
//  87Live
//
//  Created by 黃恩祐 on 2017/11/10.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import UIKit
import Chatto
import ChattoAdditions
import SwiftyJSON
import Kingfisher

extension UIViewController {
    
    
//    @objc func showingKeyboard(notification: Notification){
//
//        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height{
//
//            self.view.frame.origin.y = -keyboardHeight
//        }
//    }
//
//    @objc func hidingKeyboard(){
//
//        self.view.frame.origin.y = 0
//
//    }
    
    func alert(message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension NSObject {

    func convertToChatItemProtocol(messages: [JSON]) -> [ChatItemProtocol] {
        var convertedMessages = [ChatItemProtocol]()

        convertedMessages = messages.map({ (message) -> ChatItemProtocol in         //45
            let senderId = message["senderID"].stringValue
            let model = MessageModel(uid: message["uid"].stringValue, senderId: senderId, type: message["type"].stringValue, isIncoming: senderId == Me.uid ? false : true, date: Date(timeIntervalSinceReferenceDate: message["date"].doubleValue), status: message["status"] == "success" ? MessageStatus.success : MessageStatus.sending)
            if message["type"].stringValue == TextModel.chatItemType {
                let textMessage = TextModel(messageModel: model, text: message["text"].stringValue)
                return textMessage
            } else {
                let loading = #imageLiteral(resourceName: "loading")
                let photoMessage = PhotoModel(messageModel: model, imageSize: loading.size, image: loading)
                return photoMessage
            }
        })


        return convertedMessages
    }

    func parseURLs(UID_URL: (key: String, value: String)) {

        let uid = UID_URL.key
        let imageURL = UID_URL.value
        KingfisherManager.shared.retrieveImage(with: URL(string: imageURL)!, options: nil, progressBlock: nil) { (image, error, _, _) in
            if let image = image {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateImage"), object: nil, userInfo: ["image": image, "uid": uid])
            }
        }

    }

    
    
}

