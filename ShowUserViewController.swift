//
//  ShowUserViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/18.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class ShowUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PullDataDelegate {
    var type:String! //表示展示关注者还是被关注者还是参与者
    var followersOrFansModel: FollowersOrFansModel!
    var uid: Int? //可以作为用户id与活动id
    
    private var loadingstateUI:UIActivityIndicatorView!//加载更多的状态菊花
    private var btn:UIButton!//加载更多的按钮
    @IBOutlet weak var UserTableView: UITableView!
        {
            didSet
            {
                UserTableView.delegate = self
                UserTableView.dataSource = self
                UserTableView.contentInset.top = -60//在此处设置防止cell不顶在上部
        }
    }
    
    //MARK: - Event func
    
    //下拉更新
    func pullToRefresh()
    {
        print("下拉刷新")
        
        if uid != nil
        {
            followersOrFansModel.FreshFollowersOrFans(uid: uid!,token: token)
           
        }else
        {
        
            //token需要更改
            followersOrFansModel.FreshFollowersOrFans(token: token)
        }
        
    }
    //该方法用于加载更多数据与视图更新
    func loadMore(_ sender: UIButton)
    {
        btn.isHidden = true
        loadingstateUI.startAnimating()
        if uid != nil
        {
            followersOrFansModel.GetFollowersOrFansList(uid: uid!,token: token)
        }else
        {
            //token需要更改
            followersOrFansModel.GetFollowersOrFansList(token: token)
            
        }
        
        
    }
    //更改关注状态
    func changeStateOfFollow(_ sender: haveUidButton)
    {
        if sender.titleLabel?.text == "互相关注"
        {
            followersOrFansModel.notFollow(uid: sender.uid!,token: token)
            sender.setTitle("被关注", for: .normal)
        }
        else if sender.titleLabel?.text == "被关注"
        {
            followersOrFansModel.addFollow(uid: sender.uid!,token: token)
            sender.setTitle("互相关注", for: .normal)
        }
        else if sender.titleLabel?.text == "已关注"
        {
            followersOrFansModel.notFollow(uid: sender.uid!,token: token)
            sender.setTitle("未关注", for: .normal)
        }
        else if sender.titleLabel?.text == "未关注"
        {
            followersOrFansModel.addFollow(uid: sender.uid!,token: token)
            sender.setTitle("已关注", for: .normal)
        }
        
      
    }
    
    
    
    //MARK: - viewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        followersOrFansModel = FollowersOrFansModel(delegate: self, type: type)
        
        
        if uid != nil
        {
            followersOrFansModel.GetFollowersOrFansList(uid: uid!,token: token)
        }else
        {
            //token需要更改
            followersOrFansModel.GetFollowersOrFansList(token: token)
            
        }
       
        
        //增加下拉更新与加载更多
        self.UserTableView.refreshControl = UIRefreshControl()
        self.UserTableView.refreshControl?.addTarget(self, action: "pullToRefresh", for: .valueChanged)
        self.UserTableView.refreshControl?.attributedTitle = NSAttributedString(string: "刷新中")
        //增加读取更多数据的按钮
        addGetMorebtn()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - tableViewDelegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: seguename.toUserInformation, sender: followersOrFansModel.userInformationEnitys[indexPath.row])
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - tableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersOrFansModel.userInformationEnitys.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! UserInformationTableViewCell
        cell.nameLabel.text = followersOrFansModel.userInformationEnitys[indexPath.row].name
        cell.discriptionTextView.text = followersOrFansModel.userInformationEnitys[indexPath.row].description
        if let media = followersOrFansModel.userInformationEnitys[indexPath.row].avatar
        {
            //在此处异步获取头像照片
            //在此处下载头像照片
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: url)!)
                {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data)
                        {
                            cell.avatarImageView.image = image
                        }
                    }
                }
            }
        }
        cell.followStateButton.uid = followersOrFansModel.userInformationEnitys[indexPath.row].id
        cell.followStateButton.addTarget(self, action: "changeStateOfFollow:", for: .touchUpInside)
        let relation = followersOrFansModel.userInformationEnitys[indexPath.row].relation
        if relation == "follower"
        {
            cell.followStateButton.setTitle("已关注", for: .normal)
        }
        else if relation == "fans"
        {
            cell.followStateButton.setTitle("被关注", for: .normal)
            
        }
        else if relation == "friend"
        {
            cell.followStateButton.setTitle("互相关注", for: .normal)
        }
        else if relation == "myself"
        {
            //cell.followStateButton.isHidden = true
            //做测试先显示按钮
            cell.followStateButton.setTitle("自己", for: .normal)
            cell.followStateButton.isEnabled = false
        }
        else if relation == "stranger"
        {
            cell.followStateButton.setTitle("未关注", for: .normal)
        }
        return cell
    }
    
    
    
    //MARK: - PullDataDelegate
    func needUpdateUI() {
        
        if self.UserTableView.refreshControl?.isRefreshing == true
        {
            self.UserTableView.refreshControl?.endRefreshing()
        }
        if self.loadingstateUI.isAnimating == true
        {
            loadingstateUI.stopAnimating()
            btn.isHidden = false
            
        }
        UserTableView.reloadData()
        
    }
    
    func getDataFailed() {
        if self.UserTableView.refreshControl?.isRefreshing == true
        {
            self.UserTableView.refreshControl?.endRefreshing()
        }
        if self.loadingstateUI.isAnimating == true
        {
            loadingstateUI.stopAnimating()
            btn.isHidden = false
            
        }
        let alert = UIAlertController(title: "获取数据失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    //MARK: - prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguename.toUserInformation
        {
            if let controller = segue.destination as? PersonalInfomationViewController
            {
                controller.uid = (sender as! UserInformationEnity).id
                controller.title = (sender as! UserInformationEnity).name
                
            }
        }
            
    }
    
    //MARK: - other func
    //添加加载更多的按钮
    private func addGetMorebtn()
    {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        self.UserTableView.tableFooterView = view
        btn = UIButton(type: .system)
        btn.setTitle("加载更多", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        btn.addTarget(self, action: "loadMore:", for: .touchUpInside)
        view.addSubview(btn)
        loadingstateUI = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingstateUI.center = btn.center
        view.addSubview(loadingstateUI)
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
