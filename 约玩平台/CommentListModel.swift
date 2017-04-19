//
//  commentListModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/25.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation

class CommentListModel
{
    var commentEnitys: [CommentEnity] = []
    weak var delegate: PullDataDelegate!
    var page = 1
    let manager = singleClassManager.manager
    init(delegate: PullDataDelegate)
    {
        self.delegate = delegate
    }
    //MARK: - 以下需要添加token
    //获取个人评论列表
    func getPersonalCommentList(token: String)
    {
        let requestUrl = urlStruct.basicUrl + "msg/comment.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            self?.dealWithResponse(response: response)
            
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                self?.delegate.getDataFailed()
                
                
        })
        page += 1
    }
    
    
    
    
    //获取通知，相册与活动评论
    func getCommentList(id: Int,type: String)
    {
        let requestUrl = urlStruct.basicUrl + type + "/\(id).json"
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            self?.dealWithResponse(response: response)
        
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
        
        
        })
        page += 1
    }
    func refreshCommentList(id: Int,type: String)
    {
        page = 1
        let requestUrl = urlStruct.basicUrl + type + "/\(id).json"
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            self?.commentEnitys.removeAll()
            self?.dealWithResponse(response: response)
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
            
        })
        page += 1
    }
    
    func refreshPersonalComment(token: String)
    {
        page = 1
        let requestUrl = urlStruct.basicUrl + "msg/comment.json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            self?.commentEnitys.removeAll()
            self?.dealWithResponse(response: response)
            
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                self?.delegate.getDataFailed()
                
                
        })
        page += 1
    }
    
    //获取父评论的子评论
    func getChildComment(commentId: Int)
    {
        let requestUrl = urlStruct.basicUrl + "msg/comment/" + "\(commentId).json"
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            self?.dealWithChildResponse(response: response)
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
            
        })
        page += 1
    }
    func refreshChildComment(commentId: Int)
    {
        page = 1
        let requestUrl = urlStruct.basicUrl + "msg/comment/" + "\(commentId).json"
        manager.get(requestUrl, parameters: ["page":page], progress: {(progress) in}, success: {[weak self] (dataTask,response) in
            self?.commentEnitys.removeAll()
            self?.dealWithChildResponse(response: response)
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            self?.delegate.getDataFailed()
            
            
        })
        page += 1
    }
    
    
    //处理相册通知活动评论的返回数据
    private func dealWithResponse(response: Any?)
    {
        if let originalDictionary = response as? NSDictionary
        {
            if let commentArray = originalDictionary["comments"] as? NSArray
            {
                for comment in commentArray
                {
                    if let commentDictionary = comment as? NSDictionary
                    {
                        if let userJsonDictionary = commentDictionary["creator_obj"] as? NSDictionary
                        {
                            let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                            let commentEnity = CommentEnity(id: commentDictionary["id"] as! Int, creator: userInformationEnity, content: commentDictionary["content"] as! String, parent: commentDictionary["parent"] as! Int, attachType: commentDictionary["attach_type"] as! String, attachId: commentDictionary["attach_id"] as! Int, creatAt: commentDictionary["created_at"] as! Int)
                            commentEnitys.append(commentEnity)
                        }
                    }
                }
                self.delegate.needUpdateUI()
            }
        }
    }
    //处理获取子评论的返回
    private func dealWithChildResponse(response: Any?)
    {
        if let originalDictionary = response as? NSDictionary
        {
            if let commentArray = originalDictionary["childs"] as? NSArray
            {
                for comment in commentArray
                {
                    if let commentDictionary = comment as? NSDictionary
                    {
                        if let userJsonDictionary = commentDictionary["creator_obj"] as? NSDictionary
                        {
                            let userInformationEnity = UserInformationEnity(id: userJsonDictionary["id"] as! Int, user: userJsonDictionary["user"] as! String, name: userJsonDictionary["name"] as! String, avatar: userJsonDictionary["avatar"] as? Int, description: userJsonDictionary["description"] as! String, followersCount: userJsonDictionary["followers_count"] as! Int, fansCount: userJsonDictionary["fans_count"] as! Int, activitiesCount: userJsonDictionary["activities_count"] as! Int, relation: userJsonDictionary["relation"] as! String,gender: (userJsonDictionary["gender"] as! String))
                            let commentEnity = CommentEnity(id: commentDictionary["id"] as! Int, creator: userInformationEnity, content: commentDictionary["content"] as! String, parent: commentDictionary["parent"] as! Int, attachType: commentDictionary["attach_type"] as! String, attachId: commentDictionary["attach_id"] as! Int, creatAt: commentDictionary["created_at"] as! Int)
                            commentEnitys.append(commentEnity)
                        }
                    }
                }
                self.delegate.needUpdateUI()
            }
        }
    }
    
    
}
