//
//  FriendListTableViewCell.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 08/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet weak var FriendName: UILabel!
    @IBOutlet weak var photoFriendMini: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        photoFriendMini.layer.cornerRadius = photoFriendMini.bounds.height / 2
        photoFriendMini.clipsToBounds = true
        photoFriendMini.layer.borderWidth = 1.0
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        photoFriendMini.addShadowView()
    }
}

extension UIView {
    
    func addShadowView() {
        //Create new shadow view with frame
        let imageSize: (height: CGFloat, width: CGFloat) = (60.0, 60.0)
        let shadowView = UIView(frame: CGRect(x: 5, y: 5, width: imageSize.width - 6, height: imageSize.height - 9))
        let cornerRadius: CGFloat = 35.0
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowOpacity = 0.9
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cornerRadius).cgPath
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        
        superview?.insertSubview(shadowView, belowSubview: self)
    }
    
}
