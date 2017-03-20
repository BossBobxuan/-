//
//  getTokenProtocal.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/20.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
protocol getTokenProtocol {
    //var token: String{get}
   
}
extension getTokenProtocol
{
    var token: String
        {
        // 此处需要从UserDefault获取token
        return "222"
    }
}
