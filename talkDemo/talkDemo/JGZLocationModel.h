//
//  JGZLocationModel.h
//  talkDemo
//
//  Created by 江贵铸 on 2017/6/6.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGZLocationModel : NSObject
@property (nonatomic,copy) NSString *Account;
@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;
@property (nonatomic,strong) CLHeading *UseHeading;
@end
