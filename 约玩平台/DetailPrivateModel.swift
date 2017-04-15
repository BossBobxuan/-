//
//  DetailPrivateModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/15.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class DetailPrivateModel  {
    var enitys: [PrivateEnity] = []
    var avatar: Int!
    var personalavatar: Int!
    weak var delegate: PullDataDelegate!
    let manager = singleClassManager.manager
    
    private var requestNumber = 0
    init(delegate: PullDataDelegate) {
        self.delegate = delegate
    }
    
    func getMsgDetailList(token: String,uid: Int)
    {
        
        let requestUrl = urlStruct.basicUrl + "msg/private/" + "\(uid).json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page": 1,"count": 20], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            self?.requestNumber += 1
            self?.enitys.removeAll()
            self?.dealWithResponse(response: response)
            
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                self?.delegate.getDataFailed()
                
                
        })
        
    }
    
    func getMoreMsgDetailList(token: String,uid: Int, success: @escaping () -> Void,page: Int)
    {
        let requestUrl = urlStruct.basicUrl + "msg/private/" + "\(uid).json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page": page,"count": 20], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            self?.dealWithResponse(response: response)
            success()
            
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                self?.delegate.getDataFailed()
                
                
        })
        
    }
    
    func sendMsgToUser(token: String,uid: Int,content: String)
    {
        let requestUrl = urlStruct.basicUrl + "msg/private/" + "\(uid).json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.post(requestUrl, parameters: ["content": content], progress: {(progress) in}, success: { (dataTask,response) in
                
            
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                self?.delegate.getDataFailed()
                
                
        })
    }
    
    func getPersonalAvatar(token: String)
    {
        let requestUrl = urlStruct.basicUrl + "user/~me.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: [], progress: {(progress) in}, success: {
            [weak self] (dataTask,response) in
            self?.requestNumber += 1
            if let UserDic = response as? NSDictionary
            {
                self?.personalavatar = UserDic["avatar"] as! Int
                
            }
            if (self?.requestNumber)! >= 2
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
            self.avatar = JsonDic["avatar"] as! Int
            if let JsonArray = JsonDic["items"] as? NSArray
            {
                for element in JsonArray
                {
                    let Dic = element as! NSDictionary
                    let enity = PrivateEnity(direction: Dic["direction"] as! String, content: Dic["content"] as! String, creatAt: Dic["created_at"] as! Int)
                    enitys.append(enity)
                }
                if requestNumber >= 2
                {
                    self.delegate.needUpdateUI()
                }
            }
        }
    }
    
    
    
    
    
}


