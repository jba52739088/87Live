//
//  signOutVC.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/26.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class signOutVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var singUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }

    @IBAction func doSignUp(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "mainView")
        self.present(mainView!, animated: true, completion: nil)
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
}
