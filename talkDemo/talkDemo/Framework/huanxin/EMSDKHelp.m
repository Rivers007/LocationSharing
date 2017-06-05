//
//  EMSDKHelp.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/2/1.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "EMSDKHelp.h"

@implementation EMSDKHelp
+(EMMessage *)CreatEMMessage:(NSString *)text messageExt:(NSDictionary *)messageExt chatType:(EMChatType)chatType Conversation:(EMConversation *)Conversation{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    NSString *tostring = @"";
    if (Conversation.latestMessage.direction==EMMessageDirectionSend) {
        tostring=Conversation.latestMessage.to;
    }else{
        tostring=Conversation.latestMessage.from;
    }
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:Conversation.conversationId from:from to:tostring body:body ext:messageExt];
    message.chatType = chatType;
    return message;
}
+(EMMessage *)SendTextMessage:(NSString *)text messageExt:(NSDictionary *)messageExt chatType:(EMChatType)chatType Conversation:(EMConversation *)Conversation{
    EMMessage *message=[EMSDKHelp CreatEMMessage:text messageExt:messageExt chatType:chatType Conversation:Conversation];
[[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
    
} completion:^(EMMessage *message, EMError *error) {
    
}];
    return message;
}


@end
