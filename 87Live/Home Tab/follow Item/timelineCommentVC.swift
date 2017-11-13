//
//  timelineCommentVC.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/25.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class timelineCommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pushBtn: UIButton!
    
    var tag = fakeUser.timelineTag
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Follow", style: UIBarButtonItemStyle.plain, target: self, action: #selector(timelineCommentVC.goBack))
        navigationItem.leftBarButtonItem = backButton
        self.pushBtn.setTitle("Send", for: .normal)
        textField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PullVideoTableViewCell.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        textField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataDic = fakeTimeLine.fakeUser2Dic as NSDictionary
        let timeline = dataDic["userTimeLine"] as! NSArray
        let messages = timeline[4 - tag] as! NSDictionary
        let commentArray = messages["comments"] as! NSArray
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataDic = fakeTimeLine.fakeUser2Dic as NSDictionary
        let timeline = dataDic["userTimeLine"] as! NSArray
        let messages = timeline[4 - tag] as! NSDictionary
        let commentArray = messages["comments"] as! NSArray
        let comments = commentArray[indexPath.row] as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! timelineCommentCell
        cell.commenterPhoto.image = UIImage(named:"\((comments["commenter"])!)")
        cell.commenterName.text = "\((comments["commenter"])!)"
        cell.commentTimeLabel.text = "\((comments["time"])!)"
        cell.commentLabel.text = "\((comments["messages"])!)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func doComment(_ sender: Any) {
        // post comment
        
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    /////////////////////////////////
    // Start Editing The Text Field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.textField.frame = self.textField.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }
    ////////////////////////////
}
