//
//  msgDetailViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/12.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
class testModel  {
    var direction: String
    var content: String
    init(direction: String,content: String) {
        self.direction = direction
        self.content = content
    }
}
class msgDetailViewController: UIViewController {
    @IBOutlet weak var containScrollView: UIScrollView!
    private var nextY: CGFloat = 8
    private var screentrailing: CGFloat
        {
            return containScrollView.bounds.width - 8
    }
    var model: [testModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for i in 0 ..< 10
        {
            if i%2 == 0
            {
                let enity = testModel(direction: "0", content: "123213421342421214212134234234213423423")
                model.append(enity)
            }else
            {
                let enity = testModel(direction: "1", content: "456")
                model.append(enity)
            }
        }
        for enity in model
        {
            if enity.direction == "0"//我发送的
            {
                let avatar = UIImageView(frame: CGRect(x: screentrailing - 40, y: nextY, width: 40, height: 40))
                avatar.layer.cornerRadius = 20
                avatar.layer.masksToBounds = true
                avatar.image = #imageLiteral(resourceName: "c37cea0a6e642c5a8ad0457a8f2a6c75.jpg")
                let contentLabel = UILabel()
                contentLabel.text = enity.content
                contentLabel.numberOfLines = 0
                contentLabel.lineBreakMode = .byTruncatingTail
                let size = contentLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 110, height: 444440))
                
                contentLabel.frame = CGRect(x: avatar.frame.minX - 8 - size.width, y: nextY, width: size.width, height: size.height)
                contentLabel.layer.borderWidth = 0.5
                contentLabel.layer.cornerRadius = 4
                contentLabel.backgroundColor = UIColor.yellow
                containScrollView.addSubview(avatar)
                containScrollView.addSubview(contentLabel)
                nextY += contentLabel.frame.height + 10
                if nextY < (avatar.frame.maxY + 10)
                {
                    nextY = avatar.frame.maxY + 10
                }//防止label过小
                
            }else //对方发送的
            {
                let avatar = UIImageView(frame: CGRect(x: 8, y: nextY, width: 40, height: 40))
                avatar.layer.cornerRadius = 20
                avatar.layer.masksToBounds = true
                avatar.image = #imageLiteral(resourceName: "c37cea0a6e642c5a8ad0457a8f2a6c75.jpg")
                let contentLabel = UILabel()
                contentLabel.text = enity.content
                contentLabel.numberOfLines = 0
                contentLabel.lineBreakMode = .byTruncatingTail
                let size = contentLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 110, height: 4444440))
                contentLabel.frame = CGRect(x: 56, y: nextY, width: size.width, height: size.height)
                contentLabel.layer.borderWidth = 0.5
                contentLabel.layer.cornerRadius = 4
                containScrollView.addSubview(avatar)
                containScrollView.addSubview(contentLabel)
                nextY += contentLabel.frame.height + 10
                if nextY < (avatar.frame.maxY + 10)
                {
                    nextY = avatar.frame.maxY + 10
                }
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
