//
//  ActivitylistViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/1/5.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class nowlocationAnnotation:NSObject,MKAnnotation
{
    var nowcoordinate:CLLocationCoordinate2D
    var coordinate: CLLocationCoordinate2D
        {
            return nowcoordinate
    }
    init(latitude:Double,longitude:Double)
    {
        nowcoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
class ActivitylistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,PullDataDelegate {
    
    fileprivate let key:[String] = ["全部","聚餐","运动","旅行","电影","音乐","分享会","赛事","桌游","其他"]
    fileprivate var model: ActivityListModel!
    fileprivate var loadingstateUI: UIActivityIndicatorView!//加载更多的状态菊花
    fileprivate var btn: UIButton!//加载更多的按钮
  
  
    private var nowType: String = "全部"//用于标记当前显示的活动类型
    private var beShowingActivity: [ActiveEnity] = []
    
    private var changeDisdance: CGFloat!
    
    @IBOutlet weak var activityTableView: UITableView!
    
    @IBOutlet weak var recommendActivityScrollView: UIScrollView!
    
    @IBOutlet weak var recommendUserScrollView: UIScrollView!
    @IBOutlet weak var selectScrollViewAndTableViewContainerView: UIView!
   

    @IBOutlet weak var selecteScrollView: UIScrollView!
    // MARK: - Event func
    
    //点击推荐活动的图进入活动细节
    func recommendImageTap(_ sender: UITapGestureRecognizer)
    {
        let index = sender.view!.tag
        performSegue(withIdentifier: seguename.hotActivityToDetail, sender: model.recommendActiveEnitys[index])
    }
    
    
    
    
    //添加推荐活动的滑动
    func leftslideswitch(_ sender : UISwipeGestureRecognizer)
    {
        
        print("left")
        UIView.animate(withDuration: 0.5, animations: {
            if self.recommendActivityScrollView.contentOffset.x != self.recommendActivityScrollView.contentSize.width - self.recommendActivityScrollView.frame.width
            {
                self.recommendActivityScrollView.contentOffset.x += self.recommendActivityScrollView.frame.width
            }
        })
        
        
    }
    func rightslideswtich(_ sender : UISwipeGestureRecognizer)
        
    {
        
        print("right")
        UIView.animate(withDuration: 0.5, animations: {
            if self.recommendActivityScrollView.contentOffset.x != 0
            {
                self.recommendActivityScrollView.contentOffset.x -= self.recommendActivityScrollView.frame.width
            }
        })
        
        
    }
    //该方法用于视图下移
    func ViewneedDown()
    {
        if selectScrollViewAndTableViewContainerView.frame.minY != recommendActivityScrollView.frame.minY
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.selectScrollViewAndTableViewContainerView.frame.origin.y -= self.changeDisdance
            })
            
            selectScrollViewAndTableViewContainerView.gestureRecognizers?.removeAll()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: "viewNeedUp")
        }
    }
    func viewNeedUp()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectScrollViewAndTableViewContainerView.frame.origin.y += self.changeDisdance
        })
        self.navigationItem.leftBarButtonItems?.removeAll()
        self.selectScrollViewAndTableViewContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "ViewneedDown"))
    }
    
    
    //该方法在选择标签时调用在此处更改展示内容
    func interestingLabelBeSelect(_ sender: UIButton)
    {
        nowType = sender.titleLabel!.text!

        beShowingActivity.removeAll()
        for activity in model.activeEnitys
        {
            if nowType == "全部"
            {
                beShowingActivity.append(activity)
            }
            else if activity.categoryString == nowType && nowType != "全部"
            {
                beShowingActivity.append(activity)
            }
        }

        activityTableView.reloadData()
    }
    //该方法用于下拉刷新时的数据获取与视图更新
    func pullToRefresh()
    {
        print("下拉刷新")
        model.refreshActivity()
        
    }
    //该方法用于加载更多数据与视图更新
    func loadMore(_ sender: UIButton)
    {
        btn.isHidden = true
        loadingstateUI.startAnimating()
        model.getActivity()
    }
    func toComment(_ sender: UIButton)
    {
        performSegue(withIdentifier: seguename.hotActivityToCommentList, sender: sender.tag)
    }
    
    
    // MARK: - viewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        addbtn(key: key,btnwidth: 50)
        
        activityTableView.delegate = self
        activityTableView.dataSource = self
        //初始化视图
        self.selectScrollViewAndTableViewContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "ViewneedDown"))
        changeDisdance = selectScrollViewAndTableViewContainerView.frame.minY - recommendActivityScrollView.frame.minY
        
        
        //初始化model
        model = ActivityListModel(delegate: self)
        model.getActivity()
        model.getRecommendActivity {
            [weak self] in
            self?.addRecommendActivity(enitys: self!.model.recommendActiveEnitys)
        }
        //以下代码用于增加tableview的下拉刷新行为
        self.activityTableView.refreshControl = UIRefreshControl()
        self.activityTableView.refreshControl?.addTarget(self, action: "pullToRefresh", for: .valueChanged)
        self.activityTableView.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新活动")
        //增加读取更多数据的按钮
        addGetMorebtn()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: - talbeView Datasource and delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beShowingActivity.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDisplayCell") as! ActivityDisplayTableViewCell
        cell.activityTitleLabel.text = beShowingActivity[indexPath.row].activityTitle
        cell.userNameLabel.text = beShowingActivity[indexPath.row].creator.name
        
        //异步获取图片
        let media = beShowingActivity[indexPath.row].image
        let url = urlStruct.basicUrl + "media/" + "\(media)"
        
        if let image = self.getImageFromCaches(mediaId: media)
        {
            cell.activityImageImageView.image = image
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
                            cell.activityImageImageView.image = image
                            self.saveImageCaches(image: image, mediaId: media)
                        }
                    }
                }
            }
        }
        let media2 = beShowingActivity[indexPath.row].creator.avatar
        let url2 = urlStruct.basicUrl + "media/" + "\(media2)"
        if let image = self.getImageFromCaches(mediaId: media2!)
        {
            cell.userAvatarImageView.image = image
        }else
        {
            
            DispatchQueue.global().async {
                
                if let data = try? Data(contentsOf: URL(string: url2)!)
                {
                    print("获取数据")
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data)
                        {
                            print("显示图片")
                            cell.userAvatarImageView.image = image
                            self.saveImageCaches(image: image, mediaId: media2!)
                        }
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = tableView.frame.width
       
        return (width / 2 + 80)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: seguename.hotActivityToDetail, sender: beShowingActivity[indexPath.row])
    }
 
    // MARK: - PullDataSuccessDelegate
    func getDataFailed()
    {
        if self.activityTableView.refreshControl?.isRefreshing == true
        {
            self.activityTableView.refreshControl?.endRefreshing()
        }
        if self.loadingstateUI.isAnimating == true
        {
            loadingstateUI.stopAnimating()
            btn.isHidden = false
            
        }
        
        let alert = UIAlertController(title: "无法连接", message: "请检查网络连接  ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    //请求数据成功后的回调
    func needUpdateUI() {
        
    
        if self.activityTableView.refreshControl?.isRefreshing == true
        {
            self.activityTableView.refreshControl?.endRefreshing()
        }
        if self.loadingstateUI.isAnimating == true
        {
            loadingstateUI.stopAnimating()
            btn.isHidden = false
            
        }

        beShowingActivity.removeAll()
        
        for activity in model.activeEnitys
        {
            if nowType == "全部"
            {
                beShowingActivity.append(activity)
            }
            else if activity.categoryString == nowType && nowType != "全部"
            {
                beShowingActivity.append(activity)
            }
        }
        
        
        
        
        activityTableView.reloadData()

        
    }
    // MARK: - other func
    fileprivate func addbtn(key:[String],btnwidth: CGFloat)
    {
        selecteScrollView.contentSize.width = CGFloat(Int(btnwidth) * key.count + 10 * (key.count - 1))
        for i in 0 ..< key.count
        {
            let btn = UIButton(type: .system)
            btn.frame = CGRect(x: CGFloat(Int(btnwidth) * i + 10 * i), y: selecteScrollView.bounds.origin.y, width: 50, height: selecteScrollView.frame.height)
            btn.addTarget(self, action: "interestingLabelBeSelect:", for: .touchUpInside)
            btn.setTitle(key[i], for: .normal)
//            btn.titleLabel?.font = UIFont(name: "Arial", size: 12)
            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 8
            selecteScrollView.addSubview(btn)
        }
    }
    fileprivate func addGetMorebtn()
    {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        self.activityTableView.tableFooterView = view
        btn = UIButton(type: .system)
        btn.setTitle("加载更多", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        btn.addTarget(self, action: "loadMore:", for: .touchUpInside)
        view.addSubview(btn)
        loadingstateUI = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingstateUI.center = btn.center
        view.addSubview(loadingstateUI)
    }
    
    private func addRecommendActivity(enitys: [ActiveEnity])
    {
        var nextX: CGFloat = 0
        var i = 0
        for enity in enitys
        {
            let activityImageView = UIImageView(frame: CGRect(x: nextX, y: 0, width: recommendActivityScrollView.frame.width, height: recommendActivityScrollView.frame.height))
            let media = enity.image
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            
            if let image = self.getImageFromCaches(mediaId: media)
            {
                activityImageView.image = image
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
                                activityImageView.image = image
                                self.saveImageCaches(image: image, mediaId: media)
                            }
                        }
                    }
                }
            }
            activityImageView.isUserInteractionEnabled = true
            activityImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "recommendImageTap:"))
            activityImageView.tag = i
            recommendActivityScrollView.addSubview(activityImageView)
            nextX += recommendActivityScrollView.frame.width
            i += 1
            
            
        }
        recommendActivityScrollView.contentSize.width = nextX
        let leftgesture = UISwipeGestureRecognizer(target: self, action: "leftslideswitch:")
        leftgesture.direction = .left
        recommendActivityScrollView.addGestureRecognizer(leftgesture)
        let rightgesture = UISwipeGestureRecognizer(target: self, action: "rightslideswtich:")
        rightgesture.direction = .right
        recommendActivityScrollView.addGestureRecognizer(rightgesture)
        recommendActivityScrollView.isScrollEnabled = false
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.hotActivityToCommentList
        {
            if let controller = segue.destination as? commentListViewController
            {
                controller.id = beShowingActivity[sender as! Int].id
                controller.type = "activity"
            }
        }else if segue.identifier == seguename.hotActivityToDetail
        {
            if let controller = segue.destination as? ActicityDetailViewController
            {
                controller.activityModel.activityEnity = sender as! ActiveEnity
            }
        }
        
    }
    

}
