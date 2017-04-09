//
//  searchModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/9.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class searchModel {
    var Enitys: [String:[Any]] = ["user":[],"activity":[]]
    weak var delegate: PullDataDelegate!
    var page = 1
    let manager = AFHTTPSessionManager()
    init(delegate: PullDataDelegate) {
        self.delegate = delegate
    }
    func searchItem(type: String,keyword: String)
    {
        page = 1
        let utf8KeyWord = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(utf8KeyWord)
        var requestUrl = urlStruct.basicUrl + "search/"
        requestUrl += type + "/" + utf8KeyWord! + ".json"
        print(requestUrl)
        manager.get(requestUrl, parameters: ["page": page], progress: {(progress) in}, success: {(dataTask,response) in
            self.Enitys[type]! = []
            self.dealWithResponse(response: response,type: type)
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
            
        })
        page += 1
    }
   
    
    func getmoreItem(type: String,keyword: String)
    {
        let utf8KeyWord = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(utf8KeyWord)
        var requestUrl = urlStruct.basicUrl + "search/"
        requestUrl += type + "/" + utf8KeyWord! + ".json"
        print(requestUrl)
        manager.get(requestUrl, parameters: ["page": page], progress: {(progress) in}, success: {(dataTask,response) in
            print("page")
            self.dealWithResponse(response: response,type: type)
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
            
        })
        page += 1
    }
    
    
    
    
    
    
    private func dealWithResponse(response: Any?,type: String)
    {
        if let JsonDic = response as? NSDictionary
        {
            if let array = JsonDic["results"] as? NSArray
            {
                if type == "user"
                {
                    for element in array
                    {
                        
                        if let JsonDictionary = element as? NSDictionary
                        {
                                //MARK: - 此处gender暂时为nil，以后需要修改
                            print("user")
                            let userInformationEnity = UserInformationEnity(id: JsonDictionary["id"] as! Int, user: JsonDictionary["user"] as! String, name: JsonDictionary["name"] as! String, avatar: JsonDictionary["avatar"] as? Int, description: JsonDictionary["description"] as! String, followersCount: JsonDictionary["followers_count"] as! Int, fansCount: JsonDictionary["fans_count"] as! Int, activitiesCount: JsonDictionary["activities_count"] as! Int, relation: JsonDictionary["relation"] as! String,gender: (JsonDictionary["gender"] as! String))
                                Enitys[type]!.append(userInformationEnity)
                                
                        }
                            
                        
                    }
                }else if type == "activity"
                {
                    for activity in array
                    {
                        if let ActivityJsonDictionary = activity as? NSDictionary
                        {
                            if let userJsonDictionary = ActivityJsonDictionary["creator_obj"] as? NSDictionary
                            {
                                print("activity")
                                let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                                
                                let activityEnity = ActiveEnity(id: ActivityJsonDictionary["id"] as! Int, activityTitle: ActivityJsonDictionary["title"] as! String, image: ActivityJsonDictionary["image"] as! Int, state: ActivityJsonDictionary["state"] as! String, wisherCount: ActivityJsonDictionary["wisher_count"] as! Int, wisherTotal: ActivityJsonDictionary["wisher_total"] as! Int, participantCount: ActivityJsonDictionary["participant_count"] as! Int, creator: userInformationEnity, beginTime: ActivityJsonDictionary["beginTime"] as! Int, endTime: ActivityJsonDictionary["endTime"] as! Int, address: ActivityJsonDictionary["address"] as! String, latitude: (ActivityJsonDictionary["location"] as! NSDictionary)["latitude"] as! Double, longitude: (ActivityJsonDictionary["location"] as! NSDictionary)["longitude"] as! Double, fee: ActivityJsonDictionary["fee"] as! Int, category: ActivityJsonDictionary["category"] as! String, tags: ActivityJsonDictionary["tags"] as! NSArray, content: ActivityJsonDictionary["content"] as! String, notificationCount: ActivityJsonDictionary["notification_count"] as! Int, photoCount: ActivityJsonDictionary["photo_count"] as! Int, creatAt: ActivityJsonDictionary["created_at"] as! Int,commentCount: ActivityJsonDictionary["comment_count"] as! Int)
                                Enitys[type]!.append(activityEnity)
                            }
                        }
                    }
                }
            }
            self.delegate.needUpdateUI()
        }
    }
    
    
}
