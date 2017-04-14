//
//  testViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/14.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import MapKit
class testViewController: UIViewController ,MKMapViewDelegate, UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var slideview: UIScrollView!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var activityMap: MKMapView!
    @IBOutlet weak var selecteScrollView: UIScrollView!
   
    fileprivate var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideview.contentSize.width = UIScreen.main.bounds.width * 2
//        addbtn(key: key,btnwidth: 50)
        //获取定位权限
//        locationManager = CLLocationManager()
//
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        //布局tableview在第一个子视图
        activityTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: slideview.frame.size.height)
        activityTableView.delegate = self
        activityTableView.dataSource = self
        //布局mapview在第二个子视图
        
        activityMap.frame = CGRect(x: 10 + UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width - 10, height: slideview.frame.size.height)
        activityMap.delegate = self
//        activityMap.showsUserLocation = true
        
        //显示用户位置
//        activityMap.mapType = .standard
        //设置滑动
        let leftgesture = UISwipeGestureRecognizer(target: self, action: "leftslideswitch:")
        leftgesture.direction = .left
        slideview.addGestureRecognizer(leftgesture)
        let rightgesture = UISwipeGestureRecognizer(target: self, action: "rightslideswtich:")
        rightgesture.direction = .right
        slideview.addGestureRecognizer(rightgesture)
        
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "2")
        view.canShowCallout = true
        return view
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    func leftslideswitch(_ sender : UISwipeGestureRecognizer)
    {
        
        print("left")
        UIView.animate(withDuration: 0.5, animations: {
            if self.slideview.contentOffset.x != self.slideview.contentSize.width - self.slideview.frame.width
            {
                self.slideview.contentOffset.x += self.slideview.frame.width
            }
        })
        
        
    }
    func rightslideswtich(_ sender : UISwipeGestureRecognizer)
        
    {
        
        print("right")
        UIView.animate(withDuration: 0.5, animations: {
            if self.slideview.contentOffset.x != 0
            {
                self.slideview.contentOffset.x -= self.slideview.frame.width
            }
        })
        
        
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
