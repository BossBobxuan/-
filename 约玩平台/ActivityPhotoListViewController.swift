//
//  ActivityPhotoListViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/7.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class ActivityPhotoListViewController: UIViewController {
    var imageArray: [UIImage] = []
    var nextX: CGFloat = 0
    var nextY: CGFloat = 0
    private var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        nextY += (self.navigationController?.navigationBar.bounds.height)! + 20
        // Do any additional setup after loading the view.
        for _ in 0 ..< 10
        {
            let image = #imageLiteral(resourceName: "date.png")
            imageArray.append(image)
        }
        for image in imageArray
        {
            i += 1
            let imageView = UIImageView(frame: CGRect(x: nextX, y: nextY, width: UIScreen.main.bounds.size.width / 3.0, height: UIScreen.main.bounds.size.width / 3.0))
            imageView.image = image
            self.view.addSubview(imageView)
            if i == 3
            {
                i = 0
                nextX = 0
                nextY += UIScreen.main.bounds.size.width / 3.0
            }else
            {
                nextX += UIScreen.main.bounds.size.width / 3.0
        
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
