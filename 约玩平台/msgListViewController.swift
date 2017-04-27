//
//  msgListViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/12.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class msgListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PullDataDelegate, havePullfreshAndLoadmoreTableViewDelegate {
    @IBOutlet weak var msgListTableView: havePullfreshAndLoadmoreTableView!
    var model: privateModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        model = privateModel(delegate: self)
        msgListTableView.delegate = self
        msgListTableView.dataSource = self
        msgListTableView.pullDataDelegate = self
        model.getMessageList(token: token)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        if indexPath.row == 0
        {
            //MARK: - 此处进入评论列表
            performSegue(withIdentifier: seguename.msgListToCommentList, sender: nil)
        }else
        {
            (tableView.cellForRow(at: indexPath) as! msgTableViewCell).notReadCountLabel.isHidden = true
            performSegue(withIdentifier: seguename.msgLIstToDetail, sender: indexPath.row - 1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 40
        }else
        {
            return 80
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.Enitys.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = UITableViewCell()
            cell.textLabel?.text = "点击查看评论消息"
            cell.textLabel?.textAlignment = .center
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell") as! msgTableViewCell
            cell.nameLabel.text = model.Enitys[indexPath.row - 1].targetName//MARK: - 需要更改
            cell.contentLabel.text = model.Enitys[indexPath.row - 1].recent.content
            cell.creatAtLabel.text = model.Enitys[indexPath.row - 1].recent.creatAt.dateNotYear
            if model.Enitys[indexPath.row - 1].privateCount != 0
            {
                cell.notReadCountLabel.text = "\(model.Enitys[indexPath.row - 1].privateCount)"
            }else
            {
                cell.notReadCountLabel.isHidden = true
            }
            
            let media = model.Enitys[indexPath.row - 1].avatar
            
                //在此处异步获取头像照片
                //在此处下载头像照片
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            if let image = self.getImageFromCaches(mediaId: media)
            {
                cell.avatarImageView.image = image
                
            }else
            {
                    
                DispatchQueue.global().async {
                    
                    if let data = try? Data(contentsOf: URL(string: url)!)
                    {
                        print("获取数据")
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data)
                            {
                                print("显示图片")
                                cell.avatarImageView.image = image
                                self.saveImageCaches(image: image, mediaId: media)
                            }
                        }
                    }
                }
            }
            return cell
        }
        
    }
    
    func loadMore() {
        model.getMessageList(token: token)
    }
    
    func pullToRefresh() {
        model.freshMessageList(token: token)
    }
    
    
    
    
    func needUpdateUI() {
        self.msgListTableView.updateTableViewUIWhenPullDataEnd()
        self.msgListTableView.reloadData()
        
        
    }
    func getDataFailed() {
        self.msgListTableView.updateTableViewUIWhenPullDataEnd()
        let alert = UIAlertController(title: "获取列表失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.msgLIstToDetail
        {
            if let controller = segue.destination as? msgDetailViewController
            {
                controller.uid = model.Enitys[sender! as! Int].targetId
            }
        }else if segue.identifier == seguename.msgListToCommentList
        {
            if let controller = segue.destination as? commentListViewController
            {
                controller.type = "me"
            }
        }
        
        
    }


}
