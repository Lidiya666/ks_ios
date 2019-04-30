//
//  NewsListTableViewCell.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 19/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var photoFriend: UIImageView!
    @IBOutlet weak var nameFriend: UILabel!
    @IBOutlet weak var dateNews: UILabel!
    @IBOutlet weak var textNewsFriend: UITextField!
    @IBOutlet weak var photoNewsFriend: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeNum: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentNum: UITextField!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var repostNum: UITextField!
    @IBOutlet weak var viewImg: UIImageView!
    @IBOutlet weak var viewNum: UITextField!
    
    @IBAction func likeChanged(_ sender: Any) {
        guard let qtyLikes = likeNum.text, var value = Int(qtyLikes) else {
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
        
        likeNum.fadeTransition(0.4)
        likeNum.textColor = valColor
        likeNum.text = String(value)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
