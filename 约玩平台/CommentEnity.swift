//
//  CommentEnity.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/25.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation

class CommentEnity
{
    var id: Int
    var creator: UserInformationEnity
    var content: String
    var parent: Int
    var attachType: String
    var attachId: Int
    var creatAt: Int
    
    
    
    init(id: Int,creator: UserInformationEnity,content: String,parent: Int,attachType: String,attachId: Int,creatAt: Int) {
        self.id = id
        self.creator = creator
        self.content = content
        self.parent = parent
        self.attachType = attachType
        self.attachId = attachId
        self.creatAt = creatAt
    }

}
