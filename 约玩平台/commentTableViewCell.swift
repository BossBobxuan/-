//
//  commentTableViewCell.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/25.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class commentTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var creatAtLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
