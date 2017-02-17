//
//  RJAnnotationView.swift
//  MapDemo
//
//  Created by zhoucan on 2017/2/17.
//  Copyright © 2017年 verfing. All rights reserved.
//

import UIKit
import MapKit

class RJAnnotationView: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String?
    var subtitle: String?
}
