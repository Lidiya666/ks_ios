//
//  PhotoFriendCollectionViewCell.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 09/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit

class PhotoFriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoFriend: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var qtyLike: UITextField!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeChanged(_ sender: Any) {
        guard let qtyLikes = qtyLike.text, var value = Int(qtyLikes) else {
            // report error and then 'return'
            return
        }
        
        var valColor = UIColor()
        
        likeButton.tintColor = likeButton.tintColor == #colorLiteral(red: 1, green: 0.199475348, blue: 0.2767442465, alpha: 1) ? #colorLiteral(red: 0.75742203, green: 0.7766188383, blue: 0.8110727072, alpha: 1) : #colorLiteral(red: 1, green: 0.199475348, blue: 0.2767442465, alpha: 1)
        if(likeButton.tintColor == #colorLiteral(red: 1, green: 0.199475348, blue: 0.2767442465, alpha: 1)) {
            value = value + 1
            valColor = #colorLiteral(red: 1, green: 0.199475348, blue: 0.2767442465, alpha: 1)
        } else {
            value = value - 1
            valColor = #colorLiteral(red: 0.4056248963, green: 0.4397159219, blue: 0.4782559872, alpha: 1)
        }
        qtyLike.fadeTransition(0.4)
        qtyLike.textColor = valColor
        qtyLike.text = String(value)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        photoFriend.addGestureRecognizer(tap)
        
    }
    
    @objc func tapped() {
        
        let animated = CASpringAnimation(keyPath: "bounds")
        animated.fromValue = self.photoFriend.bounds
        let width = self.photoFriend.bounds.width
        let height = self.photoFriend.bounds.height
        animated.toValue = CGRect(x: 0, y: 0, width: width - 5, height: height - 5)
        animated.damping = 0
        animated.initialVelocity = 5
        animated.stiffness = 1000
        animated.mass = 2
        animated.duration = 0.5
        self.photoFriend.layer.add(animated, forKey: nil)
        
    }
    
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
