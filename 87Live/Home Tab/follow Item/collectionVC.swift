//
//  collectionVC.swift
//  87Live
//
//  Created by 黃恩祐 on 2017/11/12.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Kingfisher


class collectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "Follow")
    }

    @IBOutlet weak var collectView: UICollectionView!
    
    let refreshControl = UIRefreshControl()
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        collectView.addSubview(refreshControl)
        reloadTimeline()
    }

    @objc func reloadTimeline() {
        
        UserService.timeline { (posts) in
            self.posts = posts
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
                
            }
            self.collectView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.item]
        let cell = collectView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCell
        let imageURL = URL(string: post.imageURL)
        cell.imageView.kf.setImage(with: imageURL)
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectView.frame.size.width / 3) - 8
        return CGSize(width: width, height: width)
    }

}
