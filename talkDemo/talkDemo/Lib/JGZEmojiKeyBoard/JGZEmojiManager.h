//
//  JGZEmojinManager.h
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/30.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import <UIKit/UIKit.h>

// 一页多少个
static NSInteger const emojiCountOfPage = 20;

// 一页多少列
static NSInteger const colsOfPage = 7;

// 每个emotion尺寸
static NSInteger const emotionWH = 30;

@interface JGZEmojiManager : NSObject
/** 所有表情 */
@property (nonatomic,strong) NSArray *emotionArray;

/** 表情对应的字符串字典 */
@property (nonatomic,strong) NSDictionary *emotionDictionary;

/** 总页码 */
@property (nonatomic,assign) NSInteger emotionPage;
@property (nonatomic,assign) NSInteger emotionWH;
@property (nonatomic,assign) NSInteger colsOfPage;
@property (nonatomic,assign) NSInteger emojiCountOfPage;

+(instancetype)sharemanager;
/**
 *获取所有表情的模型
 */
- (NSArray *)GetAllemojiModelArray;

-(NSString *)GetEmojiToStringOfTextView:(UITextView *)textview;
-(NSString *)GetEmojiToStringOfTextField:(UITextField *)textfield;
@end
