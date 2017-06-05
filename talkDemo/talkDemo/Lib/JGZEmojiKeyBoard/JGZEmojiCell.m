//
//  JGZEmojiCell.m
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/31.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import "JGZEmojiCell.h"
#import "JGZEmojiManager.h"
@implementation JGZEmojiCell
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.EmojiImageView = [[UIImageView alloc] init];
        self.EmojiImageView.frame = CGRectMake((self.frame.size.width-[[JGZEmojiManager sharemanager] emotionWH])*0.5, (self.frame.size.height-[[JGZEmojiManager sharemanager] emotionWH])*0.5, [[JGZEmojiManager sharemanager] emotionWH], [[JGZEmojiManager sharemanager] emotionWH]);
        //self.EmojiImageView.center=self.center;
        [self addSubview:self.EmojiImageView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];

}
@end
