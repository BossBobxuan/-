//
//  recommendUserView.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/23.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class recommendUserView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var avatarImageView: UIImageView!
    var nameLabel: UILabel!
    var relationButton: UIButton!
   
    init(x: CGFloat,y: CGFloat)
    {
        super.init(frame: CGRect(x: x, y: y, width: 80 , height: 120))
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 0.5
        avatarImageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 60, height: 60))
        avatarImageView.layer.borderWidth = 0.5
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        nameLabel = UILabel(frame: CGRect(x: 10, y: avatarImageView.frame.height + 5, width: 60, height: 20))
        nameLabel.textAlignment = .center
        relationButton = UIButton(type: .system)
        relationButton.frame = CGRect(x: 10, y: 90, width: 60, height: 20)
        
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(relationButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
