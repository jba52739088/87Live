//
//  timeLineImageCell.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/20.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class timeLineImageCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var timeLineImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPhoto.setRounded()
        userPhoto.layer.borderColor = UIColor.white.cgColor
        userPhoto.layer.borderWidth = 2
        userPhoto.contentMode = .scaleAspectFit
//        timeLineImage.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
