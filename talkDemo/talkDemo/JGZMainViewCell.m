//
//  JGZMainViewCell.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/2/1.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "JGZMainViewCell.h"

@implementation JGZMainViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self SetUpUI];
    }
    return self;
}
-(void)SetUpUI{
    self.UserIconView = [[UIImageView alloc] init];
    self.UserIconView.backgroundColor=[UIColor redColor];
    
    self.UserNameLabel = [[UILabel alloc] init];
    //self.UserNameLabel.backgroundColor=[UIColor redColor];
    
    self.BodyDetailLabel = [[MLLinkLabel alloc] init];
    //self.BodyDetailLabel.backgroundColor=[UIColor redColor];
    self.BodyDetailLabel.font=[UIFont systemFontOfSize:15];
    
    self.LastTimeLabel = [[UILabel alloc] init];
    //self.LastTimeLabel.backgroundColor=[UIColor redColor];
    self.LastTimeLabel.font=[UIFont systemFontOfSize:14];
    
    [self addSubview:self.UserIconView];
    [self addSubview:self.UserNameLabel];
    [self addSubview:self.BodyDetailLabel];
    [self addSubview:self.LastTimeLabel];
}
-(void)setMessage:(EMMessage *)message{
    _message=message;
    self.UserIconView.image=nil;
    if (message.direction==EMMessageDirectionSend) {
      self.UserNameLabel.text = message.to;
    }else{
    self.UserNameLabel.text = message.from;
    }
    
    EMTextMessageBody *textbody = (EMTextMessageBody *)message.body;
    self.BodyDetailLabel.text = textbody.text;
    self.LastTimeLabel.text=@"2017-01-23";
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.UserIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(15);
    }];
    
    [self.LastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 20));
        make.top.mas_equalTo(self.UserIconView.mas_top).offset(-3);
        make.right.mas_equalTo(-5);
    }];
    
    [self.UserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.UserIconView.mas_right).offset(5);
        make.top.mas_equalTo(self.UserIconView.mas_top).offset(-3);
        make.right.mas_equalTo(self.LastTimeLabel.mas_left).offset(-5);
    }];
    [self.BodyDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.UserIconView.mas_right).offset(5);
        make.top.mas_equalTo(self.UserNameLabel.mas_bottom).offset(3);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
