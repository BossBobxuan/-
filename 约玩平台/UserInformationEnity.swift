//
//  UserInformationEnity.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/16.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class UserInfomationEnity
{
    var id: Int
    var user: String
    var name: String
    var avatar: Int?
    var description: String
    var followersCount: Int
    var fansCount: Int
    var activitiesCount: Int
    var relation: String
    
    init(id: Int,user: String,name: String,avatar: Int?,description: String,followersCount: Int,fansCount: Int,activitiesCount: Int,relation: String)
    {
        self.id = id
        self.user = user
        self.name = name
        self.avatar = avatar
        self.description = description
        self.followersCount = followersCount
        self.fansCount = fansCount
        self.activitiesCount = activitiesCount
        self.relation = relation
    }
}
