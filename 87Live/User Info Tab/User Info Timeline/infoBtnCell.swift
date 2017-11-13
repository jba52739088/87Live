//
//  infoBtnCell.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/23.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class infoBtnCell: UITableViewCell {

    @IBOutlet weak var changingViewBtn: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        changingViewBtn.selectedSegmentIndex = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
