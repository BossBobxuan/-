//
//  ActivityModel.swift
//  约玩平台
//
//  Created by Bossxuan on 17/1/8.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
import MapKit
protocol GetDataSuccessDelegate {
    func needreload()->Void
    func errordisplay()->Void
}

class ActivityModel
{
    var enitys:[ActivityEnity] = [ActivityEnity]()
    var delegate:GetDataSuccessDelegate
    init(delegate:GetDataSuccessDelegate)
    {
        self.delegate = delegate
    }
    func getdata(url:String)
    {
        let endurl = url + "/getdata/"
        let manager = AFHTTPSessionManager()
        manager.get(endurl, parameters: nil, progress: {(progress) in }, success:
            {(dataTask,response) in
               self.dealWithResponse(response: response)
        }, failure: {(dataTask,error) in
            print(error)
            self.delegate.errordisplay()
        })
    }
    fileprivate func dealWithResponse(response:Any?)
    {
        if let resarray = response as? NSArray
        {
            for element in resarray
            {
                if let dic = element as? NSDictionary
                {
                    let enity = ActivityEnity(activityTitle: dic["activityTitle"] as! String, ownername: dic["ownername"] as! String, interestednumber: dic["intereastednumber"] as! Int, latitude: dic["latitude"] as! Double, longitude: dic["longitude"] as! Double)
                    enitys.append(enity)
                }
            }
            delegate.needreload()
        }
            
    }
}
