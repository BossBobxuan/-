//
//  commentDetailViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/26.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
//该页面用于显示指定评论的所有子评论
class commentDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PullDataDelegate, replyCommentDelegate {
    var commentId : Int!
    @IBOutlet weak var childCommentTableView: UITableView!
    var childCommentListModel: CommentListModel!
    private var loadingstateUI:UIActivityIndicatorView!//加载更多的状态菊花
    private var btn:UIButton!//加载更多的按钮
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        childCommentTableView.delegate = self
        childCommentTableView.dataSource = self
        childCommentListModel = CommentListModel(delegate: self)
        childCommentListModel.getChildComment(commentId: commentId)
        
        self.childCommentTableView.refreshControl = UIRefreshControl()
        self.childCommentTableView.refreshControl?.addTarget(self, action: "pullToRefresh", for: .valueChanged)
        self.childCommentTableView.refreshControl?.attributedTitle = NSAttributedString(string: "刷新中")
        //增加读取更多数据的按钮
        addGetMorebtn()

        
        self.navigationItem.title = "子评论详情"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - event func
    func replyComment(_ sender: UIButton)
    {
        performSegue(withIdentifier: seguename.childToReplyComment, sender: sender.tag)
    }
    func clickAvatar(_ sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: seguename.childCommentToUserInformation, sender: sender.view!.tag)
    }
    
    
    func pullToRefresh()
    {
        print("下拉刷新")
        childCommentListModel.refreshChildComment(commentId: commentId)
        
    }
    //该方法用于加载更多数据与视图更新
    func loadMore(_ sender: UIButton)
    {
        btn.isHidden = true
        loadingstateUI.startAnimating()
        childCommentListModel.getChildComment(commentId: commentId)
        
        
    }
    
    //MARK: - tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    //MARK: - tableView datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childCommentListModel.commentEnitys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! commentTableViewCell
        print(childCommentListModel.commentEnitys[indexPath.row].creator.name)
        cell.userNameLabel.text = childCommentListModel.commentEnitys[indexPath.row].creator.name
        cell.creatAtLabel.text = childCommentListModel.commentEnitys[indexPath.row].creatAt.date
        cell.commentTextView.text = childCommentListModel.commentEnitys[indexPath.row].content
        let media = childCommentListModel.commentEnitys[indexPath.row].creator.avatar!
        let url = urlStruct.basicUrl + "media/" + "\(media)"
        cell.replyButton.tag = indexPath.row//传递在model数组中的位置给reply按钮
        cell.replyButton.addTarget(self, action: "replyComment:", for: .touchUpInside)
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
        cell.userAvatarImageView.tag = childCommentListModel.commentEnitys[indexPath.row].creator.id//用于点击时识别是哪一个点击源
        cell.userAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "clickAvatar:"))
        return cell
    }
    
    //MARK: - pull data delegate
    func getDataFailed() {
        if self.childCommentTableView.refreshControl?.isRefreshing == true
        {
            self.childCommentTableView.refreshControl?.endRefreshing()
            
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
    func needUpdateUI() {
        if self.childCommentTableView.refreshControl?.isRefreshing == true
        {
            self.childCommentTableView.refreshControl?.endRefreshing()
            
        }
        if self.loadingstateUI.isAnimating == true
        {
            loadingstateUI.stopAnimating()
            btn.isHidden = false
            
            
        }
        childCommentTableView.reloadData()
    }
    
    
    //MARK: - replycomment delegate
    func successToreply()
    {
        let alert = UIAlertController(title: "成功", message: "评论成功", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func failToreply()
    {
        let alert = UIAlertController(title: "评论失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func addGetMorebtn()
    {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        self.childCommentTableView.tableFooterView = view
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
        if segue.identifier == seguename.childCommentToUserInformation
        {
            if let controller = segue.destination as? PersonalInfomationViewController
            {
                controller.uid = (sender! as! Int)
            }
        }else if segue.identifier == seguename.childToReplyComment
        {
            if let controller = segue.destination as? replyCommentViewController
            {
                let modelIndex = sender! as! Int
                controller.attachId = childCommentListModel.commentEnitys[modelIndex].attachId
                controller.attachType = childCommentListModel.commentEnitys[modelIndex].attachType
                controller.parentCommentId = childCommentListModel.commentEnitys[modelIndex].id
                controller.delegate = self
            }
        }
        
        
    }
    

}
