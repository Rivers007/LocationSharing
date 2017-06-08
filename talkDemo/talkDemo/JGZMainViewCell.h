//
//  JGZMainViewCell.h
//  talkDemo
//
//  Created by 江贵铸 on 2017/2/1.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGZMainViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *UserIconView;
@property (nonatomic,strong) UILabel *UserNameLabel;
@property (nonatomic,strong) UILabel *BodyDetailLabel;
@property (nonatomic,strong) UILabel *LastTimeLabel;

@property (nonatomic,strong) EMMessage *message;
@end
