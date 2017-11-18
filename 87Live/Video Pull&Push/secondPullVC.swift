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
    @IBOutlet weak var userEarnBtn: UILabel!
    @IBOutlet weak var followBtn: UILabel!
    
    @IBOutlet weak var stackViewForBtn: UIStackView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnGift: UIButton!
    
    var userValue = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        
        userValue = appDelegate.userValue
        self.decorate()
        super.viewDidLoad()
        self.setIJKPlayer()
        self.giftHeart()
        
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
        self.userEarnBtn.minimumScaleFactor = 0.1
        self.userEarnBtn.adjustsFontSizeToFitWidth = true
        self.userEarnBtn.lineBreakMode = .byClipping
        self.userEarnBtn.baselineAdjustment = .alignCenters
        self.followBtn.minimumScaleFactor = 0.1
        self.followBtn.adjustsFontSizeToFitWidth = true
        self.followBtn.lineBreakMode = .byClipping
        self.followBtn.baselineAdjustment = .alignCenters
        
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
    
    func giftHeart() {
        let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer1) in
            let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer2) in
                self.createBubble()
            }
            let _ = Timer.scheduledTimer(withTimeInterval: 1.1, repeats: true) { (timer2) in
                self.createBubble()
            }
            let _ = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true) { (timer2) in
                self.createBubble()
            }
        }
    }
    
    
    @objc func createBubble() {
        
        var imageNum = Int(arc4random_uniform(15) + 1)
        
        if imageNum > 4 {
            imageNum = 1
        }
        let image = UIImage(named: "heart\(imageNum)")
        let tempImage = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let movingImage = UIImageView()
        movingImage.image = tempImage
        let colors = [UIColor.orange, UIColor.blue, UIColor.red, UIColor.cyan, UIColor.green, UIColor.white]
        let colorNum = Int(arc4random_uniform(6))
        movingImage.tintColor = colors[colorNum]
        movingImage.alpha = 0.7
        let x = self.btnGift.frame.origin.x
        let y = self.btnGift.frame.origin.y
        let size = CGFloat(arc4random_uniform(10))
        movingImage.frame = CGRect(x: x, y: y, width: 5 + size, height: 5 + size)
        self.view.addSubview(movingImage)
        
        let bubblePath = UIBezierPath()
        
        let oX = self.btnGift.frame.origin.x + self.btnGift.frame.width / 2
        let oY = self.view.frame.size.height - self.btnGift.frame.origin.y - self.btnGift.frame.height / 2
        let eX = oX
        let eY = oY - self.view.frame.height * 3 / 4
        let t:CGFloat = CGFloat(arc4random_uniform(30))
        let bool = Int(arc4random_uniform(2))
        var cp1 = CGPoint()
        var cp2 = CGPoint()
        if bool == 0{
            cp1 = CGPoint(x: oX - t, y: ((oY + eY) / 2));
            cp2 = CGPoint(x: oX + t, y: cp1.y)
        }else{
            cp1 = CGPoint(x: oX + t, y: ((oY + eY) / 2));
            cp2 = CGPoint(x: oX - t, y: cp1.y)
        }
        
        bubblePath.move(to: CGPoint(x: oX, y: oY))
        bubblePath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // transform the image to be 1.3 sizes larger to
            // give the impression that it is popping
            UIView.transition(with: movingImage, duration: 0.1, options: .transitionCrossDissolve, animations: {
                movingImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (finished : Bool) in
                movingImage.removeFromSuperview()
            })
        }
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 3
        pathAnimation.path = bubblePath.cgPath
        // remains visible in it's final state when animation is finished
        // in conjunction with removedOnCompletion
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        movingImage.layer.add(pathAnimation, forKey: "movingAnimation")
    }
}
