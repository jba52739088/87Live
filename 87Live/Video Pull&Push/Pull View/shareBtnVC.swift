//
//  shareBtnVC.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/11/2.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class shareBtnVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        showAnimate()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quit)))
    }
    
    @objc func quit() {
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1.0
            self.view.frame.origin.y = self.view.frame.origin.y - self.view.frame.height
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
}

