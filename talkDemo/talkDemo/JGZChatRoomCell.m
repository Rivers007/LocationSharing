//
//  JGZChatRoomCell.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/2/1.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "JGZChatRoomCell.h"

@implementation JGZChatRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=[UIColor clearColor];
        [self SetUpUI];
    }
    return self;
}
-(void)SetUpUI{
    
    self.BodyDetailLabel = [[MLLinkLabel alloc] init];
    //self.BodyDetailLabel.backgroundColor=[UIColor redColor];
    self.BodyDetailLabel.font=[UIFont systemFontOfSize:15];
    
    [self addSubview:self.BodyDetailLabel];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.BodyDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.top.mas_equalTo(self.mas_top).offset(3);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-3);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
