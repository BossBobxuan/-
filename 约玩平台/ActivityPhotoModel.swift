//
//  activityPhotoModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/8.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
class ActivityPhotoModel {
    var enitys: [PhotoEnity] = []
    var activityEnity : ActiveEnity?
    weak var delegate: PullDataDelegate!
    let manager = singleClassManager.manager
    var page = 1
    init(delegate: PullDataDelegate) {
        self.delegate = delegate
    }
    func getActivityInformation(activityId: Int)
    {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityId).json"
        manager.get(requestUrl, parameters: [], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            if let ActivityJsonDictionary = response as? NSDictionary
            {
                if let userJsonDictionary = ActivityJsonDictionary["creator_obj"] as? NSDictionary
                {
                    let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                    
                    let activityEnity = ActiveEnity(id: ActivityJsonDictionary["id"] as! Int, activityTitle: ActivityJsonDictionary["title"] as! String, image: ActivityJsonDictionary["image"] as! Int, state: ActivityJsonDictionary["state"] as! String, wisherCount: ActivityJsonDictionary["wisher_count"] as! Int, wisherTotal: ActivityJsonDictionary["wisher_total"] as! Int, participantCount: ActivityJsonDictionary["participant_count"] as! Int, creator: userInformationEnity, beginTime: ActivityJsonDictionary["beginTime"] as! Int, endTime: ActivityJsonDictionary["endTime"] as! Int, address: ActivityJsonDictionary["address"] as! String, latitude: (ActivityJsonDictionary["location"] as! NSDictionary)["latitude"] as! Double, longitude: (ActivityJsonDictionary["location"] as! NSDictionary)["longitude"] as! Double, fee: ActivityJsonDictionary["fee"] as! Int, category: ActivityJsonDictionary["category"] as! String, tags: ActivityJsonDictionary["tags"] as! NSArray, content: ActivityJsonDictionary["content"] as! String, notificationCount: ActivityJsonDictionary["notification_count"] as! Int, photoCount: ActivityJsonDictionary["photo_count"] as! Int, creatAt: ActivityJsonDictionary["created_at"] as! Int,commentCount: ActivityJsonDictionary["comment_count"] as! Int)
                    self?.activityEnity = activityEnity
                    
                }
            }
            
            }, failure: {(dataTask,error) in
                print(error)
                
                
                
        })
    }
    
    
    func getActivityPhotoList(activityId: Int) -> Void {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityId)/photo.json"
        manager.get(requestUrl, parameters: ["page":page,"count":9], progress: {(progress) in}, success: {[weak self](dataTask,response) in
            self?.dealWithResponse(response: response)
            
        }, failure: {[weak self](dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
            
        })
        
        page += 1
    }
    
    func refreshActivityPhotoList(activityId: Int) -> Void
    {
        page = 1
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityId)/photo.json"
        manager.get(requestUrl, parameters: ["page":page,"count":9], progress: {(progress) in}, success: {[weak self](dataTask,response) in
            self?.enitys.removeAll()
            self?.dealWithResponse(response: response)
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
            
        })
        page += 1
    }
    
    func uploadImage(activityId: Int,description: String?,image: UIImage, token: String)
    {
        let data = UIImagePNGRepresentation(image)
        let requestUrl = urlStruct.basicUrl + "media.json"
        manager.post(requestUrl, parameters: [], constructingBodyWith: {(fromData) in
            
            fromData.appendPart(withFileData: data!, name: "file", fileName: "avatar", mimeType: "application/x-www-form-urlencoded")
        }, progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            print("upload")
            self?.uploadImageSuccess(mediaId: (response as! NSDictionary)["media_id"] as! Int, activityId: activityId, description: description, token: token)
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
            
        })
        
    }
    private func uploadImageSuccess(mediaId: Int,activityId: Int,description: String?,token: String)
    {
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityId)/photo.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        if description != nil
        {
            manager.post(requestUrl, parameters: ["media_id":"\(mediaId)","description":description!], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
                print("uploadImage")
                self?.delegate.needUpdateUI()
            
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                self?.delegate.getDataFailed()
            
            
            })
        }else
        {
            manager.post(requestUrl, parameters: ["media_id":"\(mediaId)"], progress: {(progress) in}, success: {[weak self](dataTask,response) in
                self?.delegate.needUpdateUI()
                
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                self?.delegate.getDataFailed()
                
                
            })
        }
    }
    
    
    
    
    private func dealWithResponse(response: Any?)
    {
        if let JsonDic = response as? NSDictionary
        {
            if let array = JsonDic["photos"] as? NSArray
            {
                for element in array
                {
                    if let Dic = element as? NSDictionary
                    {
                        if let userJsonDictionary = Dic["creator_obj"] as? NSDictionary
                        {
                            let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                            
                            let photo = PhotoEnity(id: Dic["id"] as! Int, creator: userInformationEnity, activityId: Dic["activity_id"] as! Int, mediaId: Dic["media_id"] as! Int, description: Dic["description"] as? String, creatAt: Dic["created_at"] as! Int, commentCount: Dic["comment_count"] as! Int)
                            enitys.append(photo)
                        }
                    }
                }
                self.delegate.needUpdateUI()
                
            }
        }
    }
    
    
}


