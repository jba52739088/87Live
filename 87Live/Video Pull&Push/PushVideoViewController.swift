//
//  ViewController.swift
//  MyLFLiveKitTest
//
//  Created by 黃恩祐 on 2017/10/19.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import LFLiveKit
import AVFoundation
import Alamofire

class PushVideoViewController: UIViewController, LFLiveSessionDelegate, UITextFieldDelegate {
    
    var PushUrl = ""
    var client = PomeloClient.init(delegate:self)
    var msgDic:NSDictionary = [:]
    var tempChatArray = [""]
    private var chatHistory:Array<String> = []
    private var counter = 0 //對話泡泡計數
    private var allText = ""
    private var timer:Timer?
    var totalHeight:CGFloat = 0 //累積對話泡泡高度
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var linkingStateLb: UILabel!
    @IBOutlet weak var beautyBtn: UIButton!
    @IBOutlet weak var changeCarmeraBtn: UIButton!
    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var pushBtn: UIButton!
    
    //MARK: - Getters and Setters
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session?.delegate = self
        session?.preView = self.view
        return session!
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = true
        requestAccessForAudio()
        requestAccessForVideo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPushUrl()
        textfield.delegate = self
        closeBtn.setTitle("", for: .normal)
        
        self.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopLive()
    }
    
    func requestAccessForVideo()  {
        weak var _self = self
        let state = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch state {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (grandted) in
                guard grandted else { return }
                DispatchQueue.main.async(execute: {
                    _self?.session.running = true
                })
            })
        case.authorized:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (grandted) in
                guard grandted else { return }
                DispatchQueue.main.async(execute: {
                    _self?.session.running = true
                })
            })
            break
        case.denied:break
        case.restricted:break
        }
    }
    
    func requestAccessForAudio()  {
        let state = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch state {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                guard granted else{
                    return
                }
            })
        case .authorized: break
        case .denied: break
        case .restricted: break
        }
    }
    
    func startLive() {
        let stream = LFLiveStreamInfo()
        stream.url = self.PushUrl
        self.session.startLive(stream)
    }
    
    func stopLive() {
        self.session.stopLive()
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        switch state {
        case .ready:
            self.linkingStateLb.text = "未連結"
        case .pending:
            self.linkingStateLb.text = "pending"
        case .start:
            self.linkingStateLb.text = "start"
        case .stop:
            self.linkingStateLb.text = "stop"
        case .error:
            self.linkingStateLb.text = "error"
        case .refresh:
            self.linkingStateLb.text = "refresh"
        }
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo:\(debugInfo)")
    }
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode:\(errorCode)")
    }
    
    func getPushUrl(){
        let parameters = [
            "username":"iii002",
            "password":"qwerty123"
        ]
        
        Alamofire.request("http://35.194.139.26/ci/index.php/StreamDemo/StreamerLogin", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("=============StreamerLogin================")
                if let JSON = response.result.value as? [String:AnyObject] {
                    self.PushUrl = "\(JSON["message"]!["url"]! as! String)/\(JSON["message"]!["stream"]! as! String)"
                }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.disconnect()
        self.timer?.invalidate()
        self.timer = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func beautyBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.session.beautyFace = !self.session.beautyFace
    }
    @IBAction func changeCarmeraBtn(_ sender: UIButton) {
        let position = self.session.captureDevicePosition
        self.session.captureDevicePosition = (position == AVCaptureDevice.Position.back) ?AVCaptureDevice.Position.front : AVCaptureDevice.Position.back
    }
    @IBAction func startLive(_ sender: UIButton) {
        startLive()
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            self.enter()
        }
    }
    
    @IBAction func doPush(_ sender: UIButton) {
        sendMessage(msg: textfield.text!)
        let bottomOffset = CGPoint(x: 0, y: (textView.contentSize.height - textView.bounds.size.height))
        textView.setContentOffset(bottomOffset, animated: true)
    }
    
    func sendMessage(msg: String) {
        sendMsg(msg: msg)
        textfield.text = ""
        textfield.endEditing(true)
        self.initChatField()
    }
    
    ///////////////////pomelo
    func connect() {
        client?.connect(toHost: "35.189.177.108", onPort: "3001") { (arg) in
            print("===============connect=================")
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
            print("\(msgs):\(msgsLast!)")
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
    
    func setChatBubble(){
        
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
    
    /////////////////////////////////
    // Start Editing The Text Field
    
    func initChatField(){
        textView.text = ""
        textfield.text = ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.textfield.frame = self.textfield.frame.offsetBy(dx: 0, dy: movement)
        self.textView.frame = self.textView.frame.offsetBy(dx: 0, dy: movement)
        self.pushBtn.frame = self.pushBtn.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}



