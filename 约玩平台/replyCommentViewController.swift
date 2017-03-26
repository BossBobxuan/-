//
//  replyCommentViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/26.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
protocol replyCommentDelegate {
    func successToreply() -> Void
    func failToreply() -> Void
}
class replyCommentViewController: UIViewController {
    @IBOutlet weak var replyTextView: UITextView!
        {
        didSet{
            replyTextView.becomeFirstResponder()
        }
    }
    var parentCommentId: Int?
    var attachId: Int!
    var attachType: String!
    var delegate: replyCommentDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "回复评论"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "replyComment:")
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func replyComment(_ sender: UIBarButtonItem)
    {
        let parent = parentCommentId ?? 0
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        let requestUrl = urlStruct.basicUrl + "msg/comment.json"
        manager.post(requestUrl, parameters: ["attach_type": attachType,"attach_id": attachId,"parent": parent,"content": replyTextView.text!], progress: {(progress) in }, success: {(dataTask,response) in
            self.delegate.successToreply()
        }, failure: {(dataTask,error) in
            self.delegate.failToreply()
        })
        self.navigationController?.popViewController(animated: true)
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
