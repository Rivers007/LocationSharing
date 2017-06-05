//
//  JGZAccount.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/1/31.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "JGZAccount.h"

@implementation JGZAccount
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_Account forKey:@"Login_Account"];
    [aCoder encodeObject:_PassWord forKey:@"Login_PassWord"];

}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _Account=[aDecoder decodeObjectForKey:@"Login_Account"];
        _PassWord = [aDecoder decodeObjectForKey:@"Login_PassWord"];
    }
    return self;
}
@end
