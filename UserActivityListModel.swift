//
//  UserActivityListModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/22.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
protocol getUserActivityDelegate:AnyObject {
    
    func getActivitySuccess() -> Void
    func getActivityfailed() -> Void
    
}
struct ActivityRequestType
{
    static let participated: String = "participated"
    static let wished: String = "wished"
    static let created: String = "created"
}
class UserActivityListModel
{
    var activityEnitys: [String:[ActiveEnity]] = [ActivityRequestType.created:[],ActivityRequestType.participated:[],ActivityRequestType.wished:[]]
    weak var delegate: getUserActivityDelegate!
    let manager = singleClassManager.manager
    private var pageDic: [String: Int] = [ActivityRequestType.created: 1,ActivityRequestType.wished: 1,ActivityRequestType.participated: 1]
    init(delegate: getUserActivityDelegate) {
        self.delegate = delegate
    }
    
    //用于加载更多与第一次拉取数据
    func getUserActivity(token: String,type: String)
    {
        let requestUrl = urlStruct.basicUrl + "user/~me/activity/" + type + ".json"
       
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page":pageDic[type]], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.dealwithResponse(response: response,type: type)
                
                
                
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getActivityfailed()
                
        })

        
        pageDic[type]!  += 1
    }
    func getUserActivity(activityId: Int,type: String)
    {
        let requestUrl = urlStruct.basicUrl + "user/" + "\(activityId)" + "/activity/" + type + ".json"
        manager.get(requestUrl, parameters: ["page":pageDic[type]], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.dealwithResponse(response: response,type: type)
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getActivityfailed()
            
        })
        
        
        pageDic[type]!  += 1
    }
    
    
    //用于下拉刷新数据
    func refreshUserActivity(token: String,type: String)
    {
        let requestUrl = urlStruct.basicUrl + "user/~me/activity/" + type + ".json"
        pageDic[type]!  = 1
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page":pageDic[type]], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.activityEnitys[type]?.removeAll()
            self?.dealwithResponse(response: response,type: type)
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getActivityfailed()
            
        })
        pageDic[type]! += 1
        
        
    }
    
    func refreshUserActivity(activityId: Int,type: String)
    {
        let requestUrl = urlStruct.basicUrl + "user/" + "\(activityId)" + "/activity/" + type + ".json"
        pageDic[type]!  = 1
        
        manager.get(requestUrl, parameters: ["page":pageDic[type]], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.activityEnitys[type]?.removeAll()
            self?.dealwithResponse(response: response,type: type)
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getActivityfailed()
            
        })
        pageDic[type]! += 1
        
        
    }
    
    
    
    func dealwithResponse(response: Any,type: String)
    {
        if let originalDic = response as? NSDictionary
        {
            if let ActivityArray = originalDic["activities"] as? NSArray
            {
                for activity in ActivityArray
                {
                    if let ActivityJsonDictionary = activity as? NSDictionary
                    {
                        if let userJsonDictionary = ActivityJsonDictionary["creator_obj"] as? NSDictionary
                        {
                            let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                            
                            let activityEnity = ActiveEnity(id: ActivityJsonDictionary["id"] as! Int, activityTitle: ActivityJsonDictionary["title"] as! String, image: ActivityJsonDictionary["image"] as! Int, state: ActivityJsonDictionary["state"] as! String, wisherCount: ActivityJsonDictionary["wisher_count"] as! Int, wisherTotal: ActivityJsonDictionary["wisher_total"] as! Int, participantCount: ActivityJsonDictionary["participant_count"] as! Int, creator: userInformationEnity, beginTime: ActivityJsonDictionary["beginTime"] as! Int, endTime: ActivityJsonDictionary["endTime"] as! Int, address: ActivityJsonDictionary["address"] as! String, latitude: (ActivityJsonDictionary["location"] as! NSDictionary)["latitude"] as! Double, longitude: (ActivityJsonDictionary["location"] as! NSDictionary)["longitude"] as! Double, fee: ActivityJsonDictionary["fee"] as! Int, category: ActivityJsonDictionary["category"] as! String, tags: ActivityJsonDictionary["tags"] as! NSArray, content: ActivityJsonDictionary["content"] as! String, notificationCount: ActivityJsonDictionary["notification_count"] as! Int, photoCount: ActivityJsonDictionary["photo_count"] as! Int, creatAt: ActivityJsonDictionary["created_at"] as! Int,commentCount: ActivityJsonDictionary["comment_count"] as! Int)
                            activityEnitys[type]?.append(activityEnity)
                        }
                    }
                }
                self.delegate.getActivitySuccess()
                
            }
        }
        else
        {
            self.delegate.getActivityfailed()
        }
    }
    
    
    
    
    
}
