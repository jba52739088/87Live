//
//  MessageItemViewController.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/18.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import FirebaseAuth
import SwiftyJSON
import FirebaseDatabase
import FirebaseDatabaseUI

class MessageItemViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "message")
        let child_2 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "me")
        let child_3 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "follow")
        return [child_1, child_2, child_3]
    }
    
    @IBAction func doAdd(_ sender: Any) {
        let alertController = UIAlertController(title: "Email?", message: "Please write the email", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self](_) in
            if let email = alertController.textFields?[0].text {
                self?.addContact(email: email)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addContact(email: String) {
        
        Database.database().reference().child("User").observeSingleEvent(of: .value, with: {  [weak self] (snapshot) in
            
            let snapshot = JSON(snapshot.value as Any).dictionaryValue
            if let index = snapshot.index(where: { (key, value) -> Bool in
                return value["email"].stringValue == email
            }) {
                
                //update both users notes at the same time
                let allUplodes = ["/User/\(Me.uid)/Contacts/\(snapshot[index].key)": (["email": snapshot[index].value["email"].stringValue, "name": snapshot[index].value["name"].stringValue]),
                                  "/User/\(snapshot[index].key)/Contacts/\(Me.uid)": (["email": Auth.auth().currentUser!.email!, "name": Auth.auth().currentUser!.displayName!])]
                Database.database().reference().updateChildValues(allUplodes)
                self?.alert(message: "success")
            } else {
                self?.alert(message: "no such email")
            }
        })
    }
}

