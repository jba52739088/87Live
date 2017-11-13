//
//  mainTabBarController.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/18.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
//    let photoHelper = MGPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  let tabBar item's image be original 
        for item in self.tabBar.items!{
            item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
            item.image = item.image?.withRenderingMode(.alwaysOriginal)
        }
        
        delegate = self
        tabBar.unselectedItemTintColor = UIColor.black
        

    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 3 {
            
            
            let popOverVC = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "barBtnPopUpVC") as! barBtnPopUpVC
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
            
            return false
        }
        
        return true
    }
    
    func doLive() -> Void {
        
        return self.performSegue(withIdentifier: "PushV", sender: self)
    }
    
    

}

