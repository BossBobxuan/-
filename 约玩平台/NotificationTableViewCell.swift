//
//  NotificationTableViewCell.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/1.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationContentTextView: UITextView!
    @IBOutlet weak var creatAtLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
