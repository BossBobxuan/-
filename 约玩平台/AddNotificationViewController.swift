//
//  AddNotificationViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/19.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class AddNotificationViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var contentTextView: UITextView!
    var aid: Int!
    var isEdit: Bool = false
    var notificationTitle: String!
    var notificationContent: String!
    func addDone()
    {
        if titleTextField.text == "" || contentTextView.text == ""
        {
            let alert = UIAlertController(title: "标题或者内容不可为空", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else
        {
            if isEdit
            {
                let alert = UIAlertController(title: "正在修改通知", message: nil, preferredStyle: .alert)
                
                self.present(alert, animated: true, completion: nil)
                let requestUrl = urlStruct.basicUrl + "notification/" + "\(self.aid!).json"
                manager.requestSerializer.setValue(self.token, forHTTPHeaderField: "token")
                print(titleTextField.text!)
                print(contentTextView.text)
                manager.post(requestUrl, parameters: ["title": titleTextField.text!,"content": contentTextView.text!], progress: {(progress) in }, success: {
                    (dataTask,response) in
                    print("success")
                    alert.dismiss(animated: true, completion: {
                        let _ = self.navigationController?.popViewController(animated: true)
                        let controller = self.navigationController?.viewControllers.last as! NotificationListViewController
                        controller.pullToRefresh()
                    })
                    
                    
                }, failure: {(dataTask,error) in
                    print(error)
                    alert.dismiss(animated: true, completion: {
                        let alert2 = UIAlertController(title: "发布失败", message: "请检查网络连接", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        self.present(alert2, animated: true, completion: nil)
                        
                    })
                    
                    
                })

            }else
            {
                let alert = UIAlertController(title: "正在发布通知", message: nil, preferredStyle: .alert)
                
                self.present(alert, animated: true, completion: nil)
                let requestUrl = urlStruct.basicUrl + "activity/" + "\(self.aid!)" + "/notification.json"
                manager.requestSerializer.setValue(self.token, forHTTPHeaderField: "token")
                print(titleTextField.text!)
                print(contentTextView.text)
                manager.post(requestUrl, parameters: ["title": titleTextField.text!,"content": contentTextView.text!], progress: {(progress) in }, success: {
                    (dataTask,response) in
                    print("success")
                    alert.dismiss(animated: true, completion: {
                        let _ = self.navigationController?.popViewController(animated: true)
                        let controller = self.navigationController?.viewControllers.last as! NotificationListViewController
                        controller.pullToRefresh()
                    })
                    
                    
                }, failure: {(dataTask,error) in
                    print(error)
                    alert.dismiss(animated: true, completion: {
                        let alert2 = UIAlertController(title: "发布失败", message: "请检查网络连接", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        self.present(alert2, animated: true, completion: nil)
                        
                    })
                    
                    
                })

            }

        }
        
        
    }
    
    
    
    let manager = singleClassManager.manager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isEdit
        {
            titleTextField.text = notificationTitle
            contentTextView.text = notificationContent
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "addDone")
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
