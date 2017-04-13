//
//  timeLineModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/6.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class timeLineModel
{
    var Enitys: [Any] = []
    var status: [String] = []//与enitys中的对象通过index一一对应
    weak var delegate: PullDataDelegate!
    let manager = singleClassManager.manager
    var userAvatarId: Int!
    var userName: String!
    var requestNumber = 0
    init(delegate: PullDataDelegate) {
        self.delegate = delegate
    }
    
    func getUserTimeLine(token: String)
    {
        requestNumber = 0
        let requestUrl = urlStruct.basicUrl + "user/~me/timeline/home.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: [], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            self?.requestNumber += 1
            
            self?.Enitys.removeAll()
            self?.status.removeAll()
            self?.dealWithResponse(response: response)
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
            
        })
        manager.get(urlStruct.basicUrl + "user/~me.json", parameters: [], progress: {(progress) in}, success: {[weak self](dataTask,response) in
            self?.requestNumber += 1
            
            if let Dic = response as? NSDictionary
            {
                self?.userAvatarId = Dic["avatar"] as! Int
                self?.userName = Dic["name"] as! String
            }
            if self?.requestNumber == 2
            {
                self?.delegate.needUpdateUI()
            }
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
            
        })
        
        
        
    }
    
    
    private func dealWithResponse(response: Any?)
    {
        if let JsonDic = response as? NSDictionary
        {
            if let statuses = JsonDic["statues"] as? NSArray
            {
                for element in statuses
                {
                    let dictionary = element as! NSDictionary
                    let type = dictionary["attach_type"] as! String
                    status.append(type)
                    switch type {
                    case "0":
                        let JsonDictionary = dictionary["attach_obj"] as! NSDictionary
                        let userInformationEnity = UserInformationEnity(id: JsonDictionary["id"] as! Int, user: JsonDictionary["user"] as! String, name: JsonDictionary["name"] as! String, avatar: JsonDictionary["avatar"] as? Int, description: JsonDictionary["description"] as! String, followersCount: JsonDictionary["followers_count"] as! Int, fansCount: JsonDictionary["fans_count"] as! Int, activitiesCount: JsonDictionary["activities_count"] as! Int, relation: JsonDictionary["relation"] as! String,gender: (JsonDictionary["gender"] as! String))
                        Enitys.append(userInformationEnity)
                    case "1":
                        if let ActivityJsonDictionary = dictionary["attach_obj"] as? NSDictionary
                        {
                            if let userJsonDictionary = ActivityJsonDictionary["creator_obj"] as? NSDictionary
                            {
                                let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                                
                                let activityEnity = ActiveEnity(id: ActivityJsonDictionary["id"] as! Int, activityTitle: ActivityJsonDictionary["title"] as! String, image: ActivityJsonDictionary["image"] as! Int, state: ActivityJsonDictionary["state"] as! String, wisherCount: ActivityJsonDictionary["wisher_count"] as! Int, wisherTotal: ActivityJsonDictionary["wisher_total"] as! Int, participantCount: ActivityJsonDictionary["participant_count"] as! Int, creator: userInformationEnity, beginTime: ActivityJsonDictionary["beginTime"] as! Int, endTime: ActivityJsonDictionary["endTime"] as! Int, address: ActivityJsonDictionary["address"] as! String, latitude: (ActivityJsonDictionary["location"] as! NSDictionary)["latitude"] as! Double, longitude: (ActivityJsonDictionary["location"] as! NSDictionary)["longitude"] as! Double, fee: ActivityJsonDictionary["fee"] as! Int, category: ActivityJsonDictionary["category"] as! String, tags: ActivityJsonDictionary["tags"] as! NSArray, content: ActivityJsonDictionary["content"] as! String, notificationCount: ActivityJsonDictionary["notification_count"] as! Int, photoCount: ActivityJsonDictionary["photo_count"] as! Int, creatAt: ActivityJsonDictionary["created_at"] as! Int,commentCount: ActivityJsonDictionary["comment_count"] as! Int)
                                Enitys.append(activityEnity)
                            }
                        }
                    case "2":
                        //MARK: - 照片尚未创建此处缺失
                        if let Dic = dictionary["attach_obj"] as? NSDictionary
                        {
                            if let userJsonDictionary = Dic["creator_obj"] as? NSDictionary
                            {
                                let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                            
                                let photo = PhotoEnity(id: Dic["id"] as! Int, creator: userInformationEnity, activityId: Dic["activity_id"] as! Int, mediaId: Dic["media_id"] as! Int, description: Dic["description"] as? String, creatAt: Dic["created_at"] as! Int, commentCount: Dic["comment_count"] as! Int)
                                Enitys.append(photo)
                            }
                        }
                        
                        
                        
                        
                        
                    case "3":
                        if let NotificationJsonDictionary = dictionary["attach_obj"] as? NSDictionary
                        {
                            if let userJsonDictionary = NotificationJsonDictionary["creator_obj"] as? NSDictionary
                            {
                                let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                                
                                let notificationEnity = NotificationEnity(id: NotificationJsonDictionary["id"] as! Int, creator: userInformationEnity, activityId: NotificationJsonDictionary["activity_id"] as! Int, title: NotificationJsonDictionary["title"] as! String, content: NotificationJsonDictionary["content"] as! String, commentCount: NotificationJsonDictionary["comment_count"] as! Int, creatAt: NotificationJsonDictionary["created_at"] as! Int)
                                Enitys.append(notificationEnity)
                            }
                        }
                    case "4":
                        if let commentDictionary = dictionary["attach_obj"] as? NSDictionary
                        {
                            if let userJsonDictionary = commentDictionary["creator_obj"] as? NSDictionary
                            {
                                let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                                let commentEnity = CommentEnity(id: commentDictionary["id"] as! Int, creator: userInformationEnity, content: commentDictionary["content"] as! String, parent: commentDictionary["parent"] as! Int, attachType: commentDictionary["attach_type"] as! String, attachId: commentDictionary["attach_id"] as! Int, creatAt: commentDictionary["created_at"] as! Int)
                                Enitys.append(commentEnity)
                            }
                        }
                    default:
                        break
                    }
                }
            }
        }
        if requestNumber == 2
        {
            self.delegate.needUpdateUI()
        }
    }
    
    
}
