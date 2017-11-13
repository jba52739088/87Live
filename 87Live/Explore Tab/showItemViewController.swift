//
//  ViewController.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/18.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class showItemViewController: UIViewController,  IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Show")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
