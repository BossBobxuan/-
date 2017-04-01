//
//  NotificationEnity.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/1.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation

class NotificationEnity
{
    var id: Int
    var creator: UserInformationEnity
    var activityId: Int
    var title: String
    var content: String
    var commentCount: Int
    var creatAt: Int//Unix时间戳
    
    
    init(id: Int,creator: UserInformationEnity,activityId: Int,title: String,content: String,commentCount: Int,creatAt: Int) {
        self.id = id
        self.creator = creator
        self.activityId = activityId
        self.title = title
        self.content = content
        self.commentCount = commentCount
        self.creatAt = creatAt
    }
}

