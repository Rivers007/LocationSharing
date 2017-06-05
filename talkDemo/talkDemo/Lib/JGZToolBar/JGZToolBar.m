//
//  JGZToolBar.m
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/28.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import "JGZToolBar.h"
#import "JGZInputTextView.h"
#import "JGZEmojiKeyBoard.h"
@interface JGZToolBar ()<JGZEmojiKeyBoardDelegate,JGZInputTextViewDelegate>
@property (nonatomic,assign) CGRect OldFrame;
@property (nonatomic,assign) CGFloat ToolBarH;
@property (nonatomic,assign) CGFloat KeyboardH;
@property (nonatomic,strong) ToolBarMinY ToolBarMinYBlock;
@property (nonatomic,strong) JGZEmojiKeyBoard *EmojiKeyBoard;
@end
@implementation JGZToolBar
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.OldFrame=frame;
        self.backgroundColor=[UIColor colorWithRed:235.0f/255.0 green:235.0f/255.0 blue:235.0f/255.0 alpha:1.0];
        [self CreatInputTextView];
        [self CreatOterSubViews];
        self.ToolBarH=frame.size.height;
        self.KeyboardH=0.0;
        //键盘弹出时
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
        //键盘消失时
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)CreatOterSubViews{
    self.RecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.RecordButton setImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"ToolBarIcon" ofType:@"bundle"] stringByAppendingPathComponent:@"toolbar_sound_light.png"]] forState:UIControlStateNormal];
    [self.RecordButton setImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"ToolBarIcon" ofType:@"bundle"] stringByAppendingPathComponent:@"toolbar_keyboard_light.png"]] forState:UIControlStateSelected];
    
    self.EmojinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.EmojinButton setImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"ToolBarIcon" ofType:@"bundle"] stringByAppendingPathComponent:@"toolbar_emoji_light.png"]] forState:UIControlStateNormal];
    [self.EmojinButton setImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"ToolBarIcon" ofType:@"bundle"] stringByAppendingPathComponent:@"toolbar_keyboard_light.png"]] forState:UIControlStateSelected];
    [self.EmojinButton addTarget:self action:@selector(EmojinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.MoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.MoreButton setImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"ToolBarIcon" ofType:@"bundle"] stringByAppendingPathComponent:@"toolbar_round_add_light.png"]] forState:UIControlStateNormal];
    
    [self addSubview:self.RecordButton];
    [self addSubview:self.EmojinButton];
    [self addSubview:self.MoreButton];
}
-(void)CreatInputTextView{
    JGZInputTextView *inputtextview = [[JGZInputTextView alloc] initWithFrame:CGRectMake(40, 3, self.frame.size.width-40-80, 34) font:[UIFont systemFontOfSize:14]];
    self.inputtextview=inputtextview;
    inputtextview.JGZInputTextdelegate=self;
    inputtextview.TextViewVerticallyStyle = TextViewVerticallyCenter;
    inputtextview.directiontype = DirectionDown;
    inputtextview.backgroundColor=[UIColor whiteColor];
    inputtextview.MAXHeight = 160;
    inputtextview.PlaceholdLabel.text = @"请输入备注";
    inputtextview.borderColor=[UIColor colorWithRed:219.0f/255.0 green:219.0f/255.0 blue:219.0f/255.0 alpha:1.0];
    [inputtextview getInputTextViewHeightBlock:^(NSString *text, CGFloat InputViewHeight) {
        CGRect frame = self.frame;
        if ((InputViewHeight+6)<self.OldFrame.size.height) {
            frame.size.height=self.OldFrame.size.height;
        }else{
            frame.size.height=InputViewHeight+6;
        }
        frame.origin.y=self.OldFrame.origin.y-InputViewHeight+34-self.KeyboardH;
        self.frame=frame;
        if (self.ToolBarMinYBlock) {
            self.ToolBarMinYBlock(self,frame.origin.y);
        }
        self.ToolBarH=frame.size.height;
        NSLog(@"%f",self.ToolBarH);
        CGRect RecordFrame=self.RecordButton.frame;
        RecordFrame.origin.y=self.ToolBarH-35;
        self.RecordButton.frame = RecordFrame;
        
        CGRect EmojinFrame=self.EmojinButton.frame;
        EmojinFrame.origin.y=self.ToolBarH-35;
        self.EmojinButton.frame = EmojinFrame;
        
        CGRect MoreFrame=self.MoreButton.frame;
        MoreFrame.origin.y=self.ToolBarH-35;
        self.MoreButton.frame = MoreFrame;
        
    }];
    [self addSubview:inputtextview];
}

-(void)keyboardAppear:(NSNotification *)aNotification
{
    NSDictionary * userInfo = aNotification.userInfo;
    NSNotificationName name =aNotification.name;
    CGRect frameOfKeyboard = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.frame;
    if (name==UIKeyboardWillShowNotification) {
        frame.origin.y=CGRectGetMaxY(self.OldFrame)-frameOfKeyboard.size.height-self.ToolBarH;
        self.KeyboardH=frameOfKeyboard.size.height;
    }else if (name==UIKeyboardWillHideNotification){
        frame.origin.y=CGRectGetMaxY(self.OldFrame)-self.ToolBarH;
        self.KeyboardH=0.0;
    }
    if (self.ToolBarMinYBlock) {
        self.ToolBarMinYBlock(self,frame.origin.y);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame=frame;
    }];
    
}
-(void)getToolBarMinYBlock:(ToolBarMinY)Block{
    self.ToolBarMinYBlock=Block;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.RecordButton.frame = CGRectMake(5, self.frame.size.height-35, 30, 30);
    self.EmojinButton.frame = CGRectMake(self.frame.size.width-40-35, self.frame.size.height-35, 30, 30);
    self.MoreButton.frame = CGRectMake(self.frame.size.width-40, self.frame.size.height-35, 30, 30);
}

-(void)EmojinButtonClick:(UIButton *)btn{
    if (btn.isSelected==YES) {
        [self.inputtextview resignFirstResponder];
        self.inputtextview.inputView = nil;
        [self.inputtextview becomeFirstResponder];
        btn.selected=NO;
    }else{
        [self.inputtextview resignFirstResponder];
        self.EmojiKeyBoard = [[JGZEmojiKeyBoard alloc] initWithTextView:self.inputtextview];
        self.EmojiKeyBoard.delegate = self;
        self.inputtextview.inputView = self.EmojiKeyBoard;
        [self.inputtextview becomeFirstResponder];
        btn.selected=YES;
    }
    
    
}
-(void)SendButtonClick:(NSString *)string{
    if ([self.delegate respondsToSelector:@selector(SendButtonDidClick:)]) {
        [self.delegate SendButtonDidClick:string];
    }
}
#pragma mark--JGZInputTextViewDelegate
-(void)SendText:(NSString *)text{
    if ([self.delegate respondsToSelector:@selector(SendButtonDidClick:)]) {
        [self.delegate SendButtonDidClick:text];
    }
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
@end
