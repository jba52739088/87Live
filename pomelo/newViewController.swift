//
//  newViewController.swift
//  Client
//
//  Created by 黃恩祐 on 2017/10/20.
//  Copyright © 2017年 xiaochuan. All rights reserved.
//

import UIKit
import Alamofire

class newViewController: UIViewController {

    var client = PomeloClient.init(delegate:self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        connect()
//        client.delegate = self
    }

    @IBAction func doConnect(_ sender: Any) {
        connect()
    }
    
    @IBAction func doEnter(_ sender: Any) {
        enter()
    }
    
    @IBAction func doEnterGame(_ sender: Any) {
        enterGame()
    }
    
    @IBAction func enterRoom(_ sender: Any) {
        enterRoom()
    }
    
    @IBAction func sendMsg(_ sender: Any) {
        sendMsg()
    }
    @IBAction func getMsg(_ sender: Any) {
        getMsg()
    }
    
    @IBAction func doDisconnect(_ sender: Any) {
        disconnect()
    }
    func connect() {
        client?.connect(toHost: "35.189.177.108", onPort: "3001", withCallback: { arg in
            print("===============connect:\(arg!)=================")
            self.enter()
        })
    }
    
    func enter() {
        client?.request(withRoute: "connector.entryHandler.enter", andParams: ["a": "iii002","p":"qwerty123"], andCallback: { (arg) in
            print("===============enter: \(arg!)=================")
            self.enterGame()
        })
    }
    
    func enterGame() {
        client?.request(withRoute: "connector.entryHandler.enterGame", andParams: ["gs": [401]], andCallback: { (arg) in
            print("===============enterGame:\(arg!)=================")
            for i in 1..<255 {
                self.client?.onRoute("401\(i)", withCallback: { (arg) in
                    print("======================onRoute: \(arg!)======================")
                })
            }
        })
    }
    
    func enterRoom() {
        client?.notify(withRoute: "chat.chatHandler.EnterRoom", andParams: ["a": 999])
        print("===========enterRoom===========")
    }
    
    func sendMsg() {
        client?.notify(withRoute: "chat.chatHandler.Msg", andParams: ["m": "msg"])
        print("===========sent Msg===========")
        
    }
    
    func getMsg() {
        client?.onRoute("40111", withCallback: { (arg) in
            print("=====================getMsg: \((arg)!)===================")
            print(type(of: arg))
        })
    }

    func disconnect() {
        client?.disconnect()
        print("===========disconnect===========")
    }
    



}
