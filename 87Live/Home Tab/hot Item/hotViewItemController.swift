//
//  test2ViewController.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/17.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDCycleScrollView
//import QuartzCore
import Alamofire

class hotItemViewController: UIViewController,  IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    ///
    let adImage = ["ad1", "ad2", "ad3"]
    ///
    @IBOutlet weak var menuView: UICollectionView!
    var client = PomeloClient.init(delegate:self)
    var rtmpSid = ""
    var dicts:Array<NSDictionary> = []
    var gotPullUrl = ""
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Hot")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        self.getPullUrl()
        menuView.addSubview(refreshControl)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(fakeUser.fakeArray.count)
        return fakeUser.fakeArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let adcell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADcell", for: indexPath) as! hotCellCollectionViewCell
            
            let adWidth = adcell.bounds.size.width
            let adHeight = (self.menuView.frame.size.width / 2) - 16
            let cycleScrollView = SDCycleScrollView(frame: CGRect(x:0, y: 0, width: adWidth, height: adHeight), imageNamesGroup: adImage)
            cycleScrollView?.showPageControl = false
            cycleScrollView?.autoScrollTimeInterval = 3
            adcell.addSubview(cycleScrollView!)
            return adcell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! hotCellCollectionViewCell
            let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            let color4 = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: cell.bounds.maxY / 2, width: cell.frame.width, height: cell.frame.height / 2)
            gradient.colors = [color1.cgColor, color4.cgColor]
            var hotValue = fakeUser.fakeArray.sorted(by: { (dictionary1, dictionary2) -> Bool in
                return Int(dictionary1["userViewers"] as! Int) > Int(dictionary2["userViewers"] as! Int)
            })
            let value = hotValue[indexPath.row - 1] as NSDictionary
            let userName = value.object(forKey: "userName")
            let visitorCount = value.object(forKey: "userVisitor")
            let userImage = value.object(forKey: "userImage")
            let userLocation = value.object(forKey: "userLocation")
            cell.userPhoto.image = UIImage(named: "\(userImage!)")
            cell.userPhoto.layer.insertSublayer(gradient, at: 0)
            cell.visitorLabel.text = "  \(visitorCount!)  "
            cell.visitorLabel.backgroundColor = UIColor.clear
            cell.visitorLabel.layer.backgroundColor = UIColor.white.cgColor
            cell.visitorLabel.layer.cornerRadius = 9
            cell.userNameLabel.text = "\(userName!)"
            cell.userLocationLabel.text = "\(userLocation!)"
            if cell.userPhoto.layer.sublayers!.count > 1{
                cell.userPhoto.layer.sublayers?.remove(at: 1)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let adcellWidth = CGFloat((menuView.frame.size.width) - 16 )
            let adcellHeight = CGFloat((menuView.frame.size.width / 2) - 16 )
            let adcellSize = CGSize(width: adcellWidth, height: adcellHeight)
            return adcellSize
        }else{
            let cellWidth = CGFloat((menuView.frame.size.width / 2) - 16 )
            let cellSize = CGSize(width: cellWidth, height: cellWidth)
            return cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getUrl.itemID = indexPath.row
        if let pullPage = storyboard?.instantiateViewController(withIdentifier: "pullPage") {
            show(pullPage, sender: self)
        }
    }
    
    @objc func pullToRefresh(_ refreshControl: UIRefreshControl) {
        let fakeArray2 = fakeUser.setFakeUser(18)
        fakeUser.fakeArray = fakeArray2
        menuView.reloadData()
        getPullUrl()
        refreshControl.endRefreshing()
    }
    
    func getPullUrl(){
        let parameters = [
            "username":"iii002",
            "password":"qwerty123"]
        Alamofire.request("http://35.194.139.26/ci/index.php/StreamDemo/ViewerLogin", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("=============ViewerLogin================")
                if let JSON = response.result.value as? [String:AnyObject] {
                    self.rtmpSid = (JSON["message"]!["sid"]!)! as! String
                }
                print(self.rtmpSid)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                }
                self.getRtmp()
        }
    }
    
    func getRtmp() {
        let parameters = ["sid":"\(self.rtmpSid)"]
        Alamofire.request("http://35.194.139.26/ci/index.php/StreamDemo/GetStreamList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("=============GetStreamList================")
                if let JSON = response.result.value as? [String:AnyObject] {
                    self.dicts = (JSON["streams"]! as! [NSDictionary])
                }
                let counter = self.dicts.count - 1
                print(counter)
                for i in 0...counter{
                    let ItemInDicts = self.dicts[i]
                    let app = ItemInDicts["app"] as! String
                    if app == "iii002" {
                        self.gotPullUrl = ItemInDicts["rtmp_url"]! as! String
                        getUrl.videoView[0] = ItemInDicts["rtmp_url"]! as! String
                        print(self.gotPullUrl)
                    }}}
    }
}

