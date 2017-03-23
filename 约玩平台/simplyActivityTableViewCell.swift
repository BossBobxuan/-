//
//  simplyActivityTableViewCell.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/23.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class simplyActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var activityImageView: UIImageView!

    @IBOutlet weak var activityTitleLabel: UILabel!
  
    @IBOutlet weak var activityStateLabel: UILabel!
    @IBOutlet weak var activityBeginTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
