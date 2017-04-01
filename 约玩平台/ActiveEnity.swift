//
//  ActiveEnity.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/22.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
import MapKit
class ActiveEnity:NSObject,MKAnnotation
{
    var id: Int
    var activityTitle: String
    var image: Int
    var state: String
    var wisherCount: Int
    var wisherTotal: Int
    var participantCount: Int
    var creator: UserInformationEnity
    var beginTime: Int //此处应为Unix时间戳
    var endTime: Int //此处应为Unix时间戳
    var address: String
    
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    
    var fee: Int
    var category: String
    var tags: NSArray
    var content: String
    var notificationCount: Int
    var commentCount: Int
    var photoCount: Int
    var creatAt: Int //此处为Unix时间戳
    
    //MARK: = 方便在地图上显示
    var title: String?
    {
        return activityTitle
    }
    var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    init(id: Int,activityTitle: String,image: Int,state: String,wisherCount: Int,wisherTotal: Int,participantCount: Int,creator: UserInformationEnity,beginTime: Int,endTime: Int,address: String,latitude: Double,longitude: Double,fee: Int,category: String,tags: NSArray,content: String,notificationCount: Int,photoCount: Int,creatAt: Int,commentCount: Int)
    {
        self.id = id
        self.activityTitle = activityTitle
        self.image = image
        self.state = state
        self.wisherCount = wisherCount
        self.wisherTotal = wisherTotal
        self.participantCount = participantCount
        self.creator = creator
        self.beginTime = beginTime
        self.endTime = endTime
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.fee = fee
        self.category = category
        self.tags = tags
        self.content = content
        self.notificationCount = notificationCount
        self.photoCount = photoCount
        self.creatAt = creatAt
        self.commentCount = commentCount
    }
  

}

//MARK: - extension拓展功能便于获得活动状态，tags等
extension ActiveEnity
{
    var stateString: String
        {
        switch self.state {
        case "0":
            return "发起中"
        case "1":
            return "进行中"
        case "2":
            return "已结束"
        default:
            return "错误"
        }
    }
    var categoryString: String
        {
        switch self.category {
        case "0":
            return "全部"
        case "1":
            return "聚餐"
        case "2":
            return "运动"
        case "3":
            return "旅行"
        case "4":
            return "电影"
        case "5":
            return "音乐"
        case "6":
            return "分享会"
        case "7":
            return "赛事"
        case "8":
            return "桌游"
        case "9":
            return "其他"
            
        default:
            return "错误"
        }
    }
}



