//
//  ActivityEnity.swift
//  
//
//  Created by Bossxuan on 17/3/16.
//
//
import Foundation
import MapKit
class ActivityEnity:NSObject,MKAnnotation
{
    var id: Int?
    var activityTitle: String
    var image: Int?
    var state: String?
    var wisherCount: Int?
    var wisherTotal: Int?
    var participantCount: Int?
    var creator: UserInformationEnity?
    var beginTime: Int? //此处应为Unix时间戳
    var endTime: Int? //此处应为Unix时间戳
    var address: String?
   
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    
    var fee: String?
    var category: Int?
    var tags: NSArray?
    var content: String?
    var notificationCount: Int?
    var photoCount: Int?
    var creatAt: Int? //此处为Unix时间戳
    //以下之后需要删除
    var ownername: String
    var interestednumber: Int
    
    //下面用于在地图上显示
    var title: String?
    {
        return activityTitle
    }
    var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    init(activityTitle:String,ownername:String,interestednumber:Int,latitude:CLLocationDegrees,longitude:CLLocationDegrees)
    {
        
        self.activityTitle = activityTitle
        self.ownername = ownername
        self.interestednumber = interestednumber
        self.latitude = latitude
        self.longitude = longitude
    }
}
