//
//  ViewController.swift
//  chatBubble
//
//  Created by 黃恩祐 on 2017/10/7.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding an out going chat bubble
        var chatBubbleDataMine = ChatBubbleData(text: "Hey there!!! How are you?", image: nil, date: NSDate(), type: .Mine)
        var chatBubbleMine = chatBubble(data: chatBubbleDataMine, startY: 50)
        self.view.addSubview(chatBubbleMine)
        
        // Adding an incoming chat bubble
        var chatBubbleDataOpponent = ChatBubbleData(text: "Fine bro!!! check this out", image:UIImage(named: "ball123.png"), date: NSDate(), type: .Opponent)
        var chatBubbleOpponent = chatBubble(data: chatBubbleDataOpponent, startY: chatBubbleMine.frame.maxY + 10)
        self.view.addSubview(chatBubbleOpponent)
    }


}

