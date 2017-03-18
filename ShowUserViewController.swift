//
//  ShowUserViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/18.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class ShowUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PullDataDelegate {
    var type:String! //表示展示关注者还是被关注者
    var followersOrFansModel: FollowersOrFansModel!
    var uid: Int?
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
    func pullToRefresh()
    {
        print("下拉刷新")
        if uid != nil
        {
            followersOrFansModel.FreshFollowersOrFans(uid: uid!)
        }else
        {
        
            //token需要更改
            followersOrFansModel.FreshFollowersOrFans(token: "2222")
        }
        
    }
    //该方法用于加载更多数据与视图更新
    func loadMore(_ sender: UIButton)
    {
        btn.isHidden = true
        loadingstateUI.startAnimating()
        if uid != nil
        {
            followersOrFansModel.GetFollowersOrFansList(uid: uid!)
        }else
        {
            //token需要更改
            followersOrFansModel.GetFollowersOrFansList(token: "2222")
            
        }
        
        
    }
    
    //MARK: - viewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        followersOrFansModel = FollowersOrFansModel(delegate: self, type: type)
        
        
        if uid != nil
        {
            followersOrFansModel.GetFollowersOrFansList(uid: uid!)
        }else
        {
            //token需要更改
            followersOrFansModel.GetFollowersOrFansList(token: "2222")
            
        }
       
        
        //增加下拉更新与加载更多
        self.UserTableView.refreshControl = UIRefreshControl()
        self.UserTableView.refreshControl?.addTarget(self, action: "pullToRefresh", for: .valueChanged)
        self.UserTableView.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新活动")
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
    }
    
    
    
    //MARK: - tableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersOrFansModel.userInformationEnitys.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default")
        cell?.textLabel?.text = followersOrFansModel.userInformationEnitys[indexPath.row].name
        return cell!
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
                controller.uid = (sender as! UserInfomationEnity).id
                controller.title = (sender as! UserInfomationEnity).name
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
