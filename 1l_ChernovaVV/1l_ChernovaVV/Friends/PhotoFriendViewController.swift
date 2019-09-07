//
//  PhotoFriendViewController.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 09/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct UserVk {
    let first_name: String
    let id: Int
    let last_name: String
    //let online: Int
    let photo_max: String
    
    init(_ json: JSON) {
        self.first_name = json["first_name"].stringValue
        self.id = json["id"].intValue
        self.last_name = json["last_name"].stringValue
        // self.online = json["online"].intValue
        self.photo_max = json["photo_max"].stringValue
    }
    
}

class PhotoFriendViewController: UIViewController {
    
    var friendId = Int()
    var qtyLikes = 783
    let getPhoto = VkService()
    var url = String()
    
    var userVk = [UserVk]()
    

    @IBOutlet weak var photoFriend: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoFriend.dataSource = self
        
        getPhoto.loadUserVkData(path: "/method/users.get", fields: "photo_max", user_id: friendId) { [weak self] users in
            self?.userVk = users
            self?.url = String(describing: self!.userVk[0].photo_max)
        self?.photoFriend.reloadData()
        }
        
        
        let width = view.frame.width
        let layout = photoFriend.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
}

extension PhotoFriendViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1//photosFriend.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoFriendCell", for: indexPath) as! PhotoFriendCollectionViewCell

        let urlMod = URL(string: url)
        cell.photoFriend.kf.setImage(with: urlMod)
        cell.photoFriend.contentMode = .scaleAspectFit
        
        cell.qtyLike.text = "\(qtyLikes)"
        cell.qtyLike.textColor = #colorLiteral(red: 0.4056248963, green: 0.4397159219, blue: 0.4782559872, alpha: 1)
        
        let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        cell.likeButton.setImage(image, for: .normal)
        cell.likeButton.tintColor = #colorLiteral(red: 0.75742203, green: 0.7766188383, blue: 0.8110727072, alpha: 1)
        
        return cell
    }
}
