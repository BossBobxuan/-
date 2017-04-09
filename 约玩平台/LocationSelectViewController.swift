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
    func selectLocationDone(latitude: Double,longitude: Double,address: String) -> Void
}
class LocationSelectViewController: UIViewController,MKMapViewDelegate,UITextFieldDelegate {
    var longitude: Double?
    var latitude: Double?
    
    @IBOutlet weak var searchLocationTextField: UITextField!
    var delegate: selectLocationDelegate!
    var address: String = ""
    let annotation = MKPointAnnotation()
    @IBOutlet weak var activityLocationMapView: MKMapView!
    
    func selectDone(_ sender: UIBarButtonItem)
    {
        self.delegate.selectLocationDone(latitude: latitude!, longitude: longitude!,address: address)
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
        searchLocationTextField.delegate = self
        if longitude != nil
        {
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            activityLocationMapView.addAnnotation(annotation)
            activityLocationMapView.showAnnotations([annotation], animated: true)
            let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: {(array,error) in
                if (array?.count)! > 0
                {
                    let placemark = array![0]
                    print(placemark.name!)
                    print(placemark.locality!)
                    print(placemark.subLocality!)
                    self.address += placemark.administrativeArea!
                    if placemark.locality != nil
                    {
                        self.address += placemark.locality!
                    }
                    self.address += placemark.subLocality!
                    if placemark.thoroughfare != nil
                    {
                        self.address += placemark.thoroughfare!
                    }
                    self.annotation.title = self.address
                    
                }
            })
            
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "default")
        view.isDraggable = true
        view.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.canShowCallout = true
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.delegate.selectLocationDone(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude,address: (view.annotation!.title)!!)
        self.navigationController!.popViewController(animated: true)
    }
   
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == .ending
        {
            address = ""
            latitude = view.annotation?.coordinate.latitude
            longitude = view.annotation?.coordinate.longitude
            let location = CLLocation(latitude: latitude!, longitude: longitude!)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: {(array,error) in
                if (array?.count)! > 0
                {
                    let placemark = array![0]
                    print(placemark.name!)
                    print(placemark.locality!)
                    print(placemark.subLocality!)
                    self.address += placemark.administrativeArea!

                    if placemark.locality != nil
                    {
                        self.address += placemark.locality!
                    }
                    if placemark.subLocality != nil
                    {
                        self.address += placemark.subLocality!
                    }
                    if placemark.thoroughfare != nil
                    {
                        self.address += placemark.thoroughfare!
                    }
                    if placemark.subThoroughfare != nil
                    {
                        self.address += placemark.subThoroughfare!
                    }
                    
                }
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textField.text!, completionHandler: {(placemarks,error) in
            self.activityLocationMapView.removeAnnotations(self.activityLocationMapView.annotations)
            if placemarks?.count == 0 || error != nil
            {
                let alert = UIAlertController(title: "找不到该地点", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else
            {
                for placemark in placemarks!
                {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = placemark.location!.coordinate
                    var address = ""
                    address += placemark.administrativeArea!
                    if placemark.locality != nil
                    {
                        address += placemark.locality!
                    }
                    if placemark.subLocality != nil
                    {
                        address += placemark.subLocality!
                    }
                    if placemark.thoroughfare != nil
                    {
                        address += placemark.thoroughfare!
                    }
                    if placemark.subThoroughfare != nil
                    {
                        self.address += placemark.subThoroughfare!
                    }
                    annotation.title = address
                    self.activityLocationMapView.addAnnotation(annotation)
                    self.activityLocationMapView.showAnnotations([annotation], animated: true)
                }
            }
            
        })
        
        textField.resignFirstResponder()
        return true
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
