//
//  getTokenExtension.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/20.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
extension UIViewController
{
    var token: String
        {
            let user = UserDefaults.standard
            print(user.object(forKey: "token") as! String)
            return user.object(forKey: "token") as! String
            //return "0e8bdb4e-8d1d-41e8-96a5-ad9c4311bb98"
            //MARK : - 此处需要用userDefault获取token
    }
    func getImageFromCaches(mediaId: Int) -> UIImage? {
//        let manager = FileManager()
//        let urls = manager.urls(for: .cachesDirectory, in: .userDomainMask)
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        print(path[0])
        let fileString = path[0] + "/\(mediaId)"
        if let image = UIImage(contentsOfFile: fileString)
        {
            return image
        }
//        let fileUrl = urls[0].appendingPathComponent("\(mediaId)")
//        if let imagedata = try? Data(contentsOf: fileUrl)
//        {
//            print("getdatasuccess")
//            if let image = UIImage(data: imagedata)
//            {
//                return image
//            }
//            
//        }
        return nil
    }
    
    func saveImageCaches(image: UIImage,mediaId: Int)  {
        let manager = FileManager()
        let urls = manager.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileUrl = urls[0].appendingPathComponent("\(mediaId)")
        let data = UIImagePNGRepresentation(image)
        try! data?.write(to: fileUrl)
    }
    
}
