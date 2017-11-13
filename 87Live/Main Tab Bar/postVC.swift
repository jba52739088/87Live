//
//  postvc.swift
//  87Live
//
//  Created by 黃恩祐 on 2017/11/10.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class postVC: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var pushBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.mainView.layer.cornerRadius = 10
        self.pushBtn.layer.cornerRadius = 10
        self.pushBtn.setTitle("Send", for: .normal)
        self.cancelBtn.layer.cornerRadius = 10
        self.cancelBtn.setTitle("Cancel", for: .normal)
        
        self.imageView.image = appDelegate.postImage
        self.textField.text = ""
        textField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PullVideoTableViewCell.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
//        textField.endEditing(true)
    }
    
    @IBAction func sendBtn(_ sender: Any) {
//        PostService.create(for: imageView.image!)
        PostService.create(for: imageView.image!, userMessage: textField.text!)
        removeAnimate()
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        removeAnimate()
    }
    
    func showAnimate() {
        self.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1.0
            self.view.frame.origin.y = self.view.frame.origin.y - self.view.frame.height
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        })
    }
    
    ///////////////
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveTextView(textView, moveDistance: -250, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        moveTextView(textView, moveDistance: -250, up: false)
    }
    
    func moveTextView(_ textView: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }
    
}
