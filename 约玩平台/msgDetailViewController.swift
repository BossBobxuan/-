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
    private var borderDisdance: CGFloat
    {
        let contentLabel = UILabel()
        contentLabel.text = "0"
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byTruncatingTail
        let size = contentLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 110, height: 444440))
        return (40 - size.height) / 2
    }
    var model: [testModel] = []
    var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for i in 0 ..< 20
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
        showMsgList(array: model)
//        let timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.main)
//        timer.scheduleRepeating(deadline: DispatchTime.now(), interval: 1)
//        timer.setEventHandler(handler: DispatchWorkItem(block: {
//            print("多线程")
//            let _ = self.model.popLast()
//            DispatchQueue.main.async {
//                print("进入主线程")
//                self.showMsgList(array: self.model)
//            }
//        }))
//        timer.activate()
        timer = Timer(timeInterval: 1, repeats: true, block: {[weak self](_) in
            
            print("timer")
            self?.model.popLast()
            DispatchQueue.main.async {
                self?.showMsgList(array: (self?.model)!)
            }
        })//此处需要释放
        DispatchQueue.global().async {
            print("子线程")
            RunLoop.current.add(self.timer, forMode: .commonModes)
            RunLoop.current.run()//必须手动使当前runloop运行
            
            
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        print("2")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    
    private func showMsgList(array model: [testModel])
    {
        nextY = 0
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
                
                contentLabel.frame = CGRect(x: borderDisdance, y: borderDisdance, width: size.width, height: size.height)
                let containView = UIView(frame: CGRect(x: avatar.frame.minX - 8 - (size.width + 2 * borderDisdance), y: nextY, width: size.width + 2 * borderDisdance, height: size.height + 2 * borderDisdance))
                containView.layer.borderWidth = 0.5
                containView.layer.cornerRadius = 4
                containView.backgroundColor = UIColor.yellow
                containView.addSubview(contentLabel)
                containScrollView.addSubview(avatar)
                containScrollView.addSubview(containView)
                
                nextY = containView.frame.maxY + 10
                
                
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
                let containView = UIView(frame: CGRect(x: 56, y: nextY, width: size.width + 2 * borderDisdance, height: size.height + 2 * borderDisdance))
                contentLabel.frame = CGRect(x: borderDisdance, y: borderDisdance, width: size.width, height: size.height)
                containView.layer.borderWidth = 0.5
                containView.layer.cornerRadius = 4
                containView.addSubview(contentLabel)
                containScrollView.addSubview(avatar)
                containScrollView.addSubview(containView)
                nextY = containView.frame.maxY + 10
            }
            containScrollView.contentSize.height = nextY + 10
            containScrollView.contentOffset.y = containScrollView.contentSize.height - containScrollView.frame.height
        }
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
