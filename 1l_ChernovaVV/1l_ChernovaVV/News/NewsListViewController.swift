//
//  NewsListViewController.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 19/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {
    
    var newsFriends = [News(friend: Friend(image: "01", name: "Иван Андреич"), date: "2 дек 2018", imageNews: "new01", textNews: "", qtyLike: "4", qtyComment: "", qtyShare: "", qtyView: "126"),
                       News(friend: Friend(image: "05", name: "Аня Джулай"), date: "28 фев 2016", imageNews: "new02", textNews: "💚☀ @ Москва", qtyLike: "11", qtyComment: "", qtyShare: "", qtyView: "")]
    
    struct News {
        var friend: Friend
        var date: String
        var imageNews: String
        var textNews: String
        var qtyLike: String
        var qtyComment: String
        var qtyShare: String
        var qtyView: String
    }
    
    struct Friend {
        var image: String
        var name: String
    }
    
    @IBOutlet weak var NewListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewListView.dataSource = self
    }

}

extension NewsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsListTableViewCell
        let value = newsFriends[indexPath.row]
        
        if value.textNews != "" {
            cell.textNewsFriend.text = value.textNews
        } else {
            cell.textNewsFriend.frame.size.height = 0
        }
        
        cell.photoFriend.image = UIImage(named: value.friend.image)
        cell.nameFriend.text = value.friend.name
        cell.dateNews.text = value.date
        
        if value.imageNews != "" {
            cell.photoNewsFriend.image = UIImage(named: value.imageNews)
            cell.photoNewsFriend.contentMode = .scaleAspectFit
            cell.photoNewsFriend.clipsToBounds = true
        } else {
            cell.photoNewsFriend.frame.size.height = 0
        }
        
        cell.likeButton.setImage(UIImage(named: "heart"), for: .normal)
        cell.likeButton.tintColor = #colorLiteral(red: 0.75742203, green: 0.7766188383, blue: 0.8110727072, alpha: 1)
        cell.likeNum.text = value.qtyLike
        cell.likeNum.textColor = #colorLiteral(red: 0.4056248963, green: 0.4397159219, blue: 0.4782559872, alpha: 1)
        
        cell.commentButton.setImage(UIImage(named: "comment"), for: .normal)
        cell.commentButton.tintColor = #colorLiteral(red: 0.75742203, green: 0.7766188383, blue: 0.8110727072, alpha: 1)
        cell.commentNum.text = value.qtyComment
        cell.commentNum.textColor = #colorLiteral(red: 0.4056248963, green: 0.4397159219, blue: 0.4782559872, alpha: 1)
        
        cell.repostButton.setImage(UIImage(named: "share"), for: .normal)
        cell.repostButton.tintColor = #colorLiteral(red: 0.75742203, green: 0.7766188383, blue: 0.8110727072, alpha: 1)
        cell.repostNum.text = value.qtyShare
        cell.repostNum.textColor = #colorLiteral(red: 0.4056248963, green: 0.4397159219, blue: 0.4782559872, alpha: 1)
        
        if value.qtyView != "" {
            let image = UIImage(named:"eye")?.withRenderingMode(.alwaysTemplate)
            cell.viewImg.tintColor = #colorLiteral(red: 0.75742203, green: 0.7766188383, blue: 0.8110727072, alpha: 1)
            cell.viewImg.image = image
            cell.viewNum.text = value.qtyView
            cell.viewNum.textColor = #colorLiteral(red: 0.4056248963, green: 0.4397159219, blue: 0.4782559872, alpha: 1)
        }
        
        return cell
    }
}
