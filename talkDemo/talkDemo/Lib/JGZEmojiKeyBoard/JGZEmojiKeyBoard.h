//
//  JGZEmojiKeyBoard.h
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/30.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGZEmojiKeyBoardDelegate <NSObject>

-(void)SendButtonClick:(NSString *)string;

@end
@interface JGZEmojiKeyBoard : UIView
-(id)initWithTextView:(UITextView *)TextView;
-(id)initWithTextField:(UITextField *)TextField;
@property (nonatomic,weak)id<JGZEmojiKeyBoardDelegate>delegate;
@end
