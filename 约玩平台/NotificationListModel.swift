//
//  NotificationListModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/1.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class NotificationListModel
{
    var notificationEnitys: [NotificationEnity] = []
    var delegate: PullDataDelegate
    init(delegate: PullDataDelegate) {
        self.delegate = delegate
    }
    var page = 1
    let manager = AFHTTPSessionManager()
    func getNotification(activityId: Int)
    {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityId)" + "/notification.json"
        
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            (dataTask,response) in
            self.dealwithResponse(response: response)
            
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
        
        
        page  += 1
    }
    
    func refreshNotification(activityId: Int)
    {
        page = 1
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityId)" + "/notification.json"
        
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            (dataTask,response) in
            self.notificationEnitys.removeAll()
            self.dealwithResponse(response: response)
            
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
        
        
        page  += 1
    }
    
    
    private func dealwithResponse(response: Any?)
    {
        if let original = response as? NSDictionary
        {
            if let notificationArray = original["notifications"] as? NSArray
            {
                for element in notificationArray
                {
                    if let NotificationJsonDictionary = element as? NSDictionary
                    {
                        if let userJsonDictionary = NotificationJsonDictionary["creator_obj"] as? NSDictionary
                        {
                            let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                            
                            let notificationEnity = NotificationEnity(id: NotificationJsonDictionary["id"] as! Int, creator: userInformationEnity, activityId: NotificationJsonDictionary["activity_id"] as! Int, title: NotificationJsonDictionary["title"] as! String, content: NotificationJsonDictionary["content"] as! String, commentCount: NotificationJsonDictionary["comment_count"] as! Int, creatAt: NotificationJsonDictionary["created_at"] as! Int)
                            notificationEnitys.append(notificationEnity)
                        }
                    }

                }
                self.delegate.needUpdateUI()
            }
        }
    }
    
    
    
    
    
    
}


