//
//  ActivityDisplayTableViewCell.swift
//  约玩平台
//
//  Created by Bossxuan on 17/1/8.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class ActivityDisplayTableViewCell: UITableViewCell {
    @IBOutlet weak var ownernameLabel: UILabel!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var interestednumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
