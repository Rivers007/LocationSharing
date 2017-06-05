//
//  JGZEmojinManager.m
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/30.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import "JGZEmojiManager.h"
#import "JGZEmojiModel.h"
#import "JGZTextAttachment.h"
@interface JGZEmojiManager ()
@property (nonatomic,strong) NSArray *AllEmojiModelArray;
@end

@implementation JGZEmojiManager

-(NSArray *)emotionArray{
    if (!_emotionArray) {
        _emotionArray = [NSArray array];
    }
    return _emotionArray;
}
-(NSDictionary *)emotionDictionary{
    if (!_emotionDictionary) {
        _emotionDictionary = [NSDictionary dictionary];
    }
    return _emotionDictionary;
}
-(NSArray *)AllEmojiModelArray{
    if (!_AllEmojiModelArray) {
        _AllEmojiModelArray=[NSArray array];
    }
    return _AllEmojiModelArray;
}
+(instancetype)sharemanager{
    static JGZEmojiManager *_EmojiManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_EmojiManager==nil) {
            _EmojiManager=[[JGZEmojiManager alloc] init];
        }
    });
    return _EmojiManager;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        self.emotionWH = emotionWH;
        self.colsOfPage=colsOfPage;
        self.emojiCountOfPage=emojiCountOfPage;
     [self CreatEmojiModel];
    }
    return self;
}
-(NSArray *)GetAllemojiModelArray{
    return self.AllEmojiModelArray;
}
-(void)CreatEmojiModel{
    NSDictionary *AllemojiDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expressionImage_custom" ofType:@"plist"]];
    self.emotionDictionary=AllemojiDict;
    self.emotionArray = [self.emotionDictionary allKeys];
    self.emotionPage=(self.emotionArray.count-1)/emojiCountOfPage+1;
    
    NSMutableArray *emojiArray=[NSMutableArray arrayWithCapacity:0];
    for (NSInteger i=0; i<self.emotionPage; i++) {
        NSMutableArray *emojipagearray = [NSMutableArray arrayWithCapacity:0];
        NSInteger startindex = 0;
        NSInteger endindex =0;
        if (i<self.emotionPage-1) {
            startindex = i*emojiCountOfPage;
            endindex = (i+1)*emojiCountOfPage;
        }else{
            startindex = i*emojiCountOfPage;
            endindex = self.emotionArray.count;
        }
        for (NSInteger j=startindex; j<endindex; j++) {
            JGZEmojiModel *model = [[JGZEmojiModel alloc] init];
            NSString *emojiString = self.emotionArray[j];
            NSString *emojiImageString = self.emotionDictionary[emojiString];
            model.emojiString = emojiString;
            model.emojiImageString = emojiImageString;
            [emojipagearray addObject:model];
        }
        [emojiArray addObject:emojipagearray];
    }
    self.AllEmojiModelArray=emojiArray;
}


// 获取表情字符串

-(NSString *)GetEmojiToStringOfTextView:(UITextView *)textview
{
    
    NSMutableString *strM = [NSMutableString string];
    
    [textview.attributedText enumerateAttributesInRange:NSMakeRange(0, textview.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *str = nil;
        
        JGZTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment) { // 表情
            str = attachment.emojiString;
            [strM appendString:str];
        } else { // 文字
            str = [textview.attributedText.string substringWithRange:range];
            [strM appendString:str];
        }
        
    }];
    return strM;
}

-(NSString *)GetEmojiToStringOfTextField:(UITextField *)textfield{
    NSMutableString *strM = [NSMutableString string];
    
    [textfield.attributedText enumerateAttributesInRange:NSMakeRange(0, textfield.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *str = nil;
        
        JGZTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment) { // 表情
            str = attachment.emojiString;
            [strM appendString:str];
        } else { // 文字
            str = [textfield.attributedText.string substringWithRange:range];
            [strM appendString:str];
        }
        
    }];
    return strM;
}
@end
