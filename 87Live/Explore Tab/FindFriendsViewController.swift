//
//  FindFriendsViewController.swift
//  MyChatApp
//
//  Created by 黃恩祐 on 2017/10/16.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FindFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Show")
    }
    
    @IBOutlet weak var tableView: UITableView!
    var users = [User]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! findFriendsTableViewCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func configure(cell: findFriendsTableViewCell, atIndexPath indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        cell.userNameLabel.text = user.username
        cell.followBtn.isSelected = user.isFollowed
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.users = users
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
    }

}

extension FindFriendsViewController: FindFriendsCellDelegate {
    func didTapFollowButton(_ followButton: UIButton, on cell: findFriendsTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        followButton.isUserInteractionEnabled = false
        let followee = users[indexPath.row]
        
        FollowService.setIsFollowing(!followee.isFollowed, fromCurrentUserTo: followee) { (success) in
            defer {
                followButton.isUserInteractionEnabled = true
            }
            
            guard success else { return }
            
            followee.isFollowed = !followee.isFollowed
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
