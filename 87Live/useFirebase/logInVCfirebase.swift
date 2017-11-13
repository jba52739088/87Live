//
//  logInVCfirebase.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/26.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabaseUI
import FirebaseDatabase
import FirebaseAuthUI

typealias FIRUser = FirebaseAuth.User

class logInVCfirebase: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var singinBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 10
        email.delegate = self
        password.delegate = self
        email.text = "jba52739088@gmail.com"
        password.text = "123456"
    }
    
    @IBAction func doLogin(_ sender: Any) {
        
        guard let email = email.text, let password = password.text
            else {return}
        
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](user, error) in
            if let error = error{
                self?.alert(message: error.localizedDescription)
                return
            }
            
            if let user = Auth.auth().currentUser {

                UserService.show(forUID: user.uid) { (user) in
                    
                    if let user = user {
                        User.setCurrent(user)
                        
                        print("Welcome back, \(user.username).")
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
    
    @IBAction func doSignUp(_ sender: Any) {
        
        if let resultController = self.storyboard?.instantiateViewController(withIdentifier: "SIGNUP") as? signOutVCfirebase {
            let navController = UINavigationController(rootViewController: resultController)
            self.present(navController, animated:true, completion: nil)
        }
    }
    
    /////////////////////////////////
    // Start Editing The Text Field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -100, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -100, up: false)
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
        btnLogin.frame = btnLogin.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
