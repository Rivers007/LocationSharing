//
//  CustomAnnotationView.h
//  talkDemo
//
//  Created by 江贵铸 on 2017/6/7.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

//#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
@interface CustomAnnotationView : MAAnnotationView
+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView;
@property (nonatomic,copy) NSString *UserID;
@end
