//
//  LocationSelectViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/30.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import MapKit
protocol selectLocationDelegate {
    func selectLocationDone(latitude: Double,longitude: Double) -> Void
}
class LocationSelectViewController: UIViewController,MKMapViewDelegate {
    var longitude: Double?
    var latitude: Double?
    var delegate: selectLocationDelegate!
    let annotation = MKPointAnnotation()
    @IBOutlet weak var activityLocationMapView: MKMapView!
    
    func selectDone(_ sender: UIBarButtonItem)
    {
        self.delegate.selectLocationDone(latitude: latitude!, longitude: longitude!)
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func longPressAddLocation(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began
        {
            if longitude == nil
            {
                let coordinate = activityLocationMapView.convert(sender.location(in: activityLocationMapView), toCoordinateFrom: activityLocationMapView)
                annotation.coordinate = coordinate
                longitude = coordinate.longitude
                latitude = coordinate.latitude
                activityLocationMapView.addAnnotation(annotation)
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityLocationMapView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "selectDone:")
        self.activityLocationMapView.mapType = .standard
        if longitude != nil
        {
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            activityLocationMapView.addAnnotation(annotation)
            activityLocationMapView.showAnnotations([annotation], animated: true)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "default")
        view.isDraggable = true
        return view
    }
   
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == .ending
        {
            latitude = view.annotation?.coordinate.latitude
            longitude = view.annotation?.coordinate.longitude
            
        }
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
