//
//  ActivityDetailModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/23.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation

class ActivityDetailModel {
    var activityEnity: ActiveEnity!
    let manager = AFHTTPSessionManager()
    var delegate: PullDataDelegate!
    
   
    func interestActivity(token: String)
    {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityEnity.id)/" + "wisher.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.post(requestUrl, parameters: [], progress: {(progress) in }, success: {
            (dataTask,response) in
            print("success")
            self.delegate.needUpdateUI()
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
    }
    
    func uninterestActivity(token: String)
    {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityEnity.id)/" + "wisher.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.delete(requestUrl, parameters: [],  success: {
            (dataTask,response) in
            self.delegate.needUpdateUI()
            
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
    }
}
