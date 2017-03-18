//
//  FollowersOrFansModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/18.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation

class FollowersOrFansModel
{
    var userInformationEnitys: [UserInfomationEnity] = []
    var delegate: PullDataDelegate
    var page: Int = 1
    var type: String
    init(delegate: PullDataDelegate,type: String) {
        self.delegate = delegate
        self.type = type
    }
    //用于第一次从服务器拉取
    func GetFollowersOrFansList(token: String) -> Void
    {
        let requestUrl = urlStruct.basicUrl + "user/~me/" + type + ".json"
        let manager = AFHTTPSessionManager()
        manager.get(requestUrl, parameters: ["token":token,"page":page], progress: {(progress) in }, success: {
            (dataTask,response) in
            self.dealwithResponse(response: response)
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
        page += 1
    }
    
    func GetFollowersOrFansList(uid: Int) -> Void
    {
        let requestUrl = urlStruct.basicUrl + "user/" + "\(uid)/" + type + ".json"
        let manager = AFHTTPSessionManager()
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            (dataTask,response) in
            self.dealwithResponse(response: response)
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
        page += 1
    }
    //用于下拉刷新获取数据
    func FreshFollowersOrFans(token: String) -> Void
    {
        page = 1
        userInformationEnitys = []
        let requestUrl = urlStruct.basicUrl + "user/~me/" + type + ".json"
        let manager = AFHTTPSessionManager()
        manager.get(requestUrl, parameters: ["token":token,"page":page], progress: {(progress) in }, success: {
            (dataTask,response) in
            self.dealwithResponse(response: response)
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
    }
    
    func FreshFollowersOrFans(uid: Int) -> Void
    {
        page = 1
        userInformationEnitys = []
        let requestUrl = urlStruct.basicUrl + "user/" + "\(uid)/" + type + ".json"
        let manager = AFHTTPSessionManager()
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            (dataTask,response) in
            self.dealwithResponse(response: response)
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
    }
    
    
    fileprivate func dealwithResponse(response: Any?) -> Void
    {
        
        if let Dictionary = response as? NSDictionary
        {
            if let followersArray = Dictionary[type + "s"] as? NSArray
            {
                for follower in followersArray
                {
                    if let JsonDictionary = follower as? NSDictionary
                    {
                        
                        let userInformationEnity = UserInfomationEnity(id: JsonDictionary["id"] as! Int, user: JsonDictionary["user"] as! String, name: JsonDictionary["name"] as! String, avatar: JsonDictionary["avatar"] as? Int, description: JsonDictionary["description"] as! String, followersCount: JsonDictionary["followers_count"] as! Int, fansCount: JsonDictionary["fans_count"] as! Int, activitiesCount: JsonDictionary["activities_count"] as! Int, relation: JsonDictionary["relation"] as! String)
                            userInformationEnitys.append(userInformationEnity)
                            
                    }
                    
                }
                self.delegate.needUpdateUI()
            }
            
        }
        else
        {
            self.delegate.getDataFailed()
        }
           
        
        
    }
    
}
