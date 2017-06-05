//
//  JGZEmojiKeyBoard.m
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/30.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import "JGZEmojiKeyBoard.h"
#import "JGZEmojiManager.h"
#import "JGZEmojiCollectionCell.h"
#import "JGZEmojiModel.h"
#import "JGZTextAttachment.h"
// RGB颜色
#define JGZColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 随机色
#define JGZRandomColor JGZColor(arc4random_uniform(250), arc4random_uniform(230), arc4random_uniform(256))
@interface JGZEmojiKeyBoard ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *AllemojiModelArray;
@property (nonatomic,strong) UICollectionView *CollectionView;
@property (nonatomic,strong) UIPageControl *pagecontroller;
@property (nonatomic,strong) UITextField *InputTextField;
@property (nonatomic,strong) UITextView *InputTextView;
@end
@implementation JGZEmojiKeyBoard

-(NSMutableArray *)AllemojiModelArray{
    if (!_AllemojiModelArray) {
        _AllemojiModelArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _AllemojiModelArray;
}
-(id)initWithTextView:(UITextView *)TextView{
    self=[super init];
    if (self) {
        self.InputTextView=TextView;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 210);
        self.backgroundColor=[UIColor colorWithHue:0.303 saturation:0 brightness:0.949 alpha:1];
        self.AllemojiModelArray = [NSMutableArray arrayWithArray:[[JGZEmojiManager sharemanager] GetAllemojiModelArray]];
        //创建collectionview
        [self CrectCollectionView];
        [self CreatPageController];
        [self CreatBottomBar];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickDelete) name:@"didDeleteEmoji" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectEmoji:) name:@"didSelectEmoji" object:nil];
    }
    return self;
}
-(id)initWithTextField:(UITextField *)TextField{
    self=[super init];
    if (self) {
        self.InputTextField=TextField;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 210);
        self.backgroundColor=[UIColor colorWithHue:0.303 saturation:0 brightness:0.949 alpha:1];
        self.AllemojiModelArray = [NSMutableArray arrayWithArray:[[JGZEmojiManager sharemanager] GetAllemojiModelArray]];
        //创建collectionview
        [self CrectCollectionView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickDelete) name:@"didClickDelete" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectEmoji:) name:@"didSelectEmoji" object:nil];
    }
    return self;
}
// 点击删除按钮
- (void)didClickDelete
{
    [self.InputTextView deleteBackward];

}

// 点击表情
- (void)didSelectEmoji:(NSNotification *)note
{
    JGZEmojiModel *emojimodel = note.object;
    
    NSRange range = self.InputTextView.selectedRange;
    
    // 设置textView的文字
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.InputTextView.attributedText];
    JGZTextAttachment *attachment=[[JGZTextAttachment alloc] init];
    attachment.emojiString=emojimodel.emojiString;
    UIImage *emojiImage = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"JGZEmoji_Expression" ofType:@"bundle"] stringByAppendingPathComponent:emojimodel.emojiImageString]];
    attachment.image = emojiImage;
    attachment.bounds = CGRectMake(0, -.19f * self.InputTextView.font.lineHeight, self.InputTextView.font.lineHeight, self.InputTextView.font.lineHeight);
    NSAttributedString *imageAttr = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    
    [textAttr replaceCharactersInRange:self.InputTextView.selectedRange withAttributedString:imageAttr];
    [textAttr addAttributes:@{NSFontAttributeName : self.InputTextView.font} range:NSMakeRange(self.InputTextView.selectedRange.location, 1)];
    
    self.InputTextView.attributedText = textAttr;
    
    // 会在textView后面插入空的,触发textView文字改变
    [self.InputTextView insertText:@""];
    
    // 设置光标位置
    self.InputTextView.selectedRange = NSMakeRange(range.location + 1, 0);

}

-(void)CrectCollectionView{
    CGFloat CollectionW=self.frame.size.width;
    CGFloat CollectionH=self.frame.size.height-40;
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(CollectionW, CollectionH);
    flowlayout.minimumLineSpacing=0;
    flowlayout.minimumInteritemSpacing=0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CollectionW, CollectionH) collectionViewLayout:flowlayout];
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource=self;
    self.CollectionView.pagingEnabled=YES;
    self.CollectionView.showsVerticalScrollIndicator=NO;
    self.CollectionView.showsHorizontalScrollIndicator=NO;
    self.CollectionView.backgroundColor=[UIColor colorWithHue:0.303 saturation:0 brightness:0.949 alpha:1];
    [self.CollectionView registerClass:[JGZEmojiCollectionCell class] forCellWithReuseIdentifier:@"JGZEmojiCollectionCell"];
    [self addSubview:self.CollectionView];
}
-(void)CreatPageController{
    UIPageControl *pagecontroller = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 10)];
    self.pagecontroller=pagecontroller;
    pagecontroller.numberOfPages = [[JGZEmojiManager sharemanager] emotionPage];
    pagecontroller.currentPage = 0;
    pagecontroller.pageIndicatorTintColor = [UIColor lightGrayColor];
    pagecontroller.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self addSubview:pagecontroller];
}
-(void)CreatBottomBar{
    UIView *BottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 30)];
    BottomBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BottomBgView];
    
    UIButton *sendbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendbtn setTitle:@"发送" forState:UIControlStateNormal];
    sendbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [sendbtn setBackgroundColor:[UIColor grayColor]];
    sendbtn.frame=CGRectMake(self.frame.size.width-40, 0, 40, 30);
    [sendbtn addTarget:self action:@selector(sendbtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [BottomBgView addSubview:sendbtn];
}
-(void)sendbtnclick:(UIButton *)btn{
    NSString *string = [[JGZEmojiManager sharemanager] GetEmojiToStringOfTextView:self.InputTextView];
    self.InputTextView.text=@"";
    [self.InputTextView insertText:@""];
    if ( [self.delegate respondsToSelector:@selector(SendButtonClick:)]) {
        [self.delegate SendButtonClick:string];
    }
}
#pragma mark--UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.AllemojiModelArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JGZEmojiCollectionCell *cell = [self.CollectionView dequeueReusableCellWithReuseIdentifier:@"JGZEmojiCollectionCell" forIndexPath:indexPath];
    //cell.backgroundColor=JGZRandomColor;
    cell.EmojiArrayOfPage = self.AllemojiModelArray[indexPath.item];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentpage = scrollView.contentOffset.x/self.frame.size.width;
    self.pagecontroller.currentPage=currentpage;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
