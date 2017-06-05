//
//  JGZInputTextView.h
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/25.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,TextViewVerticallyStyle){
    TextViewVerticallyTop,
    TextViewVerticallyCenter,
    TextViewVerticallybottom
    
};
typedef NS_ENUM(NSInteger,TextViewHorizontalStyle){
    TextViewHorizontalLeft,
    TextViewHorizontalCenter,
    TextViewHorizontalRight
    
};
typedef NS_ENUM(NSInteger,DirectionType) {
    DirectionDown,
    DirectionUp
    
};

typedef void(^InputTextViewHeight)(NSString *text,CGFloat InputViewHeight);

@protocol JGZInputTextViewDelegate <NSObject>

-(void)SendText:(NSString *)text;

@end

@interface JGZInputTextView : UITextView<UITextViewDelegate>

@property (nonatomic,weak) id<JGZInputTextViewDelegate>JGZInputTextdelegate;

@property (nonatomic,strong) UILabel *PlaceholdLabel;

@property (nonatomic,assign) TextViewHorizontalStyle TextViewHorizontalStyle;
@property (nonatomic,assign) TextViewVerticallyStyle TextViewVerticallyStyle;
@property (nonatomic,assign) DirectionType directiontype;
@property (nonatomic,assign) CGFloat MAXHeight;
@property (nonatomic,assign) CGFloat borderWidth;
@property (nonatomic,assign) CGFloat cornerRadius;
@property (nonatomic,assign) UIColor *borderColor;
- (id)initWithFrame:(CGRect)frame font:(UIFont *)font;
-(void)getInputTextViewHeightBlock:(InputTextViewHeight)Block;
@end
