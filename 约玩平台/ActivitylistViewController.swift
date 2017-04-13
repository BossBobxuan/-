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
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    fileprivate var nowlocation: nowlocationAnnotation!
    weak var activityMap: MKMapView!
    private var nowType: String = "全部"//用于标记当前显示的活动类型
    private var beShowingActivity: [ActiveEnity] = []
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var slideview: slideView!
    @IBOutlet var containerinslideView: [UIView]!
    @IBOutlet weak var selecteScrollView: UIScrollView!
    // MARK: - Event func
    //该方法在选择标签时调用在此处更改展示内容
    func interestingLabelBeSelect(_ sender: UIButton)
    {
        nowType = sender.titleLabel!.text!
        activityMap.removeAnnotations(beShowingActivity)
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
        activityMap.addAnnotations(beShowingActivity)
        activityMap.showAnnotations(beShowingActivity, animated: true)
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
        slideview.containerviews = containerinslideView
        addbtn(key: key,btnwidth: 50)
        //获取定位权限
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //布局tableview在第一个子视图
        activityTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: slideview.frame.size.height)
        activityTableView.delegate = self
        activityTableView.dataSource = self
        //布局mapview在第二个子视图
        activityMap = MKMapView()
        activityMap.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 10, height: slideview.frame.size.height)
        activityMap.delegate = self
        containerinslideView[1].addSubview(activityMap)
        //显示用户位置
        activityMap.mapType = .standard
        
        //初始化model
        model = ActivityListModel(delegate: self)
        model.getActivity()
        //以下代码用于增加tableview的下拉刷新行为
        self.activityTableView.refreshControl = UIRefreshControl()
        self.activityTableView.refreshControl?.addTarget(self, action: "pullToRefresh", for: .valueChanged)
        self.activityTableView.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新活动")
        //增加读取更多数据的按钮
        addGetMorebtn()
        
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
        
        activityMap.addAnnotations(beShowingActivity)
        activityMap.showAnnotations(beShowingActivity, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - locationdelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        nowlocation = nowlocationAnnotation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        activityMap.addAnnotation(nowlocation)
        manager.stopUpdatingLocation()
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
        cell.contentTextView.text = beShowingActivity[indexPath.row].content
        cell.commentCountLabel.text = "\(beShowingActivity[indexPath.row].commentCount)"
        cell.statusLabel.text = beShowingActivity[indexPath.row].stateString
        cell.beginDateCount.text = beShowingActivity[indexPath.row].beginTime.date
        cell.addressLabel.text = beShowingActivity[indexPath.row].address
        cell.commentButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: "toComment:", for: .touchUpInside)
        
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: seguename.hotActivityToDetail, sender: beShowingActivity[indexPath.row])
    }
    // MARK: - mapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let a = annotation as? nowlocationAnnotation
        {
            let view = MKAnnotationView(annotation: a, reuseIdentifier: "locationannotation")
            view.image = UIImage(named: "location.png")
            view.canShowCallout = false
            return view//给当前位置添加自定义标注
        }else
        {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "activitypin")
            let button = UIButton(type: .detailDisclosure)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = button
            return view
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: seguename.hotActivityToDetail, sender: view.annotation as! ActiveEnity)
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
        activityMap.removeAnnotations(beShowingActivity)
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
        activityMap.addAnnotations(beShowingActivity)
        activityMap.showAnnotations(beShowingActivity, animated: true)
        
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
            btn.titleLabel?.font = UIFont(name: "Arial", size: 12)
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
