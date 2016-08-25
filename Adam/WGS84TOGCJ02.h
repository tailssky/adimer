//
//  wCoordinate.h
//  Adam
//
//  Created by 周岩峰 on 8/18/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

#ifndef wCoordinate_h
#define wCoordinate_h

//  Copyright (c) 2013年 swinglife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGS84TOGCJ02 : NSObject
//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
@end

#endif /* wCoordinate_h */
