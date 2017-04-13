//
//  PersonalInfomationViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/16.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
struct seguename {
    static let toFollowersView = "segueToFollowersList"
    static let toFansView = "segueToFansList"
    static let toUserInformation = "segueToUserInformation"
    static let toEditPersonalInformation = "segueToEditPersonalInformation"
    static let toActivityDetail = "segueToActivityDetail"
    static let toActivityUserIn = "segueToActivityUserIn"
    static let toComment = "segueToComment"
    static let commentToUserInformation = "commentSegueToUserInformation"
    static let toReplyComment = "segueToReplyComment"
    static let toChildComment = "segueToChildComment"
    static let childToReplyComment = "childSegueToReplyComment"
    static let childCommentToUserInformation = "childCommentSegueToUserInformation"
    static let toEditActivity = "segueToEditActivity"
    static let toLocationSelect = "segueToLocationSelect"
    static let toAddActivity = "segueToAddActivity"
    static let toNotificationTableView = "segueToNotificationTableView"
    static let notificationToComment = "notificationSegueToCommentList"
    static let toActivityLocation = "segueToActivityLocation"
    static let hotActivityToDetail = "hotActivityToDetail"
    static let hotActivityToCommentList = "hotActivityToCommentList"
    static let signupToMain = "signUpToMain"
    static let logInToMain = "loginToMain"
    static let firstViewToMain = "firstViewToMain"
    static let timelineToUser = "timeLineToUser"
    static let timeLineToActivity = "timeLineToActivity"
    static let timeLIneToNotification = "timeLIneToNotification"
    static let timeLIneToComment = "timeLIneToComment"
    static let toActivityPhoto = "segueToActivityPhoto"
    static let photoListToDetail = "photoListToDetail"
    static let photoDetailToComment = "photoDetailToComment"
    static let timeLineToPhotoDetail = "timeLineToPhotoDetail"
    static let timeLineToSearch = "timeLineToSearch"
    static let searchToUserInformation = "searchToUserInformation"
    static let searchToActivityDetail = "searchToActivityDetail"
    static let msgLIstToDetail = "msgLIstToDetail"
    
}
class PersonalInfomationViewController: UIViewController, PullDataDelegate, getUserActivityDelegate, UITableViewDelegate, UITableViewDataSource {
    //MARK: - outlet
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fansCountsLabel: UILabel!
    @IBOutlet weak var followerCountsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityTypeSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var followButton: UIButton!
    private var loadingstateUI:UIActivityIndicatorView!//加载更多的状态菊花
    private var btn:UIButton!//加载更多的按钮
    private var nowtype: String
        {
        if activityTypeSegmentControl.selectedSegmentIndex == 0
        {
            //参与
            return ActivityRequestType.participated
            
        }
        else if activityTypeSegmentControl.selectedSegmentIndex == 1
        {
            //感兴趣
            return ActivityRequestType.wished
        }
        else if activityTypeSegmentControl.selectedSegmentIndex == 2
        {
            //发布
            return ActivityRequestType.created
        }
        else
        {
            return "error"
        }
    }
    
    fileprivate var personalInformationModel: PersonalInformationModel!
    fileprivate var activityModel: UserActivityListModel!
    var uid: Int?
    
    @IBOutlet weak var activityListTableView: UITableView!
    //MARK: - Event func
    
    
    
