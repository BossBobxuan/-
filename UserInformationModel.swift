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
    var personalInformationEnity: UserInformationEnity?
    var delegate: PullDataDelegate
    let manager = AFHTTPSessionManager()
    init(delegate: PullDataDelegate) {
        self.delegate = delegate
    }
    
    func getPersonalInformation(token: String) -> Void
    {
        let requestUrl = urlStruct.basicUrl + "user/~me.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["token":token], progress: {(progress) in }, success: {
            (dataTask,response) in
                self.dealwithResponse(response: response)
            
        
        
        }, failure: {(dataTask,error) in
                print(error)
                self.delegate.getDataFailed()
        
        })
        
    }
    func getUserInformation(uid: Int,token: String) -> Void
    {
        let requestUrl = urlStruct.basicUrl + "user/" + "\(uid)" + ".json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: [], progress: {(progress) in }, success: {
            (dataTask,response) in
            self.dealwithResponse(response: response)
            
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
        
    }
    func editUserInformation(token: String,avatar: String) -> Void
    {
        let requestUrl = urlStruct.basicUrl + "user/~me.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        print(avatar)
        manager.post(requestUrl, parameters: ["name":personalInformationEnity!.name,"gender":personalInformationEnity!.gender,"avatar": avatar,"description":personalInformationEnity!.description], progress: {(progress) in }, success: {
            (dataTask,response) in
            self.dealwithResponse(response: response)
            
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
    }
    
    func uploadImage(image: UIImage,token: String)
    {
        let data = UIImagePNGRepresentation(image)
        let requestUrl = urlStruct.basicUrl + "media.json"
        manager.post(requestUrl, parameters: [], constructingBodyWith: {(fromData) in
            
            fromData.appendPart(withFileData: data!, name: "file", fileName: "avatar", mimeType: "application/x-www-form-urlencoded")
        }, progress: {(progress) in }, success: {
            (dataTask,response) in
            self.uploadImageSuccess(response:response,token: token)
            
            
            
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.getDataFailed()
            
        })
        

      
    }
    private func uploadImageSuccess(response: Any?,token: String) -> Void
    {
        if let JsonDictionary = response as? NSDictionary
        {
            let mediaid = JsonDictionary["media_id"] as! Int
            self.editUserInformation(token: token, avatar: "\(mediaid)")
            
        }
    }
   
    
    fileprivate func dealwithResponse(response: Any?) -> Void
    {
        if let JsonDictionary = response as? NSDictionary
        {
            //MARK: - 此处gender暂时为空以后需要更改
            personalInformationEnity = UserInformationEnity(id: JsonDictionary["id"] as! Int, user: JsonDictionary["user"] as! String, name: JsonDictionary["name"] as! String, avatar: JsonDictionary["avatar"] as? Int, description: JsonDictionary["description"] as! String, followersCount: JsonDictionary["followers_count"] as! Int, fansCount: JsonDictionary["fans_count"] as! Int, activitiesCount: JsonDictionary["activities_count"] as! Int, relation: JsonDictionary["relation"] as! String,gender: JsonDictionary["gender"] as! String)
            self.delegate.needUpdateUI()
        }
        else
        {
            self.delegate.getDataFailed()
        }
    }
    
}










