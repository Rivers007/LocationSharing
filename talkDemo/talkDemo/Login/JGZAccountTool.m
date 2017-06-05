//
//  JGZAccountTool.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/1/31.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "JGZAccountTool.h"
#import "JGZAccount.h"
#import <Hyphenate_CN/EMSDKFull.h>
#import "JGZLoginController.h"
#import "MainViewController.h"
@implementation JGZAccountTool
static JGZAccount *_LoginAccount;
+(void)SaveLoginAccount:(JGZAccount *)Account{
    [NSKeyedArchiver archiveRootObject:Account toFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"account.data"]];

}
+(void)RemoveLoginAccount{
    NSFileManager *manager = [NSFileManager defaultManager];
      BOOL flag = [manager removeItemAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"account.data"] error:nil];
    if (flag==YES) {
        _LoginAccount=nil;
    }

}
+(JGZAccount *)LoginAccount{
    if (_LoginAccount==nil) {
        _LoginAccount=[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"account.data"]];
    }
    return _LoginAccount;
}
+(BOOL)LoginAccount:(JGZAccount *)Account{
    EMError *error = [[EMClient sharedClient] loginWithUsername:Account.Account password:Account.PassWord];
    if (!error) {
        NSLog(@"登录成功");
       [JGZAccountTool SaveLoginAccount:Account];
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        [JGZAccountTool ChooseRootController:[UIApplication sharedApplication].keyWindow];
        return YES;
    }
    return NO;
}
+(BOOL)LogOut{
    EMError *error=[[EMClient sharedClient] logout:YES];
    
        if (error==nil) {
            [JGZAccountTool RemoveLoginAccount];
            [JGZAccountTool ChooseRootController:[UIApplication sharedApplication].keyWindow];
            return YES;        
        }
        return NO;

}
+(BOOL)RegisterAccount:(JGZAccount *)Account{
    EMError *error = [[EMClient sharedClient] registerWithUsername:Account.Account password:Account.PassWord];
    if (error==nil) {
        NSLog(@"注册成功");
        return YES;
    }
    return NO;
}
+(void)ChooseRootController:(UIWindow *)window{
    
    
    if ([JGZAccountTool LoginAccount]) {
        if (![[EMClient sharedClient] isLoggedIn]) {
            [JGZAccountTool LoginAccount:[JGZAccountTool LoginAccount]];
        }
        MainViewController *MainController = [[MainViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:MainController];
        window.rootViewController=nav;
        
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        JGZLoginController *LoginController = [storyboard instantiateViewControllerWithIdentifier:@"JGZLoginController"];
        window.rootViewController=LoginController;
        
    }
    [window makeKeyAndVisible];
  
}
@end
