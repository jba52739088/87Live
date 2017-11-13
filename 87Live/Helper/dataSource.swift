//
//  dataSource.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/18.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import Foundation
import Alamofire




struct fakeUser {
    
    let fakeUserData = [[
        "userID" : "",
        "userName" : "",
        "userLocation" : "",
        "userVisitor" : 10,
        "userEarn" : 10.5,
        "userViewers" : 10,
        "userImage" : "",
        "userFollower" : [""],
        "userFolloweing" : [""],
        "userTimeLine" : [
            "message" : "",
            "timeLineImage" : "",
            "time" : "",
            "like" : "",
            "comments" : [
                "commenter" : "",
                "messages" : ""]
        ]
        ]]
    
    
    
    
    
    
    
    static var fakeArray = [[:]]
    
    static func setFakeUser(_ userNum: Int) -> Array<Dictionary<String, Any>>{
        
        
        var fakeUserArray = [Dictionary<String, Any>]()
        for i in 1...userNum {
            
            let userName = ["褒姒","小喬","妹喜","大喬","趙飛燕","陳圓圓","驪姬","貂蟬","蕭皇后","妲己","李師師","王昭君","西施","婕妤","卓文君","潘金蓮","班昭","甄宓"]
            let userLocation = ["臺灣","香港","日本","新加坡","菲律賓"]
            let n = Int(arc4random_uniform(5))
            let v = Int(arc4random_uniform(1000000))
            let e = Int(arc4random_uniform(5000000))
            let w = Int(arc4random_uniform(20000))
            let fakeUserDic:[String : Any] = [
                "userID" : "user\(i)",
                "userName" : userName[i - 1],
                "userLocation" : userLocation[n],
                "userVisitor" : v,
                "userEarn" : e,
                "userViewers" : w,
                "userImage" : "user\(i).jpg",
                "userFollower" : [""],
                "userFolloweing" : [""],
                "userTimeLine" : [
                    "message" : "",
                    "timeLineImage" : "",
                    "time" : "",
                    "like" : "",
                    "comments" : [
                        "commenter" : "",
                        "messages" : "",
                        "time" : ""]
                ]
            ]
            fakeUserArray.append(fakeUserDic)
        }
        
        
        return fakeUserArray
    }
    
    static var timelineTag = 0
    
}

struct getUrl {
    
    static var videoView = ["rtmp://104.199.219.240/iii002?token=9d5c3b9ff7abd0836e5b271b9ca22f26&vhost=origin2/demo",
                            "rtmp://35.201.157.3/live/test",
                            "rtmp://live.hkstv.hk.lxdns.com/live/hks",
                            "http://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8",
                            "http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8",
                            "http://cdn-fms.rbs.com.br/vod/hls_sample1_manifest.m3u8",
                            "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8",
                            "http://walterebert.com/playground/video/hls/sintel-trailer.m3u8",
                            "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8",
                            "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8",
                            "rtmp://live.hkstv.hk.lxdns.com/live/hks",
                            "http://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8",
                            "http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8",
                            "http://cdn-fms.rbs.com.br/vod/hls_sample1_manifest.m3u8",
                            "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8",
                            "http://walterebert.com/playground/video/hls/sintel-trailer.m3u8",
                            "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8",
                            "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"]
    
    static var itemID:Int = 0
}

struct fakeTimeLine {
    
    static let fakeUserDic:[String : Any] = [
        "userID" : "user19",
        "userName" : "OBM",
        "email" : "123@123.123",
        "password" : "123456",
        "userLocation" : "USA",
        "userVisitor" : Int(arc4random_uniform(1000000)),
        "userEarn" : Int(arc4random_uniform(5000000)),
        "userViewers" : Int(arc4random_uniform(20000)),
        "userImage" : "jolinPhoto",
        "userFollower" : ["user1","user2","user3","user4","user5"],
        "userFolloweing" : ["user5","user6"],
        "userTimeLine" : [[
                            "message" : "Think anyone can top baby Pope this year?",
                            "timeLineImage" : "obm01",
                            "time" : "2016/11/01",
                            "like" : "710,000",
                            "comments" :
                                    [[
                                        "commenter" : "Sharon Inglima",
                                        "messages" : "Precious! I will miss you both in the White House!!!🎃🎃💕",
                                        "time" : "2016/11/01"],
                                     [
                                        "commenter" : "Chris Mcklem",
                                        "messages" : "I'm not even going to read the comments. I'm sure some people had nasty things to say. this is a great picture of a happy couple having fun on a holiday....can we please just leave it at that",
                                        "time" : "2016/11/01"]]
                        ],
                          [
                            "message" : "Face time.",
                            "timeLineImage" : "obm02",
                            "time" : "2016/10/25",
                            "like" : "560,000",
                            "comments" :
                                [[
                                    "commenter" : "Evan Morrison ",
                                    "messages" : "Although we disagree on some issues. I wish nothing but the best between you and your family after your term. God bless you Sir!",
                                    "time" : "2016/10/25"],
                                 [
                                    "commenter" : "Rose Turpin",
                                    "messages" : "Agree with him or not...there will never be such a class act as President...Period!",
                                    "time" : "2016/10/25"]]
                            
                            ]
        ]
    ]
    
