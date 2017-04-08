//
//  PhotoEnity.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/8.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class PhotoEnity {
    var id: Int
    var creator: UserInformationEnity
    var activityId: Int
    var mediaId: Int
    var description: String?
    var creatAt: Int
    var commentCount: Int
    init(id: Int, creator: UserInformationEnity, activityId: Int, mediaId: Int,description: String?,creatAt: Int,commentCount: Int) {
        self.id = id
        self.creator = creator
        self.activityId = activityId
        self.mediaId = mediaId
        self.description = description
        self.creatAt = creatAt
        self.commentCount = commentCount
    }
}
