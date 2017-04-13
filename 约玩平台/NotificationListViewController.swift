//
//  NotificationListViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/1.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class NotificationListViewController: UIViewController, PullDataDelegate, UITableViewDelegate, UITableViewDataSource, havePullfreshAndLoadmoreTableViewDelegate {
    @IBOutlet weak var notificationTableView: havePullfreshAndLoadmoreTableView!
    var notificationListModel: NotificationListModel!
    var activityId: Int!
    var havePowerToEdit: Bool = false
    //MARK: - event Func
    func toCommentList(_ sender: UIButton)
    {
        performSegue(withIdentifier: seguename.notificationToComment, sender: sender.tag)
    }
    func addNotification(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "发布通知", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in textField.placeholder = "请输入通知标题"})
        alert.addTextField(configurationHandler: {(textField) in textField.placeholder = "请输入通知详情"})
        let action = UIAlertAction(title: "确定", style: .default, handler: {(alertAction) in
            let alert1 = UIAlertController(title: "正在发布通知", message: "请稍后", preferredStyle: .alert)
            self.present(alert1, animated: true, completion: {})
            let manager = singleClassManager.manager
            let requestUrl = urlStruct.basicUrl + "activity/" + "\(self.activityId!)" + "/notification.json"
            manager.requestSerializer.setValue(self.token, forHTTPHeaderField: "token")
            manager.post(requestUrl, parameters: ["title": alert.textFields![0].text!,"content": alert.textFields![1].text!], progress: {(progress) in }, success: {
                (dataTask,response) in
                print("success")
                alert1.dismiss(animated: true, completion: nil)
                self.pullToRefresh()
                
            }, failure: {(dataTask,error) in
                print(error)
                alert1.dismiss(animated: true, completion: nil)
                let alert2 = UIAlertController(title: "发布失败", message: "请检查网络连接", preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alert2, animated: true, completion: nil)
                
            })
            
        })
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationListModel = NotificationListModel(delegate: self)
        
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
        notificationTableView.pullDataDelegate = self//设置代理添加下拉刷新与加载更多功能
        
        notificationListModel.getNotification(activityId: activityId)
        self.navigationItem.title = "活动通知"
        
        if havePowerToEdit
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: "addNotification:")
    
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - tableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        if havePowerToEdit
        {
            let alert = UIAlertController(title: "请选择动作", message: "", preferredStyle: .actionSheet)
            let editNotificationAction = UIAlertAction(title: "修改", style: .default, handler: {(action) in
                let editalert = UIAlertController(title: "修改通知", message: "", preferredStyle: .alert)
                editalert.addTextField(configurationHandler: {(textField) in textField.text = self.notificationListModel.notificationEnitys[indexPath.row].title})
                editalert.addTextField(configurationHandler: {(textField) in textField.text = self.notificationListModel.notificationEnitys[indexPath.row].content})
                let action = UIAlertAction(title: "确定", style: .default, handler: {(alertAction) in
                    let alert1 = UIAlertController(title: "正在修改通知", message: "请稍后", preferredStyle: .alert)
                    self.present(alert1, animated: true, completion: {})
                    let manager = singleClassManager.manager
                    let requestUrl = urlStruct.basicUrl + "notification/" + "\(self.notificationListModel.notificationEnitys[indexPath.row].id).json"
                    manager.requestSerializer.setValue(self.token, forHTTPHeaderField: "token")
                    manager.post(requestUrl, parameters: ["title": editalert.textFields![0].text!,"content": editalert.textFields![1].text!], progress: {(progress) in }, success: {
                        (dataTask,response) in
                        print("success")
                        alert1.dismiss(animated: true, completion: nil)
                        self.pullToRefresh()
                    
                    }, failure: {(dataTask,error) in
                        print(error)
                        alert1.dismiss(animated: true, completion: nil)
                        let alert2 = UIAlertController(title: "修改失败", message: "请检查网络连接", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        self.present(alert2, animated: true, completion: nil)
                    
                    })
                
                })
                editalert.addAction(action)
                editalert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(editalert, animated: true, completion: nil)
            })
            let deleteAction = UIAlertAction(title: "删除", style: .default, handler: {(alertAction) in
                let deleteAlert = UIAlertController(title: "是否删除", message: "", preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "是", style: .default, handler: {(_) in
                    let alert1 = UIAlertController(title: "正在删除通知", message: "请稍后", preferredStyle: .alert)
                    self.present(alert1, animated: true, completion: {})
                    let manager = AFHTTPSessionManager()
                    let requestUrl = urlStruct.basicUrl + "notification/" + "\(self.notificationListModel.notificationEnitys[indexPath.row].id).json"
                    manager.requestSerializer.setValue(self.token, forHTTPHeaderField: "token")
                    manager.delete(requestUrl, parameters: [], success: {
                        (dataTask,response) in
                        print("success")
                        alert1.dismiss(animated: true, completion: nil)
                        self.pullToRefresh()
                    
                    }, failure: {(dataTask,error) in
                        print(error)
                        alert1.dismiss(animated: true, completion: nil)
                        let alert2 = UIAlertController(title: "删除失败", message: "请检查网络连接", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        self.present(alert2, animated: true, completion: nil)
                    
                    })
                }))
                deleteAlert.addAction(UIAlertAction(title: "否", style: .cancel, handler: nil))
                self.present(deleteAlert, animated: true, completion: nil)
        
            })
            alert.addAction(editNotificationAction)
            alert.addAction(deleteAction)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationListModel.notificationEnitys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! NotificationTableViewCell
        cell.notificationTitleLabel.text = notificationListModel.notificationEnitys[indexPath.row].title
        cell.commentCountLabel.text = "\(notificationListModel.notificationEnitys[indexPath.row].commentCount)"
        cell.creatAtLabel.text = notificationListModel.notificationEnitys[indexPath.row].creatAt.date
        cell.notificationContentTextView.text = notificationListModel.notificationEnitys[indexPath.row].content
        cell.commentButton.tag = indexPath.row//把行的索引传给按钮，来区分哪一行的按钮被按下
        cell.commentButton.addTarget(self, action: "toCommentList:", for: .touchUpInside)
        return cell
    }
    //pull Data TableView delegate
    func pullToRefresh() {
        print("pull")
        notificationListModel.refreshNotification(activityId: activityId)
    }
    func loadMore() {
        
        notificationListModel.getNotification(activityId: activityId)
    }
    
    
    
    //MARK: - pull data Delegate
    func needUpdateUI() {
        notificationTableView.updateTableViewUIWhenPullDataEnd()
        notificationTableView.reloadData()
    }
    func getDataFailed() {
        notificationTableView.updateTableViewUIWhenPullDataEnd()
        let alert = UIAlertController(title: "无法连接", message: "请检查网络连接  ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.notificationToComment
        {
            if let controller = segue.destination as? commentListViewController
            {
                controller.id = notificationListModel.notificationEnitys[sender as! Int].id
                controller.type = "notification"
            }
        }
        
        
    }
    

}
