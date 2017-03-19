//
//  PersonalInformationModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/16.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
struct urlStruct {
    static let basicUrl = "http://develop.doris.work:8888/"
}




class PersonalInformationModel
{
    var personalInformationEnity: UserInfomationEnity?
    var delegate: PullDataDelegate
    
    init(delegate: PullDataDelegate) {
        self.delegate = delegate
    }
    
    func getPersonalInformation(token: String) -> Void
    {
        let requestUrl = urlStruct.basicUrl + "user/~me.json"
        let manager = AFHTTPSessionManager()
        manager.get(requestUrl, parameters: ["token":token], progress: {(progress) in }, success: {
            (dataTask,response) in
                self.dealwithResponse(response: response)
            
        
        
        }, failure: {(dataTask,error) in
                print(error)
                self.delegate.getDataFailed()
        
        })
        
    }
    func getUserInformation(uid: Int) -> Void
    {
        let requestUrl = urlStruct.basicUrl + "user/" + "\(uid)" + ".json"
        let manager = AFHTTPSessionManager()
        manager.get(requestUrl, parameters: [], progress: {(progress) in }, success: {
            (dataTask,response) in
            self.dealwithResponse(response: response)
            
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
        
    }
    
    
    
   
    
    fileprivate func dealwithResponse(response: Any?) -> Void
    {
        if let JsonDictionary = response as? NSDictionary
        {
            personalInformationEnity = UserInfomationEnity(id: JsonDictionary["id"] as! Int, user: JsonDictionary["user"] as! String, name: JsonDictionary["name"] as! String, avatar: JsonDictionary["avatar"] as? Int, description: JsonDictionary["description"] as! String, followersCount: JsonDictionary["followers_count"] as! Int, fansCount: JsonDictionary["fans_count"] as! Int, activitiesCount: JsonDictionary["activities_count"] as! Int, relation: JsonDictionary["relation"] as! String)
            self.delegate.needUpdateUI()
        }
        else
        {
            self.delegate.getDataFailed()
        }
    }
    
}










