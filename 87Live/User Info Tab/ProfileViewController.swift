//
//  ProfileViewController.swift
//  87Live
//
//  Created by 黃恩祐 on 2017/11/12.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var collectView: UICollectionView!
    // MARK: - Properties
    
    var user: User!
    var posts = [Post]()
    
    var profileHandle: DatabaseHandle = 0
    var profileRef: DatabaseReference?
    
    var controller: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        user = user ?? User.current
        navigationItem.title = user.username
        
        profileHandle = UserService.observeProfile(for: user) { [unowned self] (ref, user, posts) in
            self.profileRef = ref
            self.user = user
            self.posts = posts
            
            DispatchQueue.main.async {
                self.collectView.reloadData()
            }
        }
        
        
    }
    
    deinit {
        profileRef?.removeObserver(withHandle: profileHandle)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostThumbImageCell
        cell.backgroundColor = .red
        let popOverVC = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "userInfoMain") as! userInfoTimeLineViewController
        self.addChildViewController(popOverVC)
        self.controller = popOverVC
        popOverVC.view.frame = UIScreen.main.bounds
        cell.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectView.frame.width, height: self.view.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileHeaderView
        
        let postCount = user.postCount ?? 0
        headerView.levelBtn.setTitle("\(postCount)\nLevel", for: .normal)
        
        let followerCount = user.followerCount ?? 0
        headerView.followerBtn.setTitle("\(followerCount)\nFollowers", for: .normal)
        
        let followingCount = user.followingCount ?? 0
        headerView.followingBtn.setTitle("\(followingCount)\nFollowing", for: .normal)
        
        return headerView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: self.collectView.frame.width, height: self.collectView.frame.height / 3.4)
    }
    

    
}


