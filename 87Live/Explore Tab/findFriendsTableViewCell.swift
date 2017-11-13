//
//  findFriendsTableViewCell.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/10/16.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class findFriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    weak var delegate: FindFriendsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        followBtn.layer.borderColor = UIColor.lightGray.cgColor
        followBtn.layer.borderWidth = 1
        followBtn.layer.cornerRadius = 6
        followBtn.clipsToBounds = true
        
        followBtn.setTitle("Follow", for: .normal)
        followBtn.setTitle("Following", for: .selected)
    }


    @IBAction func doFollow(_ sender: UIButton) {
        print("doFollow")
        delegate?.didTapFollowButton(sender, on: self)
    }
    
}

protocol FindFriendsCellDelegate: class {
    func didTapFollowButton(_ followButton: UIButton, on cell: findFriendsTableViewCell)
}
