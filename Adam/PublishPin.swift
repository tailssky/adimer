//
//  PublishPin.swift
//  Adam
//
//  Created by 周岩峰 on 8/10/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import Foundation
import MapKit


class PublishPin: NSObject, MKAnnotation {
    let publish: Publish
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var pinview = UIImage(named:"dish20*20")
    
    
    init (publish: Publish) {
        self.publish = publish
        if !WGS84TOGCJ02.isLocationOutOfChina(publish.rstLocation.coordinate) {
            self.coordinate = WGS84TOGCJ02.transformFromWGSToGCJ(publish.rstLocation.coordinate) } else {
            self.coordinate = publish.rstLocation.coordinate
        }
        
        self.title = publish.restaurantName
        self.subtitle = publish.dishName
    }
}
