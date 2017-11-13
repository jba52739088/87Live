//
//  ProfileHeaderView.swift
//  87Live
//
//  Created by 黃恩祐 on 2017/11/12.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var levelBtn: UIButton!
    @IBOutlet weak var followerBtn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var likerBtn: UIButton!
    @IBOutlet weak var earnLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.decorate()
    }

    func decorate() {
        self.likerBtn.setTitle("0   ♥︎", for: .normal)
        self.likerBtn.layer.borderWidth = 2.0
        self.likerBtn.layer.cornerRadius = 8
        self.levelBtn.setTitle("9\nLevel", for: .normal)
        self.levelBtn.titleLabel?.textAlignment = .center
        self.followerBtn.setTitle("2\nFollowers", for: .normal)
        self.followerBtn.titleLabel?.textAlignment = .center
        self.followingBtn.setTitle("6\nFollowing", for: .normal)
        self.followingBtn.titleLabel?.textAlignment = .center
        self.earnLabel.layer.borderWidth = 1.0
        self.earnLabel.text = "Today's royalties 0.0000 USD"
    }
}
