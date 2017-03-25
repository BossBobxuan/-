//
//  commentListViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/25.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class commentListViewController: UIViewController, PullDataDelegate, UITableViewDelegate, UITableViewDataSource {
    var type: String = "" //获取评论类型
    var id: Int!
    var commentListModel: CommentListModel!
    private var loadingstateUI:UIActivityIndicatorView!//加载更多的状态菊花
    private var btn:UIButton!//加载更多的按钮
    @IBOutlet weak var commentListTableView: UITableView!
        {
        didSet{
            commentListTableView.delegate = self
            commentListTableView.dataSource = self
        }
    }
    //MARK: - event func
    //点击用户头像跳转到相应的用户信息界面
    func clickAvatar(_ sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: seguename.commentToUserInformation, sender: sender.view!.tag)
    }
    
    
    
    
    //下拉更新
    func pullToRefresh()
    {
        print("下拉刷新")
        commentListModel.refreshCommentList(id: id, type: type)
        
    }
    //该方法用于加载更多数据与视图更新
    func loadMore(_ sender: UIButton)
    {
        btn.isHidden = true
        loadingstateUI.startAnimating()
        commentListModel.getCommentList(id: id, type: type)
        
        
    }
    
    
    //MARK: - view controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentListModel = CommentListModel(delegate: self)
        commentListModel.getCommentList(id: id, type: type)
        
        self.commentListTableView.refreshControl = UIRefreshControl()
        self.commentListTableView.refreshControl?.addTarget(self, action: "pullToRefresh", for: .valueChanged)
        self.commentListTableView.refreshControl?.attributedTitle = NSAttributedString(string: "刷新中")
        //增加读取更多数据的按钮
        addGetMorebtn()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - tableview Delegate
    
    
    
    
    //MARK: - tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentListModel.commentEnitys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! commentTableViewCell
        cell.userNameLabel.text = commentListModel.commentEnitys[indexPath.row].creator.name
        cell.creatAtLabel.text = commentListModel.commentEnitys[indexPath.row].creatAt.date
        cell.commentTextView.text = commentListModel.commentEnitys[indexPath.row].content
        let media = commentListModel.commentEnitys[indexPath.row].creator.avatar!
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
        cell.userAvatarImageView.isUserInteractionEnabled = true
        cell.userAvatarImageView.tag = commentListModel.commentEnitys[indexPath.row].creator.id//用于点击时识别是哪一个点击源
        cell.userAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "clickAvatar:"))
        return cell
    }
    
    //MARK: - Pull Data Delegate
    func needUpdateUI() {
        if self.commentListTableView.refreshControl?.isRefreshing == true
        {
            self.commentListTableView.refreshControl?.endRefreshing()
           
        }
        if self.loadingstateUI.isAnimating == true
        {
            loadingstateUI.stopAnimating()
            btn.isHidden = false
            
            
        }
        commentListTableView.reloadData()
    }
    func getDataFailed() {
        if self.commentListTableView.refreshControl?.isRefreshing == true
        {
            self.commentListTableView.refreshControl?.endRefreshing()
            
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
    
    
    //MARK: - other func
    private func addGetMorebtn()
    {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        self.commentListTableView.tableFooterView = view
        btn = UIButton(type: .system)
        btn.setTitle("加载更多", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        btn.addTarget(self, action: "loadMore:", for: .touchUpInside)
        view.addSubview(btn)
        loadingstateUI = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingstateUI.center = btn.center
        view.addSubview(loadingstateUI)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.commentToUserInformation
        {
            if let controller = segue.destination as? PersonalInfomationViewController
            {
                controller.uid = (sender! as! Int)
            }
        }
        
        
        
    }
    

}
