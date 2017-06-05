//
//  JGZAccountTool.h
//  talkDemo
//
//  Created by 江贵铸 on 2017/1/31.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGZAccount;
@interface JGZAccountTool : NSObject
+(void)SaveLoginAccount:(JGZAccount *)Account;
+(JGZAccount *)LoginAccount;
+(BOOL)LoginAccount:(JGZAccount *)Account;
+(BOOL)LogOut;
+(BOOL)RegisterAccount:(JGZAccount *)Account;
+(void)ChooseRootController:(UIWindow *)window;
@end
