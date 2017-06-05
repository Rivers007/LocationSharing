//
//  JGZInputTextView.m
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/25.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import "JGZInputTextView.h"

@interface JGZInputTextView ()
@property (nonatomic,assign) CGFloat deadSpace;
@property (nonatomic,assign) CGRect OldFrame;
@property (nonatomic,strong) InputTextViewHeight  InputViewHeightBlock;
@end
@implementation JGZInputTextView

- (id)initWithFrame:(CGRect)frame font:(UIFont *)font
{
    if (self = [super initWithFrame:frame])
    {
        self.scrollEnabled=NO;
        self.OldFrame = frame;
        self.font = font;
        self.text = @" ";
        [self SetTextViewAndPlaceHoldLabel];
        self.text = @"";
        self.returnKeyType=UIReturnKeySend;
        self.layer.backgroundColor = [[UIColor clearColor] CGColor];
        self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius=5.0;
        [self.layer setMasksToBounds:YES];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder])
    {
        self.scrollEnabled=NO;
        self.OldFrame = self.frame;
        self.text = @" ";
        [self SetTextViewAndPlaceHoldLabel];
        self.text = @"";
        self.layer.backgroundColor = [[UIColor clearColor] CGColor];
        self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius=5.0;
        [self.layer setMasksToBounds:YES];
        
    }
    return self;

}
-(void)SetTextViewAndPlaceHoldLabel{
    self.delegate = self;
    [self addObserver:self forKeyPath:@"contentSize" options:  (NSKeyValueObservingOptionOld) context:NULL];
    [self observeValueForKeyPath:@"contentSize" ofObject:self change:nil context:nil];
    CGFloat PlaceholdLabelH = 30;
    CGFloat PlaceholdLabelY = 1.5*(self.font.lineHeight/17);
    if (self.OldFrame.size.height<=PlaceholdLabelH) {
        PlaceholdLabelH=self.OldFrame.size.height;
        PlaceholdLabelY=0;
    }
    if (self.TextViewVerticallyStyle==TextViewVerticallyCenter) {
        self.PlaceholdLabel = [[UILabel alloc] initWithFrame:self.bounds];
    }else if (self.TextViewVerticallyStyle==TextViewVerticallybottom){
        self.PlaceholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, self.bounds.size.width-PlaceholdLabelH-PlaceholdLabelY, self.bounds.size.width, PlaceholdLabelH)];
    }else{
        self.PlaceholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, PlaceholdLabelY, self.bounds.size.width, PlaceholdLabelH)];
    }
    self.PlaceholdLabel.userInteractionEnabled = NO;
    self.PlaceholdLabel.text = @"请输入文字";
    self.PlaceholdLabel.font = self.font;
    self.PlaceholdLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.PlaceholdLabel];
    
}
-(void)setTextViewHorizontalStyle:(TextViewHorizontalStyle)TextViewHorizontalStyle{
    _TextViewHorizontalStyle =TextViewHorizontalStyle;
    if (self.TextViewHorizontalStyle==TextViewHorizontalCenter) {
        self.textAlignment = NSTextAlignmentCenter;
    }else if (self.TextViewHorizontalStyle==TextViewHorizontalRight)
    {
        self.textAlignment = NSTextAlignmentRight;
    }else{
        self.textAlignment = NSTextAlignmentLeft;
    }
    [self observeValueForKeyPath:@"contentSize" ofObject:self change:nil context:nil];
    
}
-(void)setTextViewVerticallyStyle:(TextViewVerticallyStyle)TextViewVerticallyStyle{
    _TextViewVerticallyStyle =TextViewVerticallyStyle;
    [self observeValueForKeyPath:@"contentSize" ofObject:self change:nil context:nil];
}
-(void)setDirectiontype:(DirectionType)directiontype{
    _directiontype=directiontype;
    [self ChangeDirection];
}
-(void)setMAXHeight:(CGFloat)MAXHeight{
    _MAXHeight=MAXHeight;
    [self textViewDidChange:self];
}
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor=borderColor;
    self.layer.borderColor = borderColor.CGColor;
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth=borderWidth;
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius=cornerRadius;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        UITextView *TextView = object;
        //NSLog(@"%f--%f",[TextView bounds].size.height,[TextView contentSize].height);
        //CGFloat deadSpace = ([TextView bounds].size.height - [TextView contentSize].height);
        CGFloat deadSpace = ([TextView bounds].size.height - [self heightForString:TextView.text font:self.font width:self.frame.size.width]);
        self.deadSpace=deadSpace;
        if (self.TextViewVerticallyStyle ==TextViewVerticallyCenter) {
            CGFloat inset=0.0;
            if (deadSpace/2.0<0) {
                inset = MIN(deadSpace/2.0, 0);
            }else{
                inset = MAX(0, deadSpace/2.0);
            }
            if (self.PlaceholdLabel.isHidden==YES) {
                TextView.contentInset = UIEdgeInsetsMake(2, TextView.contentInset.right, 2, TextView.contentInset.right);
           }else{
                TextView.contentInset = UIEdgeInsetsMake(inset, TextView.contentInset.left, inset, TextView.contentInset.left);
           }
        }else if (self.TextViewVerticallyStyle ==TextViewVerticallybottom) {
            CGFloat inset=0.0;
            if (deadSpace/2.0<0) {
                inset = MIN(deadSpace/2.0, 0);
            }else{
                inset = MAX(0, deadSpace/2.0);
            }
            if (self.PlaceholdLabel.isHidden==YES) {
                TextView.contentInset = UIEdgeInsetsMake(2, TextView.contentInset.right, 2, TextView.contentInset.right);
            }else{
                TextView.contentInset = UIEdgeInsetsMake(inset, TextView.contentInset.left, 0, TextView.contentInset.left);
            }
        }else{
            CGFloat inset = MAX(0, 0);
            if (self.PlaceholdLabel.isHidden==YES) {
                TextView.contentInset = UIEdgeInsetsMake(2, TextView.contentInset.right, 2, TextView.contentInset.right);
            }else{
                TextView.contentInset = UIEdgeInsetsMake(inset, TextView.contentInset.left, inset, TextView.contentInset.left);
            }
        }
        
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%@",text);
    if ([text isEqualToString:@"\n"]) {
        if ([self.JGZInputTextdelegate respondsToSelector:@selector(SendText:)]) {
            [self.JGZInputTextdelegate SendText:textView.text];
            textView.text=@"";
            [textView insertText:@""];
        }
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
   // NSLog(@"%@",textView.text);
  
    if (textView.text.length>0) {
        self.PlaceholdLabel.hidden=YES;
        CGRect frame = self.frame;
        NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, self.MAXHeight)].height);
        self.scrollEnabled=NO;
        if (height>self.OldFrame.size.height) {
            if (height>self.MAXHeight) {
                if (self.MAXHeight>self.OldFrame.size.height) {
                  height=self.MAXHeight;
                    self.scrollEnabled=YES;
                }
            }
            frame.size.height = height;
            
        }else{
            frame = self.OldFrame;
        }
        self.frame = frame;
    }else{
        self.PlaceholdLabel.hidden=NO;
        self.frame=self.OldFrame;
    }
    [self ChangeDirection];
    if (self.InputViewHeightBlock) {
     self.InputViewHeightBlock(textView.text,self.frame.size.height);   
    }
    
}

-(void)ChangeDirection{
    CGRect frame = self.frame;
    if (self.directiontype==DirectionUp) {
        frame.origin.y = CGRectGetMaxY(self.OldFrame)-frame.size.height;
    }else{
        frame.origin.y = self.OldFrame.origin.y;
    }
    self.frame = frame;

}
-(void)getInputTextViewHeightBlock:(InputTextViewHeight)Block{
    self.InputViewHeightBlock=Block;
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentSize"];
}
-(CGFloat)heightForString:(NSString*)text font:(UIFont*)font width:(CGFloat)width{
    if(text == nil || text.length == 0 || [text isEqual:[NSNull null]]){
        return 0.0f;
    }
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:options attributes:@{NSFontAttributeName: font} context:nil].size;
    
    return size.height;
}

@end
