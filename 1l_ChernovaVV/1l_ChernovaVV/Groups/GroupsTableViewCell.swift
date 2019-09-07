//
//  GroupsTableViewCell.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 09/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit
import Kingfisher

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with groupGetVk: GroupVk) {
        let name = groupGetVk.name
        groupName.text = String(name)
        
        let url = URL(string: groupGetVk.photo_100)
        groupPhoto.kf.setImage(with: url)
    }

}
