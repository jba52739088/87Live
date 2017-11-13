//
//  Avatar.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/10/2.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import ChattoAdditions

class avatar: BaseMessageCollectionViewCellDefaultStyle {
    
    override func avatarSize(viewModel: MessageViewModelProtocol) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    // return viewModel.isIncoming ? CGSize(width: 30, height: 30) : CGSize.zero
    
}
