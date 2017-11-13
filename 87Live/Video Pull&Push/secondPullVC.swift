//
//  secondPullVC.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/11/7.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import IJKMediaFramework
import JTNumberScrollAnimatedView

class secondPullVC: UIViewController{
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var viewersNum: JTNumberScrollAnimatedView!
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var userEarnBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    @IBOutlet weak var stackViewForBtn: UIStackView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnGift: UIButton!
    
    var userValue = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        
        userValue = fakeUser.fakeArray as! [Dictionary<String, Any>]
        self.decorate()
        super.viewDidLoad()
        self.setIJKPlayer()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.startToPlay()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopPlay()
    }
    
    
    var player:IJKFFMoviePlayerController!
    var URLsource = ""
    var url = NSURL(string: "")
    
    var client = PomeloClient.init(delegate:self)
    var msgDic:NSDictionary = [:]
    var tempChatArray = [""]
    
    private var chatHistory:Array<String> = []
    private var counter = 0 //對話泡泡計數
    private var allText = ""
    var totalHeight:CGFloat = 0 //累積對話泡泡高度
    
    var followBool = false
    
    func setIJKPlayer(){
        let options = IJKFFOptions.byDefault()
        let player = IJKFFMoviePlayerController(contentURL: self.url! as URL, with: options)
        let autoresize = UIViewAutoresizing.flexibleWidth.rawValue |
            UIViewAutoresizing.flexibleHeight.rawValue
        player?.view.autoresizingMask = UIViewAutoresizing(rawValue: autoresize)
        player?.view.bounds = self.view.frame
        player?.view.frame = (player?.view.bounds)!
        player?.scalingMode = .aspectFit
        player?.shouldAutoplay = true
        player?.view.autoresizesSubviews = true
        player?.setPauseInBackground(false)
        self.player = player
    }
    
    func startToPlay(){
        self.player.prepareToPlay()
    }
    
    func stopPlay() {
        self.player.stop()
    }
    
    func stopPlaying(){
        self.view.removeFromSuperview()
    }
    @IBAction func doExit(_ sender: Any) {
        let superViewMaxX = (self.view.superview?.frame.maxX)!
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.center = CGPoint(x: superViewMaxX + (0.5 * self.view.frame.width), y: self.view.center.y)
            self.player.view.center = CGPoint(x: superViewMaxX + (0.5 * self.view.frame.width), y: self.view.center.y)
        }, completion: { (finished: Bool) in
            
            if let viewWithTag = self.view.superview!.viewWithTag(101) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag = self.view.superview!.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
                print("view be removed")
            }
        })
    }
    
    func decorate() {
        
        let value = userValue[appDelegate.selectedNum] as NSDictionary
        let userName = value.object(forKey: "userName")
        let viewerCount = value.object(forKey: "userViewers") as! Int!
        let userImage = value.object(forKey: "userImage")
        
        self.userImage.image = UIImage(named: "\(userImage!)")
        self.userNameLabel.text = "\(userName!)"
        self.userNameLabel.minimumScaleFactor = 0.1
        self.userNameLabel.adjustsFontSizeToFitWidth = true
        self.userNameLabel.lineBreakMode = .byClipping
        self.userEarnBtn.titleLabel?.textAlignment = .center
        self.userEarnBtn.titleLabel?.minimumScaleFactor = 0.1
        self.userEarnBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.userEarnBtn.titleLabel?.lineBreakMode = .byClipping
        self.userEarnBtn.titleLabel?.numberOfLines = 0
        self.followBtn.titleLabel?.textAlignment = .center
        self.followBtn.titleLabel?.minimumScaleFactor = 0.1
        self.followBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.followBtn.titleLabel?.lineBreakMode = .byClipping
        self.followBtn.titleLabel?.numberOfLines = 0
        
        self.viewersLabel.text = " viewers"
        self.userNameLabel.numberOfLines = 0
        self.viewersLabel.minimumScaleFactor = 0.1    
        self.viewersLabel.adjustsFontSizeToFitWidth = true
        self.viewersLabel.lineBreakMode = .byClipping
        self.viewersLabel.numberOfLines = 0
        
        self.viewersNum.textColor = UIColor.black
        let fontSize = self.viewersLabel.font.pointSize
        self.viewersNum.font = UIFont(name: "System", size: fontSize)
        self.viewersNum.minLength = 3
        self.viewersNum.backgroundColor = UIColor.blue
        self.getViewersNum(viewerCount: viewerCount!)
        self.viewersLabel.adjustsFontSizeToFitWidth = true
        self.viewersLabel.lineBreakMode = .byClipping
        self.viewersLabel.numberOfLines = 0
    }
    
    func getViewersNum(viewerCount: Int) {
        
        var valueLast = 0
        
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            let v = Int(arc4random_uniform(9999))
            let value = viewerCount + v
            self.viewersNum.value = NSNumber(value: value)
            self.viewersNum.duration = 2.5
            self.viewersNum.durationOffset = 0.5
            //            print("=====value: \(value)=====")
            if value < valueLast {
                self.viewersNum.isAscending = true
                self.viewersNum.startAnimation()
            }else if value > valueLast{
                self.viewersNum.isAscending = false
                self.viewersNum.startAnimation()
            }else{
                return
            }
            valueLast = value
        }
    }
    
    @IBAction func doPan(_ sender: UIPanGestureRecognizer) {
        
        let subViewMaxX = self.view.frame.maxX
        let superViewMaxX = (self.view.superview?.frame.maxX)!
        let maxX = (self.view.superview?.frame.maxX)! - (0.5 * self.view.frame.width)
        let closdX = (self.view.superview?.frame.maxX)! + (0.4 * self.view.frame.width)
        
        
        for i in 0..<sender.numberOfTouches {
            
            let p = sender.location(ofTouch: i, in: self.view.superview)
            
            self.view.center = p
            self.player.view.center = p
            let viewAlpha = ((self.view.frame.width) - subViewMaxX + superViewMaxX) / (self.view.frame.width)
            if subViewMaxX >= superViewMaxX {
                self.view.alpha = viewAlpha
                self.player.view.alpha = viewAlpha
            }else{
                self.view.alpha = 1
                self.player.view.alpha = 1
            }
        }
        
        
        if subViewMaxX >= superViewMaxX && sender.state == UIGestureRecognizerState.ended{
            if subViewMaxX >= closdX && sender.state == UIGestureRecognizerState.ended{
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.center = CGPoint(x: superViewMaxX + (0.5 * self.view.frame.width), y: self.view.center.y)
                    self.player.view.center = CGPoint(x: superViewMaxX + (0.5 * self.view.frame.width), y: self.view.center.y)
                }, completion: { (finished: Bool) in
                    
                    if let viewWithTag = self.view.superview!.viewWithTag(101) {
                        viewWithTag.removeFromSuperview()
                    }
                    if let viewWithTag = self.view.superview!.viewWithTag(100) {
                        viewWithTag.removeFromSuperview()
                        print("view be removed")
                    }
                })
            }else{
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.center = CGPoint(x: maxX, y: self.view.center.y)
                    self.player.view.center = CGPoint(x: maxX, y: self.view.center.y)
                    self.view.alpha = 1
                    self.player.view.alpha = 1
                })
            }
        }
    }
}
