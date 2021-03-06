//
//  ActivityDetailModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/23.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation

class ActivityDetailModel {
    weak var activityEnity: ActiveEnity!
    let manager = singleClassManager.manager
    weak var delegate: PullDataDelegate!
   
   
    func interestActivity(token: String)
    {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityEnity.id)/" + "wisher.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.post(requestUrl, parameters: [], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            print("success")
            self?.delegate.needUpdateUI()
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
    }
    
    func uninterestActivity(token: String)
    {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityEnity.id)/" + "wisher.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.delete(requestUrl, parameters: [],  success: {
            [weak self] (dataTask,response) in
            self?.delegate.needUpdateUI()
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
    }
    func participateActivity(token: String)
    {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityEnity.id)/" + "participant.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.post(requestUrl, parameters: [], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            print("success")
            self?.delegate.needUpdateUI()
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
    }
    
    func unparticipateActivity(token: String)
    {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityEnity.id)/" + "participant.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.delete(requestUrl, parameters: [],  success: {
            [weak self] (dataTask,response) in
            self?.delegate.needUpdateUI()
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
        
        
        
    }
    
    
    func editActivity(token: String)
    {
        var tagString = ""
        for tag in activityEnity.tags
        {
            tagString += tag as! String + "&"
        }
        
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityEnity.id)" + ".json"
        
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        
        manager.post(requestUrl, parameters: ["title": activityEnity.activityTitle ,"beginTime":activityEnity.beginTime ,"endTime":activityEnity.endTime,"address":activityEnity.address,"latitude":activityEnity.latitude,"longitude":activityEnity.longitude,"fee": "\(activityEnity.fee)","category":activityEnity.category,"content":activityEnity.content,"tags": tagString], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            print("success")
            self?.delegate.needUpdateUI()
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
    }
    
    func editActivityImage(image: UIImage,token: String)
    {
        let data = UIImagePNGRepresentation(image)
        let requestUrl = urlStruct.basicUrl + "media.json"
        manager.post(requestUrl, parameters: [], constructingBodyWith: {(fromData) in
            
            fromData.appendPart(withFileData: data!, name: "file", fileName: "avatar", mimeType: "application/x-www-form-urlencoded")
        }, progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            self?.uploadImageSuccess(response:response,token: token)
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
        })
    }
    
    private func uploadImageSuccess(response: Any?,token: String)
    {
        if let JsonDictionary = response as? NSDictionary
        {
            let mediaid = JsonDictionary["media_id"] as! Int
            let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityEnity.id).json"
            print(mediaid)
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
            
            manager.post(requestUrl, parameters: ["image":mediaid], progress: {(progress) in }, success: {
                (dataTask,response) in
                
                
                
            }, failure: {(dataTask,error) in
                print(error)
                self.delegate.getDataFailed()
                
            })
            
        }
    }
    
    
    
}
