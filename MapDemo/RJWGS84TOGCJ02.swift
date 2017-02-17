//
//  RJWGS84TOGCJ02.swift
//  MapDemo
//
//  Created by zhoucan on 2017/2/17.
//  Copyright © 2017年 verfing. All rights reserved.
//
//
////判断是否已经超出中国范围
//+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
////转GCJ-02
//+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

import UIKit
import MapKit



class RJWGS84TOGCJ02: NSObject {
    
    let a:Double = 6378245.0;
    let ee:Double = 0.00669342162296594323;
    let pi:Double = 3.14159265358979324;
    
    //判断是不是在中国 
    
    
    open static func isLocationOutOfChina(location:CLLocationCoordinate2D) -> Bool  {
        if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271){
        return true
        }
        
        return false
        
    }
    
    
    func transformLatWithX(x:Double,y:Double)->Double {
       var lat:Double = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
        lat += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
        lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
        lat += (160.0 * sin(y / 12.0 * pi) + 3320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
        return lat;
    }
    
    func transformLonWithX(x:Double,y:Double)->Double {
        var lon:Double = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
        lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
        lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
        lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
        return lon;
    }
    
    
    
    
    func transformFromWGSToGCJ(wgsLoc:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        
        var adjustLoc:CLLocationCoordinate2D?
        if RJWGS84TOGCJ02.isLocationOutOfChina(location: wgsLoc){
            adjustLoc = wgsLoc
            return adjustLoc!;
        }else{
           var adjustLat:Double = self.transformLatWithX(x: wgsLoc.longitude - 105.0, y: wgsLoc.latitude - 35.0)
           
            var adjustLon:Double = self.transformLonWithX(x: wgsLoc.longitude - 105.0, y: wgsLoc.latitude - 35.0)
            
            
            let radLat:Double = wgsLoc.latitude / 180.0 * pi;
            var magic:Double = sin(radLat);
            magic = 1 - ee * magic * magic;
            let sqrtMagic:Double = sqrt(magic);
            adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
            adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
            
            let adjustLoc:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: wgsLoc.latitude + adjustLat, longitude: wgsLoc.longitude + adjustLon)
            
            return adjustLoc
        }  
        
        
    }
    

}
