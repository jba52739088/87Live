//
//  PullVideoTableViewCell.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/10/2.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import IJKMediaFramework
import JTNumberScrollAnimatedView


class PullVideoTableViewCell: UITableViewCell, UITextFieldDelegate {

    
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btnPush: UIButton!
    var timer:Timer?
    
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnGift: UIButton!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var stackViewForBtn: UIStackView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var viewersNum: JTNumberScrollAnimatedView!
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var userEarnBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var masterImage: UIImageView!
    
    @IBOutlet weak var childView: UIView!
    
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
        player?.view.frame = (player?.view.bounds)!
        player?.scalingMode = .aspectFit
        player?.shouldAutoplay = true
        player?.view.autoresizesSubviews = true
        self.backgroundView = player?.view
        player?.setPauseInBackground(true)
        self.player = player
    }
    
    func startToPlay(){
        self.player.prepareToPlay()
    }
    
    func pausePlay() {
        self.player.pause()
    }
    
    func stopPlaying(){
        removeChat()
        self.player.shutdown()
        setIJKPlayer()
        self.disconnect()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setIJKPlayer()
        self.initChatField()
        textField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PullVideoTableViewCell.dismissKeyboard))
        self.addGestureRecognizer(tap)
        
        

    }
    
    @objc func dismissKeyboard() {
        textField.endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initChatField(){
        textField.isHidden = !textField.isHidden
        btnPush.isHidden = !btnPush.isHidden
        textView.text = ""
        textField.text = ""
    }
    
    @IBAction func doPush(_ sender: UIButton) {
        sendMessage(msg: textField.text!)
        textField.text = ""
        textField.endEditing(true)
    }
    
    func sendMessage(msg: String) {
        sendMsg(msg: msg)
    }


    func setChatBubble(){
        
        // Adding an incoming chat bubble
        let chatBubbleDataOpponent = ChatBubbleData(text: chatHistory[counter], image: nil, date: NSDate(), type: .Opponent)
        var chatBubbleOpponent = chatBubble(data: chatBubbleDataOpponent, startY: totalHeight)
        let textViewContentSize = textView.frame.size.height //textView 內容大小
        let bubbleBuildPosition = textViewContentSize + totalHeight //對話框出現在textView最底部位置
        chatBubbleOpponent = chatBubble(data: chatBubbleDataOpponent, startY: bubbleBuildPosition)
        textView.addSubview(chatBubbleOpponent)
        let eachChatBubble = ChatBubbleData(text: chatHistory[counter], image: nil, date: NSDate(), type: .Opponent)
        var eachChatBubbleOpponent = chatBubble(data: eachChatBubble, startY: bubbleBuildPosition)
        totalHeight = 0
        for i in 0 ..< chatHistory.count{
            eachChatBubble.text = chatHistory[i]
            eachChatBubbleOpponent = chatBubble(data: eachChatBubble, startY: bubbleBuildPosition)
            totalHeight += eachChatBubbleOpponent.frame.height + 5
        }
        textView.contentSize.height = textViewContentSize + totalHeight
    }
    
    func removeChat() {
        for view in textView.subviews{
            view.removeFromSuperview()
        }
    }
    
    @IBAction func doQuit(_ sender: UIButton) {
        self.disconnect()
        player.shutdown()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { (Timer2) in
            print("stop timer")
        })
    }

    @IBAction func doUserEarn(_ sender: Any) {
    }
    
    @IBAction func doFollow(_ sender: Any) {
        print("doFollow")
    }
    
    
    @IBAction func doChat(_ sender: Any) {
        
        initBtnPosition()
        textField.becomeFirstResponder()
//                initBtnPosition()
    }
    @IBAction func doShare(_ sender: Any) {
    }
    
    @IBAction func doLike(_ sender: Any) {
        self.sendMessage(msg: "give you lots of ❤️💛💚💙💜")
    }
    
    @IBAction func doAdd(_ sender: Any) {
    }
    
    @IBAction func doGift(_ sender: Any) {
    }
    

    
    func initBtnPosition (){
        stackViewForBtn.isHidden = !stackViewForBtn.isHidden
        textField.isHidden = !textField.isHidden
        btnPush.isHidden = !btnPush.isHidden
    }
    
    /////////////////////////////////
    // Start Editing The Text Field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
