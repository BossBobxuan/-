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
    var userInformationEnitys: [UserInformationEnity] = []
    weak var delegate: PullDataDelegate!
    private var page: Int = 1
    var type: String
    let manager = singleClassManager.manager
   
    init(delegate: PullDataDelegate,type: String) {
        self.delegate = delegate
        self.type = type
    }
    //用于第一次从服务器拉取
    func GetFollowersOrFansList(token: String) -> Void
    {
        let requestUrl = urlStruct.basicUrl + "user/~me/" + type + ".json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.dealwithResponse(response: response)
            
            
        }, failure: {[weak self] (dataTask,error) in
            
            if  ((error as! NSError).userInfo["com.alamofire.serialization.response.error.response"] as! HTTPURLResponse).statusCode == 400
            {
                self?.delegate.needUpdateUI()//MARK: - 此处防止请求不到数据，更改接口后可以删除
            }else
            {
                print(error)
                self?.delegate.getDataFailed()
            }
        })
        page += 1
    }
    
    func GetFollowersOrFansList(uid: Int,token: String) -> Void
    {
        var requestUrl = ""
        if type == "participant"
        {
            requestUrl = urlStruct.basicUrl + "activity/" + "\(uid)/" + type + ".json"
        }else
        {
            requestUrl = urlStruct.basicUrl + "user/" + "\(uid)/" + type + ".json"

        }
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.dealwithResponse(response: response)
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
        page += 1
    }
    
   
    
    //用于下拉刷新获取数据
    func FreshFollowersOrFans(token: String) -> Void
    {
        page = 1
        
        let requestUrl = urlStruct.basicUrl + "user/~me/" + type + ".json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.userInformationEnitys.removeAll()
            self?.dealwithResponse(response: response)
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
        page += 1
    }
    
    func FreshFollowersOrFans(uid: Int,token: String) -> Void
    {
        page = 1
        var requestUrl = ""
        if type == "participant"
        {
            requestUrl = urlStruct.basicUrl + "activity/" + "\(uid)/" + type + ".json"
        }else
        {
            requestUrl = urlStruct.basicUrl + "user/" + "\(uid)/" + type + ".json"
            
        }
        
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.userInformationEnitys.removeAll()
            self?.dealwithResponse(response: response)
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            
            self?.delegate.getDataFailed()
            
        })
        page += 1
    }
    
    //添加关注
    func addFollow(uid: Int,token: String)
    {
        let requestUrl = urlStruct.basicUrl + "user/~me/follower/" + "\(uid).json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //此处token需要更改
        manager.post(requestUrl, parameters: [], progress: {(progress) in }, success: {
            (dataTask,response) in
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
        
    }
    //取消关注
    func notFollow(uid: Int,token: String)
    {
        let requestUrl = urlStruct.basicUrl + "user/~me/follower/" + "\(uid).json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.delete(requestUrl, parameters: [], success: {(dataTask,response) in
        
        
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
        
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
                        //MARK: - 此处gender暂时为nil，以后需要修改
                        let userInformationEnity = UserInformationEnity(id: JsonDictionary["id"] as! Int, user: JsonDictionary["user"] as! String, name: JsonDictionary["name"] as! String, avatar: JsonDictionary["avatar"] as? Int, description: JsonDictionary["description"] as! String, followersCount: JsonDictionary["followers_count"] as! Int, fansCount: JsonDictionary["fans_count"] as! Int, activitiesCount: JsonDictionary["activities_count"] as! Int, relation: JsonDictionary["relation"] as! String,gender: (JsonDictionary["gender"] as! String))
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
