//
//  ActivityLocationViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/2.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ActivityLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var activityMapView: MKMapView!
    var latitude: Double!
    var longitude: Double!
    let annotation = MKPointAnnotation()
    var canshowCallOut = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            print("2")
            activityMapView.mapType = .standard
            activityMapView.showsUserLocation = true
            activityMapView.userTrackingMode = .followWithHeading
            canshowCallOut = true
        }else if CLLocationManager.authorizationStatus() == .denied
        {
            canshowCallOut = false
            let alert = UIAlertController(title: "没有使用定位的权限", message: "请前往设置中开启", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if CLLocationManager.authorizationStatus() == .notDetermined
        {
            let manager = CLLocationManager()
            manager.requestAlwaysAuthorization()
        }
        activityMapView.delegate = self
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = "点击开始导航"
        activityMapView.addAnnotation(annotation)
        activityMapView.showAnnotations([annotation], animated: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "default")
        view.isDraggable = false
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let detination = MKPlacemark(coordinate: annotation.coordinate)
        let source = MKPlacemark(coordinate: activityMapView.userLocation.coordinate)
        let detinationMapItem = MKMapItem(placemark: detination)
        let sourceMapItem = MKMapItem(placemark: source)
        MKMapItem.openMaps(with: [sourceMapItem,detinationMapItem], launchOptions: nil)
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
