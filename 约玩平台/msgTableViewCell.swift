//
//  msgTableViewCell.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/12.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class msgTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var creatAtLabel: UILabel!
    @IBOutlet weak var notReadCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.layer.cornerRadius = 30
        avatarImageView.layer.masksToBounds = true
        notReadCountLabel.layer.masksToBounds = true
        notReadCountLabel.layer.cornerRadius = 10
        notReadCountLabel.backgroundColor = UIColor.red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
