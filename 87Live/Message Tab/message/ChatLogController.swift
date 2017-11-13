//
//  ViewController.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/9/19.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseUI
import SwiftyJSON
import FirebaseStorage
import Kingfisher
import MapKit
import CoreLocation


class ChatLogController: BaseChatViewController, FUICollectionDelegate {
    
    var presenter: BasicChatInputBarPresenter!
    var dataSource: DataSource!
    var decorator = Decorator()
    var userUID = String()
    var MessagesArray: FUIArray!

    
    
    //建立訊息輸入區&其他功能鍵
    override func createChatInputView() -> UIView {
        let inputbar = ChatInputBar.loadNib()           //加入打訊息內容區
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = "Send"
        appearance.textInputAppearance.placeholderText = "Type a message"
        self.presenter = BasicChatInputBarPresenter(chatInputBar: inputbar, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        return inputbar
    }
    
    //要加入inputbar的物件
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(handleSend())
        items.append(handlePhoto())
        return items
    }
    
    
    
    
    func handleSend() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            
            let date = Date()
            let double = date.timeIntervalSinceReferenceDate
            let senderId = Me.uid
            let messageUID = ("\(double)" + senderId).replacingOccurrences(of: ".", with: "")
            
            let message = MessageModel(uid: messageUID, senderId: senderId, type: TextModel.chatItemType, isIncoming: false, date: Date(), status: .success)
            let textMessage = TextModel(messageModel: message, text: text)
            self?.dataSource.addMessage(message: textMessage)
            self?.sendOnlineTextMessage(text: text, uid: messageUID, double: double, senderId: senderId)
        }
        
        return item
    }
    
    func handlePhoto() -> PhotosChatInputItem {
        
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] photo in
            
            let date = Date()
            let double2 = date.timeIntervalSinceReferenceDate
            let senderID = Me.uid
            let messageUID = ("\(double2)" + senderID).replacingOccurrences(of: ".", with: "")
            
            let message = MessageModel(uid: messageUID, senderId: senderID, type: PhotoModel.chatItemType, isIncoming: false, date: Date(), status: .sending)
            let photoMessage = PhotoModel(messageModel: message, imageSize: photo.size, image: photo)
            self?.dataSource.addMessage(message: photoMessage)
            self?.uploadToStorage(photo: photoMessage)
        }
        return item
    }
    
    
    
    //聊天內容區
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        
        let textMessageBuilder =
            TextMessagePresenterBuilder(viewModelBuilder: TextBuilder(), interactionHandler: TextHandler())
        let photoPresenterBuilder =
            PhotoMessagePresenterBuilder(viewModelBuilder: PhotoBuilder(), interactionHandler: PhotoHandler())
        
        //傳送者圖像
        textMessageBuilder.baseMessageStyle = avatar()
        photoPresenterBuilder.baseCellStyle = avatar()
        
        return [TextModel.chatItemType : [textMessageBuilder],
                PhotoModel.chatItemType: [photoPresenterBuilder],
                TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()],
                SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
                ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatDataSource = self.dataSource
        self.chatItemsDecorator = self.decorator
        self.constants.preferredMaxMessageCount = 300
        self.MessagesArray.observeQuery()
        self.MessagesArray.delegate = self
        self.navigationItem.title = "let's chat"
    }
    
    
    func sendOnlineTextMessage(text: String, uid: String, double: Double, senderId: String){
        
        let message = ["text": text, "uid": uid, "date": double, "senderID": senderId, "status": "success", "type": TextModel.chatItemType] as [String : Any]
        
        //put least user data to database
        let childUpdates = ["User-messages/\(senderId)/\(self.userUID)/\(uid)": message,
                            "User-messages/\(self.userUID)/\(senderId)/\(uid)": message,
                            "User/\(Me.uid)/Contacts/\(self.userUID)/lastMessage":message,
                            "User/\(self.userUID)/Contacts/\(Me.uid)/lastMessage":message
        ]
        Database.database().reference().updateChildValues(childUpdates) { [weak self] (error, _) in
            
            if error != nil {
                self?.dataSource.updateTextMessage(uid: uid, status: .failed)
                return
            }
            self?.dataSource.updateTextMessage(uid: uid, status: .success)
        }
    }
    
    ////for test memory weak
    deinit {
        print("deinit")
    }
    
    func uploadToStorage(photo: PhotoModel) {
        let imageName = photo.uid
        let storage = Storage.storage().reference().child("images").child(imageName)
        let data = UIImagePNGRepresentation(photo.image)
        storage.putData(data!, metadata: nil) { [weak self](metadata, error) in
            
            if let imageURL = metadata?.downloadURL()?.absoluteString {
                //update to firebase
                self?.sendOnlineImageMessage(photoMessage: photo, imageURL: imageURL)
            }else{
                //update as failed...
                self?.dataSource.updatePhotoMessage(uid: photo.uid, status: .failed)
            }
        }
    }
    
    func sendOnlineImageMessage(photoMessage: PhotoModel, imageURL: String){
        
        let message = ["image": imageURL, "uid": photoMessage.uid, "date": photoMessage.date.timeIntervalSinceReferenceDate, "senderID": photoMessage.senderId, "status": "success", "type": PhotoModel.chatItemType] as [String : Any]
        //put least user data to database
        let childUpdates = ["User-messages/\(photoMessage.senderId)/\(self.userUID)/\(photoMessage.uid)": message,
                            "User-messages/\(self.userUID)/\(photoMessage.senderId)/\(photoMessage.uid)": message,
                            "User/\(Me.uid)/Contacts/\(self.userUID)/lastMessage":message,
                            "User/\(self.userUID)/Contacts/\(Me.uid)/lastMessage":message
        ]
        Database.database().reference().updateChildValues(childUpdates) { [weak self] (error, _) in
            
            if error != nil {
                self?.dataSource.updatePhotoMessage(uid: photoMessage.uid, status: .failed)
                return
            }
            self?.dataSource.updatePhotoMessage(uid: photoMessage.uid, status: .success)
        }
        
    }
    
    
    
    
}


extension ChatLogController {
    
    func array(_ array: FUICollection, didAdd object: Any, at index: UInt) {
        let message = JSON((object as! DataSnapshot).value as Any)
        let senderId = message["senderID"].stringValue
        let type = message["type"].stringValue
        let contains = self.dataSource.controller.items.contains { (collectionViewMessage) -> Bool in
            return collectionViewMessage.uid == message["uid"].stringValue
        }
        if contains == false{
            let model = MessageModel(uid: message["uid"].stringValue, senderId: senderId, type: type, isIncoming: senderId == Me.uid ? false : true, date: Date(timeIntervalSinceReferenceDate: message["date"].doubleValue), status: message["status"] == "success" ? MessageStatus.success : MessageStatus.sending)
            
            
            if type == TextModel.chatItemType {
                let textMessage = TextModel(messageModel: model, text: message["text"].stringValue)
                self.dataSource.addMessage(message: textMessage)
            }else if type == PhotoModel.chatItemType {
                KingfisherManager.shared.retrieveImage(with: URL(string: message["image"].stringValue)!, options: nil, progressBlock: nil, completionHandler: { [weak self ](image, error, _, _) in
                    if error != nil{
                        self?.alert(message: "error receiving image from friend")
                    }else{
                        let photoMessage = PhotoModel(messageModel: model, imageSize: image!.size, image: image!)
                        self?.dataSource.addMessage(message: photoMessage)
                    }
                })
            }
        }
    }
}

