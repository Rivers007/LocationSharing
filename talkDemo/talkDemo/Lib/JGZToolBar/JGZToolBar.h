//
//  JGZToolBar.h
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/28.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGZToolBar;
@class JGZInputTextView;
typedef void(^ToolBarMinY)(JGZToolBar *ToolBar,CGFloat ToolBarMinY);

@protocol JGZToolBarDelegate <NSObject>

-(void)SendButtonDidClick:(NSString *)string;

@end
@interface JGZToolBar : UIView
@property (nonatomic,strong) JGZInputTextView *inputtextview;
@property (nonatomic,strong) UIButton *RecordButton;
@property (nonatomic,strong) UIButton *EmojinButton;
@property (nonatomic,strong) UIButton *MoreButton;

@property (nonatomic,weak)id<JGZToolBarDelegate>delegate;

-(void)getToolBarMinYBlock:(ToolBarMinY)Block;

@end
