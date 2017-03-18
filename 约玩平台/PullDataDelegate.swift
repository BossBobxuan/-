//
//  PullDataDelegate.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/18.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
protocol PullDataDelegate {
    func needUpdateUI() -> Void
    func getDataFailed() -> Void
}
