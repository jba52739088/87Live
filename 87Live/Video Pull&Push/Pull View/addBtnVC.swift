//
//  addBtnVC.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/11/2.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class addBtnVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var doAddView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var CancelBtn: UIButton!
    @IBOutlet weak var doTapView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userValue = [Dictionary<String, Any>]()
    var cell: PullVideoTableViewCell?
    var controller: PullVideoTableViewController?
    var selectedNum: Int!


    override func viewDidLoad() {
        super.viewDidLoad()
        userValue = fakeUser.fakeArray as! [Dictionary<String, Any>]
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        showAnimate()
        self.doTapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quit)))
    }
    
    @objc func quit() {
        self.removeAnimate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeUser.fakeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addBtnCell
        setCellInfo(cell, indexPath.row, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("=====didselect=====")
//        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pullPage") as? PullVideoTableViewController {
            self.addSubview(controller: self.controller!, cell: self.cell!)
            controller!.testfunc()
            print("OKOKOKOKOKOK")
            self.removeAnimate()
//        }
    }
    
    func showAnimate()
    {
        self.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1.0
            self.view.frame.origin.y = self.view.frame.origin.y - self.view.frame.height
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func doCancel(_ sender: Any) {
    }
    
    func setCellInfo(_ cell: addBtnCell, _ indexPath: Int, _ IndexPath: IndexPath) {
        
        let value = userValue[indexPath] as NSDictionary
        appDelegate.selectedNum = indexPath
        
        let userName = value.object(forKey: "userName")
        let viewerCount = value.object(forKey: "userViewers")
        let userImage = value.object(forKey: "userImage")
        
        cell.userImage.image = UIImage(named: "\(userImage!)")
        cell.userName.text = "\(userName!)"
        cell.userMessage.text = "I have \(viewerCount!) viewers"
        
    }
    var subCell: PullVideoTableViewCell?
    var subController : PullVideoTableViewController?
    
    func addSubview(controller: PullVideoTableViewController, cell: PullVideoTableViewCell) {
        let popOverVC = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "secondPullVC") as! secondPullVC
        subCell = cell
        subController = controller
        controller.addChildViewController(popOverVC)

        
        if controller.chindViewIsHidden{
            
            popOverVC.url = NSURL(string: "rtmp://live.hkstv.hk.lxdns.com/live/hks")
            let rate = (popOverVC.view.frame.size.height / popOverVC.view.frame.size.width)
            popOverVC.view.frame.size.width = cell.childView.frame.width
            popOverVC.view.frame.size.height = (popOverVC.view.frame.size.width * rate)
            popOverVC.view.center = cell.childView.center
            popOverVC.player.view.frame = popOverVC.view.frame
            popOverVC.view.tag = 100
            popOverVC.player.view.tag = 101
            cell.addSubview(popOverVC.player.view)
            cell.addSubview(popOverVC.view)
            controller.chindViewIsHidden = !(controller.chindViewIsHidden)
        }else{
            if let viewWithTag = subCell!.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag = subCell!.viewWithTag(101) {
                viewWithTag.removeFromSuperview()
            }
            controller.childViewControllers.last?.removeFromParentViewController()
            controller.chindViewIsHidden = !(controller.chindViewIsHidden)
            addSubview(controller: controller, cell: cell)
        }
        popOverVC.didMove(toParentViewController: controller)
        
    }
}
