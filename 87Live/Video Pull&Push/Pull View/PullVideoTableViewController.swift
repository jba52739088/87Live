//
//  PullVideoTableViewController.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/10/2.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import Alamofire
import JTNumberScrollAnimatedView
import AudioToolbox
import MediaPlayer

class PullVideoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    
    var rtmpSid = ""
    var dicts:Array<NSDictionary> = []
    var gotPullUrl = ""
    let viewWidth = UIScreen.main.bounds.width
    let viewheight = UIScreen.main.bounds.height
    var timer:Timer?
    var isLoadingTableView = true
    
    var videoView = getUrl.videoView
    var userValue = [Dictionary<String, Any>]()
    
    var swipeDirection = true
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        userValue = fakeUser.fakeArray.sorted(by: { (dictionary1, dictionary2) -> Bool in
            return Int(dictionary1["userViewers"] as! Int) > Int(dictionary2["userViewers"] as! Int)
        }) as! [Dictionary<String, Any>]
        if getUrl.itemID > 1{
            for _ in 1...(getUrl.itemID - 1){
                userValue.append(userValue[0] )
                userValue.remove(at: 0)
            }
        }
        fakeUser.fakeArray = userValue
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        
        self.tableView.addGestureRecognizer(swipeRight)
        
        // Don't interrupt user audio
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        // Start VolumeBar
        VolumeBar.sharedInstance.start()
        
    }
    

    @objc func didSwipe(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            let swipeLocation = recognizer.location(in: self.tableView)
            if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
                if let swipedCell = self.tableView.cellForRow(at: swipedIndexPath) {
                    swipedCell.contentView.isHidden = !swipedCell.contentView.isHidden
                    print("do swipe")
                }
            }
        }
    }

    @IBAction func doQuit(_ sender: Any) {
        isLoadingTableView = true
        let cell = PullVideoTableViewCell()
        cell.disconnect()
        VolumeBar.sharedInstance.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeUser.fakeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height + 0.01
    }
    
    var enterRoom1 = 0
    var enterRoom2 = 0
    var lastRow = 0
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PullVideoTableViewCell
        setMasterInfo(cell, indexPath.row, indexPath)
        
        cell.disconnect()
        
        lastRow = indexPath.row
        cell.removeChat()
        return cell
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndScrollingAnimation")
    }
    var counterDis = 0
    var rowNum = 0
    var cellWillDisplay = 0
    var test = true
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        
        
        let tableview = self.tableView
        let paths = tableview?.indexPathsForVisibleRows
        cellWillDisplay += 1
        if indexPath.row == 0 {
            counterDis += 1
            rowNum = indexPath.row
        }
        if paths?.count == 1{
            let row = (paths![0])
            enterRoom1 = row[1]
            print("============only one room: \(enterRoom1)==============")
        }else{
            let row_1 = (paths![0])
            let row_2 = (paths![1])
            enterRoom1 = row_1[1]
            enterRoom2 = row_2[1]
            print("============have two rooms: \(enterRoom1), \(enterRoom2)==============")
            
        }
        if counterDis > 1 {
            if indexPath.row == getUrl.itemID - 1{
                if cell is PullVideoTableViewCell{
                }
            }
            if indexPath.row > rowNum{
                getUrl.itemID += 1
            }else{
                getUrl.itemID -= 1
            }
        }

        if fakeUser.fakeArray.count > 0 && isLoadingTableView{
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows, let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row{
                self.isLoadingTableView = false
            }
        }


        if isLoadingTableView == false {

            if (getUrl.itemID) >= self.lastRow{
                getUrl.itemID = 1
            }

            print("=========getUrl.itemID - 1: \(getUrl.itemID - 1)===22222======")

            if (getUrl.itemID - 1) < self.lastRow{
                if let cell = cell as? PullVideoTableViewCell{
                    let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer3) in
                        if indexPath.row != fakeUser.fakeArray.count - 1{
                            if indexPath.row > self.lastRow{
                                self.enterRoom1 += 1
                                self.enterRoom2 += 1
                            }
                        }
                        if indexPath.row == self.enterRoom1{
                            cell.connect()
                            cell.giftHeart()
                            print("BBBBBB")
                            self.test = true

                        }else{
                            if indexPath.row - 1 == self.enterRoom1 || indexPath.row - 1 == self.enterRoom2 || indexPath.row + 1 == self.enterRoom1{
                                cell.connect()
                                cell.giftHeart()
                                print("CCCCCC")
                                self.test = true
                            }
                        }
                    }
                }
            }else {
                getUrl.itemID = 1
                print("GGGGGGG")
                if test == true{
                    if let cell = cell as? PullVideoTableViewCell{
                        cell.giftHeart()
                        cell.connect()
                        
                    }

                    test = false
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? PullVideoTableViewCell{
            videoCell.removeChat()
            videoCell.stopPlaying()
            
        }
    }
    
    func setMasterInfo(_ cell: PullVideoTableViewCell, _ indexPath: Int, _ IndexPath: IndexPath) {
        
        let value = userValue[indexPath] as NSDictionary
        
        let userName = value.object(forKey: "userName")
        let viewerCount = value.object(forKey: "userViewers")
        let userImage = value.object(forKey: "userImage")
        let userEarn = value.object(forKey: "userEarn")
        
        cell.decorate()
        cell.userImage.image = UIImage(named: "\(userImage!)")
        cell.userNameLabel.text = "\(userName!)"
        cell.viewersLabel.text = " viewers"
        
        
        cell.viewersNum.textColor = UIColor.black
        cell.viewersNum.font = UIFont(name: "System", size: 15)
        cell.viewersNum.minLength = 3
        cell.viewersNum.backgroundColor = UIColor.clear
        cell.getViewersNum(viewerCount: viewerCount! as! Int)
        cell.userEarnBtn.setTitle(" ☺︎ \(userEarn!) ", for: .normal)
        cell.userEarnBtn.titleLabel?.textAlignment = .center
        cell.userEarnBtn.layer.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        cell.followBtn.setTitle("+ Follow", for: .normal)
        cell.followBtn.layer.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        cell.followBtn.titleLabel?.textAlignment = .center
        cell.followBtn.addTarget(self, action:#selector(doFollow(sender:)), for: .touchUpInside)
        cell.btnGift.addTarget(self, action:#selector(doGift(sender:)), for: .touchUpInside)
        cell.btnShare.addTarget(self, action:#selector(doShare(sender:)), for: .touchUpInside)
        cell.btnAdd.addTarget(self, action:#selector(doAdd(sender:)), for: .touchUpInside)
        cell.userEarnBtn.addTarget(self, action:#selector(doUserEarn(sender:)), for: .touchUpInside)
        cell.url = NSURL(string: videoView[indexPath])
        cell.setIJKPlayer()
        cell.startToPlay()
        
        
        cell.masterImage.image = UIImage(named: "\(userImage!)")
        cell.masterImage.isHidden = false
        cell.masterImage.alpha = 1.0
        UIView.animate(withDuration: 0.8, delay: 0, options: [], animations: {
            cell.masterImage.alpha = 0.0
        }) { (finished: Bool) in
            cell.masterImage.isHidden = true
        }
        
        cell.childView.isHidden = true
    }
    

    
    
    
    
    
    
    func scrollToTappedView() {
        let numberOfSections = self.tableView.numberOfSections
        let indexPath = IndexPath(row: (getUrl.itemID - 1) , section: numberOfSections-1)
        
        
        
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
    }
    

    var follow = false
    var chindViewIsHidden = true
    
    @objc func doFollow(sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
        
        let cell = tableView.cellForRow(at: indexPath!) as! PullVideoTableViewCell
        
        follow = !follow
        
        if follow == true{
            cell.followBtn.setTitle("Following", for: .normal)
            cell.followBtn.layer.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            print("Following")
        }else{
            cell.followBtn.setTitle("+ Follow", for: .normal)
            cell.followBtn.layer.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
            print("+ Follow")
        }
//
        let popOverVC = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "secondPullVC") as! secondPullVC
        self.addChildViewController(popOverVC)
        if chindViewIsHidden{
            popOverVC.url = NSURL(string: "rtmp://live.hkstv.hk.lxdns.com/live/hks")
            let rate = (popOverVC.view.frame.size.height / popOverVC.view.frame.size.width)
            popOverVC.view.frame.size.width = cell.childView.frame.width
            popOverVC.view.frame.size.height = (popOverVC.view.frame.size.width * rate)
            popOverVC.view.center = cell.childView.center
            popOverVC.player.view.frame = popOverVC.view.frame
            cell.addSubview(popOverVC.player.view)
            cell.addSubview(popOverVC.view)
            chindViewIsHidden = !chindViewIsHidden
        }else{
            cell.subviews.last?.removeFromSuperview()
            cell.subviews.last?.removeFromSuperview()
            self.childViewControllers.last?.removeFromParentViewController()
            chindViewIsHidden = !chindViewIsHidden
        }
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    
    @objc func doGift(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
        let cell = tableView.cellForRow(at: indexPath!) as! PullVideoTableViewCell
        
        let popOverVC = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "giftBtnVC") as! giftBtnVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)

        
    }
    
    @objc func doShare(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
        let cell = tableView.cellForRow(at: indexPath!) as! PullVideoTableViewCell
        
        let popOverVC = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "shareBtnVC") as! shareBtnVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
    }
    
    @objc func doAdd(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
        let cell = tableView.cellForRow(at: indexPath!) as! PullVideoTableViewCell
        let popOverVC = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "addBtnVC") as! addBtnVC
        //////
        popOverVC.cell = cell
        popOverVC.controller = self
        /////
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        /////////
        
//        addSubview(cell: cell)
        
    }
    
    @objc func doUserEarn(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
//        let cell = tableView.cellForRow(at: indexPath!) as! PullVideoTableViewCell
        
    }

    func addSubview(cell: PullVideoTableViewCell) {
                let popOverVC = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "secondPullVC") as! secondPullVC
                self.addChildViewController(popOverVC)
                if chindViewIsHidden{
                    popOverVC.url = NSURL(string: "rtmp://live.hkstv.hk.lxdns.com/live/hks")
                    let rate = (popOverVC.view.frame.size.height / popOverVC.view.frame.size.width)
                    popOverVC.view.frame.size.width = cell.childView.frame.width
                    popOverVC.view.frame.size.height = (popOverVC.view.frame.size.width * rate)
                    popOverVC.view.center = cell.childView.center
                    popOverVC.player.view.frame = popOverVC.view.frame
                    cell.addSubview(popOverVC.player.view)
                    cell.addSubview(popOverVC.view)
                    chindViewIsHidden = !chindViewIsHidden
                }else{
                    cell.subviews.last?.removeFromSuperview()
                    cell.subviews.last?.removeFromSuperview()
                    self.childViewControllers.last?.removeFromParentViewController()
                    chindViewIsHidden = !chindViewIsHidden
                }
                popOverVC.didMove(toParentViewController: self)
    }
    
    
    func testfunc() {
        print("111")
    }
    
}

