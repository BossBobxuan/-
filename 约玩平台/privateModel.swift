//
//  privateModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/12.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class privates {
    var targetId: Int
    var avatar: Int
    var recent: PrivateEnity
    var privateCount: Int
    var privateTotalCount: Int
    init(targetId: Int,avatar: Int,recent: PrivateEnity,privateCount: Int,privateTotalCount: Int) {
        self.targetId = targetId
        self.avatar = avatar
        self.recent = recent
        self.privateCount = privateCount
        self.privateTotalCount = privateTotalCount
    }
}






class privateModel {
    var Enitys: [privates] = []
    weak var delegate: PullDataDelegate!
    let manager: AFHTTPSessionManager = AFHTTPSessionManager()
    var page = 1
    init(delegate: PullDataDelegate) {
        self.delegate = delegate
    }
    
    func getMessageList(token: String) -> Void {
        let requestUrl = urlStruct.basicUrl + "msg/private.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page": page], progress: {(progress) in}, success: {(dataTask,response) in
            self.dealWithResponse(response: response)
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
            
        })
        page += 1
    }
    
    func freshMessageList(token: String)
    {
        page = 1
        let requestUrl = urlStruct.basicUrl + "msg/private.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page": page], progress: {(progress) in}, success: {(dataTask,response) in
            self.Enitys = []
            self.dealWithResponse(response: response)
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
            
        })
        page += 1
    }
    
    
    private func dealWithResponse(response: Any?)
    {
        if let JsonDic = response as? NSDictionary
        {
            if let JsonArray = JsonDic["privates"] as? NSArray
            {
                for element in JsonArray
                {
                    let Dic = element as! NSDictionary
                    let object = Dic["recent"] as! NSDictionary
                    let privateEnity = PrivateEnity(direction: object["direction"] as! String, content: object["content"] as! String, creatAt: object["created_at"] as! Int)
                    let enity = privates(targetId: Dic["target_id"] as! Int, avatar: Dic["avatar"] as! Int, recent: privateEnity , privateCount: Dic["private_count"] as! Int , privateTotalCount: Dic["private_total_count"] as! Int)
                    Enitys.append(enity)
                }
                self.delegate.needUpdateUI()
            }
        }
    }
    
    
    
    
    
}
