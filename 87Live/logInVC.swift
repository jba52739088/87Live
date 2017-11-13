//
//  logInVC.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/26.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class logInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var singinBtn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 10
        email.delegate = self
        password.delegate = self
        email.text = "123@123.123"
        password.text = "123456"
    }

    @IBAction func doLogin(_ sender: Any) {
        
        let dataDic = fakeTimeLine.fakeUserDic as NSDictionary
        let userEmail = dataDic["email"] as! String
        let userPassword = dataDic["password"] as! String
        
        guard let email = email.text, let password = password.text
            else {return}
        if email == userEmail && password == userPassword{
            let mainView = storyboard?.instantiateViewController(withIdentifier: "mainView")
            self.present(mainView!, animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: nil, message: "Enter correct email and password, please", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func doSignUp(_ sender: Any) {
        
        if let resultController = storyboard!.instantiateViewController(withIdentifier: "SIGNUP") as? signOutVC {
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
