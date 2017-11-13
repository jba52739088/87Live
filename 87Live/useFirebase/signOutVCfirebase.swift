//
//  signOutVC.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/26.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class signOutVCfirebase: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var singUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.email.delegate = self
        self.fullname.delegate = self
        self.password.delegate = self
        
        let backButton = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.email.endEditing(true)
        self.password.endEditing(true)
        self.fullname.endEditing(true)
    }
    
    @IBAction func doSignUp(_ sender: Any) {
        
        guard let email = email.text, let password = password.text, let fullname = fullname.text
            else{return}
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self](user, error) in
            if let error = error{
                self?.alert(message: error.localizedDescription)
                return
            }
            
            Database.database().reference().child("User").child(user!.uid).updateChildValues(["email": email, "name": fullname])

            let changeRequest = user!.createProfileChangeRequest()
            changeRequest.displayName = fullname
            changeRequest.commitChanges(completion: nil)
            
            if let user = Auth.auth().currentUser {
                
                UserService.show(forUID: user.uid) { (user) in
                    
                    if let user = user {
                        User.setCurrent(user)
                        
                        print("new user, \(user.username).")
                        let storyboard = UIStoryboard(name: "Firebase", bundle: .main)
                        if let initialViewController = storyboard.instantiateInitialViewController() {
                            self?.view.window?.rootViewController = initialViewController
                            self?.view.window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
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
        email.frame = email.frame.offsetBy(dx: 0, dy: movement)
        password.frame = password.frame.offsetBy(dx: 0, dy: movement)
        fullname.frame = fullname.frame.offsetBy(dx: 0, dy: movement)
        singUpBtn.frame = singUpBtn.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