    static var timelineImage = ["jolin01", "jolin02", "jolin03", "jolin04", "jolin05"]
    
    static let fakeUser2Dic: Dictionary<String, Any> = [
        "userID" : "user20",
        "userName" : "Jolin cai",
        "userLocation" : "馬德里",
        "userVisitor" : Int(arc4random_uniform(1000000)),
        "userEarn" : Int(arc4random_uniform(5000000)),
        "userViewers" : Int(arc4random_uniform(20000)),
        "userImage" : "jolinPhoto",
        "userFollower" : ["user8", "user9", "user10", "user11"],
        "userFolloweing" : ["user14", "user13", "user12", "user11", "user15", "user16"],
        "userTimeLine" : [[
                            "message" : "jolin_cai買衣服的時候問了皮肥的安親班老師說，熊該買 M 還是L ？ （因為L看起來好大件！）結果老師白了眼，不留情的說。。 。。。是XL!!!!",
                            "messageID" : "user20_01",
                            "timeLineImage" : "jolin05",
                            "time" : "5 days",
                            "like" : "73,082",
                            "comments" :
                                    [[
                                        "commenter" : "user8",
                                        "messages" : "別難受⋯⋯ 是這牌子衣服的版子偏小而已！😂",
                                        "time" : "5 days"],
                                     [
                                        "commenter" : "user11",
                                        "messages" : "哇噻！好可愛......👉❤️",
                                        "time" : "3 days"],
                                     [
                                        "commenter" : "user18",
                                        "messages" : "So cute.",
                                        "time" : "5 hours"]]
                        ],
                          [
                            "message" : "Face time.",
                            "messageID" : "user20_02",
                            "timeLineImage" : "jolin03",
                            "time" : "2016/10/25",
                            "like" : "560,000",
                            "comments" :
                                [[
                                    "commenter" : "user2",
                                    "messages" : "Although we disagree on some issues. I wish nothing but the best between you and your family after your term. God bless you Sir!",
                                    "time" : "2016/10/25"],
                                 [
                                    "commenter" : "Rose Turpin",
                                    "messages" : "Agree with him or not...there will never be such a class act as President...Period!",
                                    "time" : "2016/10/25"]]
                            
                        ],
                          [
                            "message" : "Face time.",
                            "messageID" : "user20_03",
                            "timeLineImage" : "jolin02",
                            "time" : "2017/12/25",
                            "like" : "456,000",
                            "comments" :
                                [[
                                    "commenter" : "user5",
                                    "messages" : "Although we disagree on some issues. I wish nothing but the best between you and your family after your term. God bless you Sir!",
                                    "time" : "2016/10/25"],
                                 [
                                    "commenter" : "user6",
                                    "messages" : "Agree with him or not...there will never be such a class act as President...Period!",
                                    "time" : "2016/10/25"]]
                            
                        ],
                          [
                            "message" : "jolin_cai #work #bagdesign #fendi #為小胖威力基金會盡一分力",
                            "messageID" : "user20_04",
                            "timeLineImage" : "jolin01",
                            "time" : "3 days",
                            "like" : "123,000",
                            "comments" :
                                [[
                                    "commenter" : "user9",
                                    "messages" : "Fendi💞",
                                    "time" : "2016/10/25"],
                                 [
                                    "commenter" : "user13",
                                    "messages" : "你的更好看💕超漂亮的想买",
                                    "time" : "2016/10/25"]]
                            
                        ],
                          [
                            "message" : "jolin_cai買衣服的時候問了皮肥的安親班老師說，熊該買 M 還是L ？ （因為L看起來好大件！）結果老師白了眼，不留情的說。。 。。。是XL!!!!",
                            "messageID" : "user20_05",
                            "timeLineImage" : "jolin04",
                            "time" : "2 days",
                            "like" : "73,082",
                            "comments" :
                                [[
                                    "commenter" : "user8",
                                    "messages" : "別難受⋯⋯ 是這牌子衣服的版子偏小而已！😂",
                                    "time" : "1 days"],
                                 [
                                    "commenter" : "user17",
                                    "messages" : "哇噻！好可愛......👉❤️",
                                    "time" : "3 hours"],
                                 [
                                    "commenter" : "user1",
                                    "messages" : "So cute.",
                                    "time" : "just now"]]
                            
            ]]
        ]
    
    
}


