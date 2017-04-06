//
//  TimeLineViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/6.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController, PullDataDelegate, UITableViewDelegate, UITableViewDataSource, havePullfreshAndLoadmoreTableViewDelegate{
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var timeLineTableView: havePullfreshAndLoadmoreTableView!
    var model: timeLineModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        model = timeLineModel(delegate: self)
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        timeLineTableView.pullDataDelegate = self
        model.getUserTimeLine(token: token)
        timeLineTableView.btn.isHidden = true//不使用加载更多
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        switch model.status[indexPath.row] {
        case "0":
            performSegue(withIdentifier: seguename.timelineToUser, sender: indexPath.row)
        case "1":
            performSegue(withIdentifier: seguename.timeLineToActivity, sender: indexPath.row)
        case "2":
            //MARK : - 图片暂时缺失
            break
        case "3":
            performSegue(withIdentifier: seguename.timeLIneToNotification, sender: indexPath.row)
        case "4":
            performSegue(withIdentifier: seguename.timeLIneToComment, sender: indexPath.row)
        default:
            break
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.Enitys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch model.status[indexPath.row] {
        case "0":
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! timelineUserTableViewCell
            cell.nameLabel.text = model.userName + "关注用户"
            cell.userNameLabel.text = (model.Enitys[indexPath.row] as! UserInformationEnity).name
            let media = (model.Enitys[indexPath.row] as! UserInformationEnity).avatar!
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            DispatchQueue.global().async {
                
                if let data = try? Data(contentsOf: URL(string: url)!)
                {
                    
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data)
                        {
                            
                            cell.userAvatarImageView.image = image
                        }
                    }
                }
            }
            let media2 = model.userAvatarId
            let url2 = urlStruct.basicUrl + "media/" + "\(media2!)"
            print(url2)
            DispatchQueue.global().async {
                print("2")
                if let data = try? Data(contentsOf: URL(string: url2)!)
                {
                    
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data)
                        {
                            
                            cell.avatarImageView.image = image
                        }
                    }
                }
            }
            return cell
        case "1":
            let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell") as! timelineActivityTableViewCell
            cell.nameLabel.text = model.userName + "创建修改或参与活动"
            cell.activityTitleLabel.text = (model.Enitys[indexPath.row] as! ActiveEnity).activityTitle
            let media = (model.Enitys[indexPath.row] as! ActiveEnity).image
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            DispatchQueue.global().async {
                
                if let data = try? Data(contentsOf: URL(string: url)!)
                {
                    
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data)
                        {
                            
                            cell.activityImageImageView.image = image
                        }
                    }
                }
            }
            let media2 = model.userAvatarId
            let url2 = urlStruct.basicUrl + "media/" + "\(media2!)"
            print(url2)
            DispatchQueue.global().async {
                
                if let data = try? Data(contentsOf: URL(string: url2)!)
                {
                    print("2")
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data)
                        {
                            
                            cell.avatarImageView.image = image
                        }
                    }
                }
            }
            return cell
        case "2":
            //MARK: - 尚未添加图片
            let cell = UITableViewCell()
            return cell
        case "3":
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as! timelineNotificationTableViewCell
            cell.nameLabel.text = model.userName + "发布通知"
            cell.notificationTitle.text = (model.Enitys[indexPath.row] as! NotificationEnity).title
            cell.contentTextView.text = (model.Enitys[indexPath.row] as! NotificationEnity).content
            let media2 = model.userAvatarId
            let url2 = urlStruct.basicUrl + "media/" + "\(media2!)"
            print(url2)
            DispatchQueue.global().async {
                
                if let data = try? Data(contentsOf: URL(string: url2)!)
                {
                    print("2")
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data)
                        {
                            
                            cell.avatarImageView.image = image
                        }
                    }
                }
            }
            return cell
        case "4":
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! timelineCommentTableViewCell
            cell.nameLabel.text = model.userName + "发表评论"
            cell.commentTextView.text = (model.Enitys[indexPath.row] as! CommentEnity).content
            let media2 = model.userAvatarId
            print(model.userAvatarId)
            let url2 = urlStruct.basicUrl + "media/" + "\(media2!)"
            print(url2)
            DispatchQueue.global().async {
                
                if let data = try? Data(contentsOf: URL(string: url2)!)
                {
                    print("2")
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data)
                        {
                            
                            cell.avatarImageView.image = image
                        }
                    }
                }
            }
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    
    
    
    func pullToRefresh() {
        model.getUserTimeLine(token: token)
    }
    func loadMore() {
        
    }
    
    func needUpdateUI() {
        timeLineTableView.updateTableViewUIWhenPullDataEnd()
        timeLineTableView.reloadData()
    }
    
    func getDataFailed() {
        timeLineTableView.updateTableViewUIWhenPullDataEnd()
        let alert = UIAlertController(title: "获取数据失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.timeLIneToComment
        {
            if let controller = segue.destination as? commentListViewController
            {
                controller.id = (model.Enitys[sender! as! Int] as! CommentEnity).attachId
                switch (model.Enitys[sender! as! Int] as! CommentEnity).attachType {
                case "0":
                    controller.type = "activity"
                case "1":
                    controller.type = "photo"
                case "2":
                    controller.type = "notification"
                default:
                    break
                }
            }
        }else if segue.identifier == seguename.timeLIneToNotification
        {
            if let controller = segue.destination as? NotificationListViewController
            {
                controller.activityId = (model.Enitys[sender! as! Int] as! NotificationEnity).activityId
                controller.havePowerToEdit = true
            }
        }else if segue.identifier == seguename.timelineToUser
        {
            if let controller = segue.destination as? PersonalInfomationViewController
            {
                controller.uid = (model.Enitys[sender! as! Int] as! UserInformationEnity).id
            }
        }else if segue.identifier == seguename.timeLineToActivity
        {
            if let controller = segue.destination as? ActicityDetailViewController
            {
                controller.activityModel.activityEnity = (model.Enitys[sender! as! Int] as! ActiveEnity)
            }
        }
        
        
    }
    

}
