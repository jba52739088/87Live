//
//  timelineCommentCell.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/25.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class timelineCommentCell: UITableViewCell{

    @IBOutlet weak var commenterPhoto: UIImageView!
    @IBOutlet weak var commenterName: UILabel!
    @IBOutlet weak var commentTimeLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        commenterPhoto.bounds.size.height = commenterPhoto.bounds.width
        commenterPhoto.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
