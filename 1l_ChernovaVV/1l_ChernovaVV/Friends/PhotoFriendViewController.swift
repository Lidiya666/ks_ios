//
//  PhotoFriendViewController.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 09/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit

class PhotoFriendViewController: UIViewController {
    
    var friendNames = [String]()
    var qtyLikes = 783
    
    var photoFriends = [Friend(image: "001", name: "Иван Андреич"),
                        Friend(image: "002", name: "Ульяна Байбак"),
                        Friend(image: "006", name: "Ульяна Байбак"),
                        Friend(image: "003", name: "Злобный Боря"),
                        Friend(image: "004", name: "Макс Голодный"),
                        Friend(image: "005", name: "Аня Джулай")]
    var photosFriend = [Friend]()
    

    @IBOutlet weak var photoFriend: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoFriend.dataSource = self 
        
        for i in 0...photoFriends.count - 1 {
            if photoFriends[i].name == friendNames[0] {
                photosFriend.append(photoFriends[i])
            }
        }
        
        let width = view.frame.width
        let layout = photoFriend.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
}

extension PhotoFriendViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFriend.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoFriendCell", for: indexPath) as! PhotoFriendCollectionViewCell
        
        cell.photoFriend.image = UIImage(named: photosFriend[indexPath.row].image)
        cell.photoFriend.contentMode = .scaleAspectFit
        
        cell.qtyLike.text = "\(qtyLikes)"
        cell.qtyLike.textColor = #colorLiteral(red: 0.4056248963, green: 0.4397159219, blue: 0.4782559872, alpha: 1)
        
        let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        cell.likeButton.setImage(image, for: .normal)
        cell.likeButton.tintColor = #colorLiteral(red: 0.75742203, green: 0.7766188383, blue: 0.8110727072, alpha: 1)
        
        return cell
    }
}
