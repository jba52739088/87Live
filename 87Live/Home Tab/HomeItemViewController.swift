//
//  parentViewController.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/17.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeItemViewController: ButtonBarPagerTabStripViewController {

    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnLevel: UIButton!
    var isTimeLineMode = true
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
        super.viewDidLoad()
        
        self.btnMenu.imageView?.contentMode = .scaleAspectFit
        self.btnLevel.imageView?.contentMode = .scaleAspectFit
        self.btnMenu.setImage(UIImage(named: "menu-rect"), for: .normal)
        self.btnMenu.setImage(UIImage(named: "menu-time"), for: .selected)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var child_1: UIViewController
        if isTimeLineMode {
            child_1 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "following")
        }else{
            child_1 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "followingCollection")
        }
        let child_2 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "hot")
        let child_3 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "werewolves")
        let child_4 = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "new")
        return [child_1, child_2, child_3, child_4]
    }

    
    @IBAction func doMenu(_ sender: Any) {
        print("click menu")
        btnMenu.isSelected = isTimeLineMode
        isTimeLineMode = !isTimeLineMode
        self.reloadPagerTabStripView()
    }
    @IBAction func doLevel(_ sender: Any) {
    }
    

}
