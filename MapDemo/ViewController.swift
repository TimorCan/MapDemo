//
//  ViewController.swift
//  MapDemo
//
//  Created by zhoucan on 2017/2/16.
//  Copyright © 2017年 verfing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    let geocoder :CLGeocoder  = CLGeocoder()
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var dmTF: UITextField!
    
    @IBOutlet weak var jdTF: UITextField!
    
    @IBOutlet weak var wdTF: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var spanState = true
    
    @IBAction func buttonClick(_ sender: Any) {
        
        //地名--》经纬度
        
        self.geocoder.geocodeAddressString(dmTF.text!) { (placeMark, error) in
            
            if error != nil || placeMark == nil || placeMark?.count == 0 {
               
             
            }else{
            
             let item = placeMark?.first
                
              let anno =   self.addAnnotation((item?.location?.coordinate)!, title: (item?.locality)!, subTitle: (item?.name)!)
              
                let  viewRegion = MKCoordinateRegionMakeWithDistance((item?.location?.coordinate)!, 100, 100)
                self.mapView.setRegion(viewRegion, animated: true)
                
                self.mapView.selectAnnotation(anno, animated: true)
                
                
                self.view.endEditing(true)
            
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(CLLocationManager.authorizationStatus() != .denied) {
            print("应用拥有定位权限")
        }else {
            let aleat = UIAlertController(title: "打开定位开关", message:"定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许xxx使用定位服务", preferredStyle: .alert)
            let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            }
            let callAction = UIAlertAction(title: "立即设置", style: .default) { (action) in
                let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
                if(UIApplication.shared.canOpenURL(url! as URL)) {
                    //ios10废弃openurl
                    UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                    
                }
            }
            aleat.addAction(tempAction)
            aleat.addAction(callAction)
            self.present(aleat, animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        //设置定位模式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 5
        ////发送授权申请
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            
        }
        
        
        self.mapView.showsUserLocation = true;
        self.mapView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.spanState == false {
            return
        }
        
        
        
        if locations.count > 0 {
            
            let location = locations.last
            
            
            
            jdTF.text = "\(location!.coordinate.latitude)"
            wdTF.text = "\(location!.coordinate.longitude)"
            
            

//            
            
            //经纬度到地名
            self.geocoder.reverseGeocodeLocation(location!, completionHandler: { (placeMark, error) in
              
                
                if error != nil{
                    
                    self.dmTF.text = "火星"
                    return
                }
                
                
                if placeMark == nil || placeMark?.count == 0{
                
                 self.dmTF.text = "火星"
                
                
                }else{
                
                
            self.dmTF.text = placeMark?.first?.name
                    
                    
    
                    
            self.mapView.userLocation.title = self.dmTF.text
            self.mapView.userLocation.subtitle = placeMark?.first?.thoroughfare
                    
             self.mapView.centerCoordinate = (placeMark?.first?.location?.coordinate)!
                    
                    
                    if self.spanState == true { //首次时候的缩放范围
                        
                        let  viewRegion = MKCoordinateRegionMakeWithDistance((placeMark?.first?.location?.coordinate)!, 100, 100)
                        self.mapView.setRegion(viewRegion, animated: true)

                        self.spanState = false
                    }
                    
                    
        }
                
                
                
            })
            
        }
        
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("调用地图失败了")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        mapView.removeAnnotations(mapView.annotations)
        
        let point = touches.first?.location(in: mapView)
        let coordinate = mapView.convert(point!, toCoordinateFrom: mapView)
        let annotation = addAnnotation(coordinate, title: "", subTitle: "")
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (pls: [CLPlacemark]?, error: Error?) -> Void in
            if error == nil {
                let pl = pls?.first
                annotation.title = pl?.locality
                annotation.subtitle = pl?.name
                
                self.dmTF.text = annotation.subtitle
                
                self.wdTF.text = "\(pl!.location!.coordinate.longitude)"
                self.jdTF.text = "\(pl!.location!.coordinate.latitude)"
                
            }
        }
    }
    
}



extension ViewController:MKMapViewDelegate{
//
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        switch newState {
        case .starting:
            print("starting")
        case .dragging:
            print("dragging")
        case .ending:
            print("ending")
//             destCoordinate = annotationView.annotation.coordinate;
        default:
            break
        }
        
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        if spanState == true { //首次时候的缩放范围
        
        print("#############################################################################")
            
        let  viewRegion = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 100, 100)
        self.mapView.setRegion(viewRegion, animated: true)
        
            
        }
    }
    
    
    
    
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoID = "location"
        
        var annoView = mapView.dequeueReusableAnnotationView(withIdentifier: annoID) as? MKPinAnnotationView
        
        if annoView == nil  {
            
            
            annoView = MKPinAnnotationView.init(annotation: nil, reuseIdentifier: annoID)
            // 大头针属性
            annoView?.animatesDrop = true
            annoView?.canShowCallout = true
            annoView?.pinTintColor = UIColor.red
        }
        
        annoView?.isDraggable = true
        
        return annoView
        
    }
    func addAnnotation(_ coordinate: CLLocationCoordinate2D, title: String, subTitle: String) -> RJAnnotationView {
        let annotation: RJAnnotationView = RJAnnotationView()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)
        return annotation
    }
    
    
}

