//
//  adVC.swift
//  87Live
//
//  Created by 黃恩祐 on 2017/11/17.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//
//
//  willDismissVC.swift
//  myCountdownDismissView
//
//  Created by 黃恩祐 on 2017/11/17.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class adVC: UIViewController {
    
    @IBOutlet weak var counterBtn: UIButton!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var counterView: UIView!
    var counter = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.counterView.layer.cornerRadius = 5
        self.counterView.layer.borderWidth = 1
        self.counterView.layer.borderColor = UIColor.white.cgColor
        self.counterBtn.setTitle("skip", for: .normal)
        self.counterLabel.text = "6"
        self.counterLabel.textColor = UIColor.red
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @IBAction func close(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @objc func updateCounter() {
        //you code, this is an example
        if counter > 0 {
            self.counterLabel.text = "\(counter)"
            counter -= 1
        }else{
            self.view.removeFromSuperview()
        }
    }
}

