//
//  EMSDKHelp.h
//  talkDemo
//
//  Created by 江贵铸 on 2017/2/1.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMSDKHelp : NSObject
+(EMMessage *)CreatEMMessage:(NSString *)text messageExt:(NSDictionary *)messageExt chatType:(EMChatType)chatType Conversation:(EMConversation *)Conversation;
+(EMMessage *)SendTextMessage:(NSString *)text messageExt:(NSDictionary *)messageExt chatType:(EMChatType)chatType Conversation:(EMConversation *)Conversation;
@end
