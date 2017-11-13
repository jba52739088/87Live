//
//  followingCell.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/22.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class followingCell: UITableViewCell {
    
    @IBOutlet weak var imageLeft: UIImageView!
    @IBOutlet weak var imageRight: UIImageView!
    @IBOutlet weak var nameLeft: UIButton!
    @IBOutlet weak var nameRight: UIButton!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
