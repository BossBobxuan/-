//
//  ActivityListModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/2.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class ActivityListModel
{
    var activeEnitys: [ActiveEnity] = []
    weak var delegate: PullDataDelegate!
    var page = 1
    let manager = singleClassManager.manager
    init(delegate: PullDataDelegate) {
        self.delegate = delegate
    }
    
    func getActivity()
    {
        let requestUrl = urlStruct.basicUrl + "recommend/activity/hot.json"
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.dealwithResponse(response: response)
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
        page += 1
    }
    
    func refreshActivity()
    {
        page = 1
        let requestUrl = urlStruct.basicUrl + "recommend/activity/hot.json"
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.activeEnitys.removeAll()
            self?.dealwithResponse(response: response)
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
        page += 1
    }
    
    private func dealwithResponse(response: Any?)
    {
        if let originalDic = response as? NSDictionary
        {
            if let ActivityArray = originalDic["recommend"] as? NSArray
            {
                for activity in ActivityArray
                {
                    if let ActivityJsonDictionary = activity as? NSDictionary
                    {
                        if let userJsonDictionary = ActivityJsonDictionary["creator_obj"] as? NSDictionary
                        {
                            let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                            
                            let activityEnity = ActiveEnity(id: ActivityJsonDictionary["id"] as! Int, activityTitle: ActivityJsonDictionary["title"] as! String, image: ActivityJsonDictionary["image"] as! Int, state: ActivityJsonDictionary["state"] as! String, wisherCount: ActivityJsonDictionary["wisher_count"] as! Int, wisherTotal: ActivityJsonDictionary["wisher_total"] as! Int, participantCount: ActivityJsonDictionary["participant_count"] as! Int, creator: userInformationEnity, beginTime: ActivityJsonDictionary["beginTime"] as! Int, endTime: ActivityJsonDictionary["endTime"] as! Int, address: ActivityJsonDictionary["address"] as! String, latitude: (ActivityJsonDictionary["location"] as! NSDictionary)["latitude"] as! Double, longitude: (ActivityJsonDictionary["location"] as! NSDictionary)["longitude"] as! Double, fee: ActivityJsonDictionary["fee"] as! Int, category: ActivityJsonDictionary["category"] as! String, tags: ActivityJsonDictionary["tags"] as! NSArray, content: ActivityJsonDictionary["content"] as! String, notificationCount: ActivityJsonDictionary["notification_count"] as! Int, photoCount: ActivityJsonDictionary["photo_count"] as! Int, creatAt: ActivityJsonDictionary["created_at"] as! Int,commentCount: ActivityJsonDictionary["comment_count"] as! Int)
                            activeEnitys.append(activityEnity)
                        }
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