//        initBtnPosition()
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
        initBtnPosition()
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.textField.frame = self.textField.frame.offsetBy(dx: 0, dy: movement)
        self.btnPush.frame = self.btnPush.frame.offsetBy(dx: 0, dy: movement)
        self.textView.frame = self.textView.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()

    }
    ////////////////////////////
    
    
    
    func decorate() {
        btnClose.setTitle("", for: .normal)
        for myBtn in self.stackViewForBtn.subviews{
            myBtn.layer.shadowColor = UIColor.black.cgColor
            myBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            myBtn.layer.masksToBounds = false
            myBtn.layer.shadowRadius = 1.0
            myBtn.layer.shadowOpacity = 0.5
            myBtn.layer.cornerRadius = myBtn.frame.width / 2
        }
        
        let userEarnBtnRectShape = CAShapeLayer()
        userEarnBtnRectShape.bounds = self.userEarnBtn.frame
        userEarnBtnRectShape.position = self.userEarnBtn.center
        userEarnBtnRectShape.path = UIBezierPath(roundedRect: self.userEarnBtn.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: self.userEarnBtn.frame.height / 2, height: self.userEarnBtn.frame.height / 2)).cgPath
        self.userEarnBtn.layer.mask = userEarnBtnRectShape
        
        let followBtnRectShape = CAShapeLayer()
        followBtnRectShape.bounds = self.userEarnBtn.frame
        followBtnRectShape.position = self.userEarnBtn.center
        followBtnRectShape.path = UIBezierPath(roundedRect: self.userEarnBtn.bounds, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: self.userEarnBtn.frame.height / 2, height: self.userEarnBtn.frame.height / 2)).cgPath
        self.followBtn.layer.mask = followBtnRectShape
        
    }
    
    // pomelo
    func connect() {
        client?.connect(toHost: "35.189.177.108", onPort: "3001") { (arg) in
            print("===============connect=================")
            self.enter()
        }
    }
    
    func enter() {
        client?.request(withRoute: "connector.entryHandler.enter", andParams: ["a": "iii002","p":"qwerty123"], andCallback: { (arg) in
            print("===============request=================")
            let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                self.enterGame()
            }
        })
    }
    
    func enterGame() {
        var enteredRoom = false
        client?.request(withRoute: "connector.entryHandler.enterGame", andParams: ["gs": [401]], andCallback: { (arg) in
            print("===============request=================")
            for i in 1..<255 {
                self.client?.onRoute("401\(i)", withCallback: { (arg) in
                    
                    if !enteredRoom{
                        self.enterRoom()
                    }
                    switch i {
                    case 1:
                        print("要求創造房間")
                    case 2:
                        print("要求關閉房間")
                    case 3:
                        print("要求進入房間")
                        enteredRoom = true
                    case 4:
                        print("要求離開房間")
                    case 5:
                        print("刷新房間資訊")
                    case 11:
                        print("要求發送訊息")
                        self.msgDic = arg! as! NSDictionary
                        self.getMsgOnline(message: self.msgDic)
                    case 21:
                        print("取得大廳列表")
                    case 22:
                        print("更新大廳列表")
                    case 91:
                        print("要求Echo")
                    default:
                        print("收到call back \(i)")
                    }
                })
            }

        })
    }
    
    func enterRoom() {
        client?.notify(withRoute: "chat.chatHandler.EnterRoom", andParams: ["a": 999])
        print("===========enterRoom===========")
    }
    
    func sendMsg(msg: String){
        client?.notify(withRoute: "chat.chatHandler.Msg", andParams: ["m": "\(msg)"])
        print("===========sent Msg:\(msg)===========")
    }
    
    func disconnect() {
        client?.disconnect()
        print("===========disconnect===========")
    }
    
    
    func getMsgOnline(message: NSDictionary) {
        print("=======getMsgOnline: \(self.msgDic)=============")
        let msgs = message
        let msg = (msgs["m"]) as! String?
        let msgSender = (msgs["p"]) as! String?
        if let msgs = msg {
            let msgsLast = tempChatArray.last
            if msgs != msgsLast {
                let chatValue = msgs
                if chatValue != "" {
                    tempChatArray.append(msgs)
                    chatHistory.append("\(msgSender!) : \(chatValue)")

                    self.setChatBubble()
                    counter += 1
                    //  let textview auto scroll to bottom
                    let bottomOffset = CGPoint(x: 0, y: (textView.contentSize.height - textView.bounds.size.height))
                    textView.setContentOffset(bottomOffset, animated: true)
                }
            }
        }
    }
    
    
    func getViewersNum(viewerCount: Int) {

        var valueLast = 0
        
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            let v = Int(arc4random_uniform(9999))
            let value = viewerCount + v
            self.viewersNum.value = NSNumber(value: value)
            self.viewersNum.duration = 2.5
            self.viewersNum.durationOffset = 0.5
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
        let size = CGFloat(arc4random_uniform(30))
        movingImage.frame = CGRect(x: x, y: y, width: 20 + size, height: 20 + size)
        self.contentView.addSubview(movingImage)
        
        let bubblePath = UIBezierPath()
        
        let oX = self.btnGift.frame.origin.x + self.btnGift.frame.width / 2
        let oY = self.contentView.frame.size.height - self.btnGift.frame.origin.y - self.btnGift.frame.height / 2
        let eX = oX
        let eY = oY - self.contentView.frame.height * 3 / 4
        let t:CGFloat = CGFloat(arc4random_uniform(150))
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
    
    func testFunc() {
        print("doooooooo")
    }

}




