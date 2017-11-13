//
//  giftBtnVC.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/11/2.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class giftBtnVC: ButtonBarPagerTabStripViewController {

    
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

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        showAnimate()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quit)))
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "giftTab01VC")
        let child_2 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "giftTab02VC")
        return [child_1, child_2]
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
