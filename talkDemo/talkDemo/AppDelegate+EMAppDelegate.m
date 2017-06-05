//
//  AppDelegate+EMAppDelegate.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/1/31.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "AppDelegate+EMAppDelegate.h"
#import <Hyphenate_CN/EMSDKFull.h>
#define EaseMobAppKey @"easemob-demo#chatdemoui"
@implementation AppDelegate (EMAppDelegate)

-(void)SetUpEMOption{
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"120519#jgz"];
    //options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}
@end
