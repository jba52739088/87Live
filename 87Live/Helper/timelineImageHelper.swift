//
//  timelineImageHelper.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/24.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    var aspectHeight: CGFloat {
        let heightRatio = size.height / UIScreen.main.bounds.height
        let widthRatio = size.width / UIScreen.main.bounds.width
        let aspectRatio = fmax(heightRatio, widthRatio)

        return size.height / aspectRatio
    }
    
    
}

extension UIImageView {
    
    func setRounded() {
        let radius = (self.frame.width) / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
