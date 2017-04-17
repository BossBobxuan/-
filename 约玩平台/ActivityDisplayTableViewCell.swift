//
//  ActivityDisplayTableViewCell.swift
//  约玩平台
//
//  Created by Bossxuan on 17/1/8.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class ActivityDisplayTableViewCell: UITableViewCell {
    @IBOutlet weak var activityImageImageView: UIImageView!
    
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