    func editPersonalInformation(_ sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: seguename.toEditPersonalInformation, sender: self)
    }
    //此函数用于改变用户活动列表（感兴趣，参加，发布）
    @IBAction func needChangeUserActivityShowList(_ sender: UISegmentedControl)
    {
        activityListTableView.reloadData()
    }
    
    //下拉更新
    func pullToRefresh()
    {
        print("下拉刷新")
        activityTypeSegmentControl.isEnabled = false
        if uid != nil
        {
            activityModel.refreshUserActivity(activityId: uid!,type: nowtype)
            
        }else
        {
            
            //token需要更改
           
            activityModel.refreshUserActivity(token: token,type: nowtype)
        }
        
    }
    //该方法用于加载更多数据与视图更新
    func loadMore(_ sender: UIButton)
    {
        btn.isHidden = true
        loadingstateUI.startAnimating()
        activityTypeSegmentControl.isEnabled = false
        if uid != nil
        {
            activityModel.getUserActivity(activityId: uid!, type: nowtype)
        }else
        {
            activityModel.getUserActivity(token: token, type: nowtype)
            
        }
        
        
    }
    
    @IBAction func addFollowOrCancel(_ sender: UIButton) {
        if sender.titleLabel?.text == "关注"
        {
            personalInformationModel.followUser(uid: uid!,token: token,success:{sender.isEnabled = true})
            sender.setTitle("已关注", for: .normal)
            sender.isEnabled = false
        }else if sender.titleLabel?.text == "已关注"
        {
            personalInformationModel.notFollowUser(uid: uid!, token: token,success:{sender.isEnabled = true})
            sender.setTitle("关注", for: .normal)
            sender.isEnabled = false
        }
    }
    //退出登录
    func exitLogin(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "是否退出登录", message: "", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "是", style: .default, handler: {(alert) in
            let userd = UserDefaults.standard
            userd.removeObject(forKey: "token")
            userd.removeObject(forKey: "refreshToken")
            let _ = self.navigationController!.tabBarController!.dismiss(animated: true, completion: nil)
        })
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "否", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - 此处不太好，但是可以解决实时更新的问题
    
    
    
    //MARK: - viewController lifecycle
    override func viewWillAppear(_ animated: Bool) {
        if uid != nil
        {
            personalInformationModel.getUserInformation(uid: uid!,token: token)
            
            //MARK: - 若有bug此处考虑更改为fresh
            activityModel.getUserActivity(activityId: uid!, type: ActivityRequestType.participated)
            activityModel.getUserActivity(activityId: uid!, type: ActivityRequestType.wished)
            activityModel.getUserActivity(activityId: uid!, type: ActivityRequestType.created)
            
            
            
        }else
        {
            let editBar = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: "editPersonalInformation:")
            let exitBar = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: "exitLogin:")
            self.navigationItem.rightBarButtonItems = [editBar,exitBar]
            followButton.isHidden = true
            activityModel.getUserActivity(token: token, type: ActivityRequestType.participated)
            activityModel.getUserActivity(token: token, type: ActivityRequestType.wished)
            activityModel.getUserActivity(token: token, type: ActivityRequestType.created)
            //此处token需要更改
            personalInformationModel.getPersonalInformation(token: token)
        }
    }
        
    
        
        
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.activityListTableView.delegate = self
        self.activityListTableView.dataSource = self
        
        self.personalInformationModel = PersonalInformationModel(delegate: self)
        self.activityModel = UserActivityListModel(delegate: self)
        //此处以后需要更改该token
       
        
        self.activityListTableView.refreshControl = UIRefreshControl()
        self.activityListTableView.refreshControl?.addTarget(self, action: "pullToRefresh", for: .valueChanged)
        self.activityListTableView.refreshControl?.attributedTitle = NSAttributedString(string: "刷新中")
        //增加读取更多数据的按钮
        addGetMorebtn()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - delegate
    //此函数用于拉取数据后更新UI
    func needUpdateUI()
    {
        self.nameLabel.text = personalInformationModel.personalInformationEnity!.name
        self.descriptionTextView.text = personalInformationModel.personalInformationEnity!.description
        self.fansCountsLabel.text = "\(personalInformationModel.personalInformationEnity!.fansCount)"
        self.followerCountsLabel.text = "\(personalInformationModel.personalInformationEnity!.followersCount)"
        if uid != nil
        {
            if personalInformationModel.personalInformationEnity?.relation == "follower" || personalInformationModel.personalInformationEnity?.relation == "friend"
            {
                followButton.setTitle("已关注", for: .normal)
            }else if personalInformationModel.personalInformationEnity?.relation == "myself"
            {
                followButton.isHidden = true
            }
            else
            {
                followButton.setTitle("关注", for: .normal)
            }
        }
        
        
        
        if let media = personalInformationModel.personalInformationEnity!.avatar
        {
            //在此处下载头像照片
            print("进入")
            
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            if let image = self.getImageFromCaches(mediaId: media)
            {
                self.avatarImageView.image = image
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
                                self.avatarImageView.image = image
                                self.saveImageCaches(image: image, mediaId: media)
                            }
                        }
                    }
                }
            }
        }
        followButton.isEnabled = true
    }
    //此函数用于拉取数据失败的处理
    func getDataFailed()
    {
        let alert = UIAlertController(title: "获取数据失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "重试", style: .default, handler: {(_) in
            if self.uid != nil
            {
                self.personalInformationModel.getUserInformation(uid: self.uid!, token: self.token)
                
            }else
            {
                self.personalInformationModel.getPersonalInformation(token: self.token)
            }
        }))
        self.present(alert, animated: true, completion: nil)
        if !followButton.isEnabled//此处为真则代表是该按钮的请求失败，需要更改回请求前的状态
        {
            if followButton.titleLabel?.text == "已关注"
            {
                followButton.setTitle("关注", for: .normal)
            }else if followButton.titleLabel?.text == "关注"
            {
                followButton.setTitle("已关注", for: .normal)
            }
            followButton.isEnabled = true
        }
    }
    //MARK: - getUserActivity Delegate
    func getActivitySuccess() {
        if self.activityListTableView.refreshControl?.isRefreshing == true
        {
            self.activityListTableView.refreshControl?.endRefreshing()
            self.activityTypeSegmentControl.isEnabled = true
        }
        if self.loadingstateUI.isAnimating == true
        {
            loadingstateUI.stopAnimating()
            btn.isHidden = false
            self.activityTypeSegmentControl.isEnabled = true
            
        }
        activityListTableView.reloadData()
    }
    func getActivityfailed() {
        if self.activityListTableView.refreshControl?.isRefreshing == true
        {
            self.activityListTableView.refreshControl?.endRefreshing()
            self.activityTypeSegmentControl.isEnabled = true
        }
        if self.loadingstateUI.isAnimating == true
        {
            loadingstateUI.stopAnimating()
            btn.isHidden = false
            self.activityTypeSegmentControl.isEnabled = true
        }
        let alert = UIAlertController(title: "获取数据失败", message: "请检查网络连接", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: seguename.toActivityDetail, sender: activityModel.activityEnitys[nowtype]![indexPath.row])
        tableView.cellForRow(at: indexPath)!.isSelected = false
    }
    
    //MARK: - tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activityModel.activityEnitys[nowtype]!.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! simplyActivityTableViewCell
        cell.activityTitleLabel.text = activityModel.activityEnitys[nowtype]![indexPath.row].activityTitle
        cell.activityBeginTimeLabel.text = activityModel.activityEnitys[nowtype]![indexPath.row].beginTime.date
        cell.activityStateLabel.text = activityModel.activityEnitys[nowtype]![indexPath.row].stateString
        //异步获取头像
        let media = activityModel.activityEnitys[nowtype]![indexPath.row].image
        let url = urlStruct.basicUrl + "media/" + "\(media)"
        if let image = self.getImageFromCaches(mediaId: media)
        {
            cell.activityImageView.image = image
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
                            cell.activityImageView.image = image
                            self.saveImageCaches(image: image, mediaId: media)
                        }
                    }
                }
            }
        }
        return cell
        
        

       
    }
    
    //MARK: - prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguename.toFollowersView
        {
            
            if let controller = segue.destination as? ShowUserViewController
            {
                
                controller.type = "follower"
                controller.navigationItem.title = self.followerCountsLabel.text! + " 关注"
                controller.uid = uid
            }
        }
        else if segue.identifier == seguename.toFansView
        {
            if let controller = segue.destination as? ShowUserViewController
            {
                
                controller.type = "fan"
                controller.navigationItem.title = self.fansCountsLabel.text! + " 关注者"
                controller.uid = uid
            }
        }
        else if segue.identifier == seguename.toEditPersonalInformation
        {
            if let controller = segue.destination as? EditPersonalInformationViewController
            {
                controller.userInformationModel = personalInformationModel
                controller.avatarimage = avatarImageView.image
            }
        }
        else if segue.identifier == seguename.toActivityDetail
        {
            if let controller = segue.destination as? ActicityDetailViewController
            {
                
                print("segue")
                
                controller.activityModel.activityEnity = sender as! ActiveEnity
                
                if uid == nil && nowtype == ActivityRequestType.created//只有是自己创建的活动才有权限修改
                {
                    controller.havePowerToEdit = true
                }
            }
        }
    }
    
    //MARK: - other func
    //添加加载更多的按钮
    private func addGetMorebtn()
    {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        self.activityListTableView.tableFooterView = view
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

//MARK: - 添加使时间戳变为格式化时间的拓展
extension Int
{
    var date: String
        {
        let timeInterval:TimeInterval = TimeInterval(integerLiteral: Int64(self / 1000))
        let date = Date(timeIntervalSince1970: timeInterval)
        
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dformatter.string(from: date)
    }
    var dateNotYear: String
        {
        let timeInterval:TimeInterval = TimeInterval(integerLiteral: Int64(self / 1000))
        let date = Date(timeIntervalSince1970: timeInterval)
        
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "HH:mm"
        return dformatter.string(from: date)
    }
}
