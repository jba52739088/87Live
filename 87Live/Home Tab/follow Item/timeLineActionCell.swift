//
//  tmeLineActionCell.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/20.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit



class timeLineActionCell: UITableViewCell {

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    weak var delegate: PostActionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func doLike(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
    }
    
    @IBAction func doComment(_ sender: UIButton) {
        delegate?.didTapCommentButton(sender, on: self)
    }
    
}

protocol PostActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: timeLineActionCell)
    func didTapCommentButton(_ commentButton: UIButton, on cell: timeLineActionCell)
}
