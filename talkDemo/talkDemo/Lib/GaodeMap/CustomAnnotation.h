//
//  CustomAnnotation.h
//  talkDemo
//
//  Created by 江贵铸 on 2017/6/7.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CustomAnnotation : NSObject<MAAnnotation>
/** 坐标(标记大头针扎在哪个位置) */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subtitle;


/** 图标 */
@property (nonatomic, copy) NSString *icon;
@property (nonatomic,copy) NSString *UserID;
@end
