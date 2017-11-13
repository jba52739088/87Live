//
//  MessagesTableViewController.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/9/28.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyJSON
import FirebaseDatabase
import FirebaseDatabaseUI
import Chatto
import XLPagerTabStrip

class MessagesTableViewController: UIViewController, FUICollectionDelegate, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "Message")
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let Contects = FUISortedArray(query: Database.database().reference().child("User").child(Me.uid).child("Contacts"), delegate: nil){ (lhs, rhs) -> ComparisonResult in
        let lhs = Date(timeIntervalSinceReferenceDate: JSON(lhs.value as Any)["lastMessage"]["date"].doubleValue)
        let rhs = Date(timeIntervalSinceReferenceDate: JSON(rhs.value as Any)["lastMessage"]["date"].doubleValue)
        
        return rhs.compare(lhs)     
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Contects.observeQuery()
        self.Contects.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        Database.database().reference().child("User-messages").child(Me.uid).keepSynced(true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

}

extension MessagesTableViewController {
    
    func array(_ array: FUICollection, didAdd object: Any, at index: UInt) {
        tableView.insertRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    }
    func array(_ array: FUICollection, didMove object: Any, from fromIndex: UInt, to toIndex: UInt) {
        tableView.insertRows(at: [IndexPath(row: Int(toIndex), section: 0)], with: .automatic)
        tableView.deleteRows(at: [IndexPath(row: Int(fromIndex), section: 0)], with: .automatic)
    }
    func array(_ array: FUICollection, didRemove object: Any, at index: UInt) {
        tableView.deleteRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    }
    func array(_ array: FUICollection, didChange object: Any, at index: UInt) {
        tableView.reloadRows(at: [IndexPath(row: Int(index), section: 0)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.Contects.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessagesTableViewCell
        let info = JSON((Contects[(UInt(indexPath.row))] as? DataSnapshot)?.value as Any).dictionaryValue
        cell.Name.text = info["name"]?.stringValue
        cell.lastMessage.text = info["lastMessage"]?["text"].string
        cell.lastMessageDate.text = dateFormatter(timestamp: info["lastMessage"]?["date"].double)
        return cell
    }
    //34
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let uid = (Contects[UInt(indexPath.row)] as? DataSnapshot)!.key
        let reference = Database.database().reference().child("User-messages").child(Me.uid).child(uid).queryLimited(toLast: 51) //36
        self.tableView.isUserInteractionEnabled = false
        
        //36
        reference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            var messages = Array(JSON(snapshot.value as Any).dictionaryValue.values).sorted(by: { (lhs, rhs) -> Bool in
                return lhs["date"].doubleValue < rhs["date"].doubleValue
            })
            let converted = self!.convertToChatItemProtocol(messages: messages)
            let chatlog = ChatLogController()
            chatlog.userUID = uid
            chatlog.dataSource = DataSource(initialMessages: converted, uid: uid)
            chatlog.MessagesArray = FUIArray(query: Database.database().reference().child("User-messages").child(Me.uid).child(uid).queryStarting(atValue: nil, childKey: converted.last?.uid), delegate: nil)
            self?.navigationController?.show(chatlog, sender: nil)
            self?.tableView.deselectRow(at: indexPath, animated: true)
            self?.tableView.isUserInteractionEnabled = true
            //45
            messages.filter({ (message) -> Bool in
                return message["type"].stringValue == PhotoModel.chatItemType
            }).forEach({ (message) in
                self?.parseURLs(UID_URL: (key: message["uid"].stringValue, value: message["image"].stringValue))
            })
        })
        
    }
    
    //date Format
    func dateFormatter(timestamp: Double?) -> String? {
        
        if let timestamp = timestamp {
            let date = Date(timeIntervalSinceReferenceDate: timestamp)
            let dateFormatter = DateFormatter()
            let timeSinceDateInSeconds = Date().timeIntervalSince(date)
            let secondInDay: TimeInterval = 24*60*60
            if timeSinceDateInSeconds > 7 * secondInDay {
                dateFormatter.dateFormat = "MM/dd/yy"
            }else if timeSinceDateInSeconds > secondInDay {
                dateFormatter.dateFormat = "EEE"
            }else {
                dateFormatter.dateFormat = "h:mm a"
            }
            return dateFormatter.string(from: date)
        } else {
            return nil
            
        }
    }
}
