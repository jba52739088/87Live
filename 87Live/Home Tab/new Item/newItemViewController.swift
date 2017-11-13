//
//  newItemViewController.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/18.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class newItemViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var menuView: UICollectionView!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "New")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(fakeUser.fakeArray.count)
        return fakeUser.fakeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! newCellCollectionViewCell
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let color4 = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: cell.bounds.maxY / 2, width: cell.frame.width, height: cell.frame.height / 2)
        gradient.colors = [color1.cgColor, color4.cgColor]
        var newValue = fakeUser.fakeArray.sorted(by: { (dictionary1, dictionary2) -> Bool in
            return Int(dictionary1["userVisitor"] as! Int) > Int(dictionary2["userVisitor"] as! Int)
        })
        let value = newValue[indexPath.row] as NSDictionary
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = CGFloat((menuView.frame.size.width / 2) - 16 )
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getUrl.itemID = indexPath.row
        if let pullPage = storyboard?.instantiateViewController(withIdentifier: "pullPage") {
            show(pullPage, sender: self)
        }
    }
}
