//
//  test1ViewController.swift
//  MyChangePageCollectView
//
//  Created by 黃恩祐 on 2017/10/17.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Kingfisher

class followItemViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    var posts = [Post]()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Follow")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.isHidden = true
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
        reloadTimeline()
        
    }
    
    @objc func reloadTimeline() {
        
        UserService.timeline { (posts) in
            self.posts = posts
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            self.tableView.reloadData()
            self.tableView.separatorStyle = .singleLine
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let post = posts[indexPath.section]
        
            let dataDic = fakeTimeLine.fakeUser2Dic as NSDictionary
            let timeline = dataDic["userTimeLine"] as! NSArray
            let messages = timeline[4 - indexPath.section] as! NSDictionary
            
            switch indexPath.row {
                
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! timeLineImageCell
                let imageURL = URL(string: post.imageURL)
                cell.timeLineImage.kf.setImage(with: imageURL)
                cell.userNameLabel.text = post.poster.username
                cell.timeLabel.text = timestampFormatter.string(from: post.creationDate)
                let userPhoto = dataDic["userImage"] as! NSString
                cell.userPhoto.image = UIImage(named: "\(userPhoto)")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! timeLineMessageCell
                cell.textView.text = post.userMessage
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell") as! timeLineActionCell
                let comCounter = messages["comments"] as! NSArray
                cell.likeLabel.text = "\(post.likeCount) Likes"
                cell.likeBtn.isSelected = post.isLiked
                cell.commentLabel.text = "\(comCounter.count) Comments"
//                cell.commentLabel.text = "\(post.commentCount) Comments"
                cell.commentBtn.tag = indexPath.row
//                cell.commentBtn.isSelected = post.isComment
                cell.selectionStyle = .none
                cell.delegate = self
                let image = UIImage(named: "like-2")
                let image2 = UIImage(named: "like")
                
                cell.likeBtn.setImage(image, for: .normal)
                cell.likeBtn.setImage(image2, for: .selected)
                cell.likeBtn.setTitle("", for: .normal)
                configureCell(cell, with: post)
                return cell
            default:
                fatalError("Error: unexpected indexPath.")
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return (UIScreen.main.bounds.height * 2 / 3)
        case 1:
            return UITableViewAutomaticDimension
        case 2:
            return (UIScreen.main.bounds.height * 0.13)
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fakeUser.timelineTag = indexPath.section
        if indexPath.row == 2{
            if let resultController = storyboard!.instantiateViewController(withIdentifier: "commentPage") as? timelineCommentVC {
                let navController = UINavigationController(rootViewController: resultController)
                self.present(navController, animated:true, completion: nil)
            }
        }
    }
    

    
    ////////
    // convert a "Date" into a formatted string
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    func configureCell(_ cell: timeLineActionCell, with post: Post) {
        cell.likeBtn.isSelected = post.isLiked
        cell.likeLabel.text = "\(post.likeCount) likes"
//        cell.commentLabel.text = "\(post.commentCount) Comments"
    }



}

extension followItemViewController: PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: timeLineActionCell) {
        // 1
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        // 2
        likeButton.isUserInteractionEnabled = false
        // 3
        let post = posts[indexPath.section]
        
        // 4
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            // 5
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            // 6
            guard success else { return }
            
            // 7
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            
            // 8
            guard let cell = self.tableView.cellForRow(at: indexPath) as? timeLineActionCell
                else { return }
            
            // 9
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }

    func didTapCommentButton(_ commentButton: UIButton, on cell: timeLineActionCell) {
//        // 1
//        guard let indexPath = tableView.indexPath(for: cell)
//            else { return }
//
//        // 2
//        commentButton.isUserInteractionEnabled = false
//        // 3
//        let post = posts[indexPath.section]
//
//        // 4
//        commentService.setIscommented(!post.isComment, for: post) { (success) in
//            // 5
//            defer {
//                commentButton.isUserInteractionEnabled = true
//            }
//
//            // 6
//            guard success else { return }
//
//            // 7
//            post.commentCount += !post.isComment ? 1 : -1
//            post.isComment = !post.isComment
//
//            // 8
//            guard let cell = self.tableView.cellForRow(at: indexPath) as? timeLineActionCell
//                else { return }
//
//            // 9
//            DispatchQueue.main.async {
//                self.configureCell(cell, with: post)
//            }
//        }
    }

}

