//
//  UserInformationEnity.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/16.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class UserInformationEnity
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
    var gender: String
    init(id: Int,user: String,name: String,avatar: Int?,description: String?,followersCount: Int,fansCount: Int,activitiesCount: Int,relation: String,gender: String)
    {
        self.id = id
        self.user = user
        self.name = name
        self.avatar = avatar
        if description != nil
        {
            self.description = description!
        }else
        {
            self.description = ""
        }
        self.followersCount = followersCount
        self.fansCount = fansCount
        self.activitiesCount = activitiesCount
        self.relation = relation
        self.gender = gender
    }
}
