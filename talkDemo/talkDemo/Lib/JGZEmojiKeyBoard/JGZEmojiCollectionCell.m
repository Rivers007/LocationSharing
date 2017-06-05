//
//  JGZEmojiCollectionCell.m
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/31.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import "JGZEmojiCollectionCell.h"
#import "JGZEmojiManager.h"
#import "JGZEmojiCell.h"
#import "JGZEmojiModel.h"
// RGB颜色
#define JGZColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 随机色
#define JGZRandomColor JGZColor(arc4random_uniform(250), arc4random_uniform(230), arc4random_uniform(256))
@interface JGZEmojiCollectionCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *CollectionView;
@end

@implementation JGZEmojiCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
     [self CreatCollectionView];
    }
    return self;
}
-(void)CreatCollectionView{
    CGFloat itemWH=self.frame.size.width/[[JGZEmojiManager sharemanager] colsOfPage];
    CGFloat marginV = (self.frame.size.height-3*itemWH)/4;
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(itemWH, itemWH);
    flowlayout.minimumLineSpacing=marginV;
    flowlayout.minimumInteritemSpacing=0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, marginV, self.frame.size.width, self.frame.size.height-marginV*2) collectionViewLayout:flowlayout];
    self.CollectionView.pagingEnabled=YES;
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource=self;
    self.CollectionView.backgroundColor=[UIColor clearColor];
    [self.CollectionView registerClass:[JGZEmojiCell class] forCellWithReuseIdentifier:@"JGZEmojiCell"];
    [self addSubview:self.CollectionView];
}
-(void)setEmojiArrayOfPage:(NSArray *)EmojiArrayOfPage{
    _EmojiArrayOfPage=EmojiArrayOfPage;

    [self.CollectionView reloadData];
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
#pragma mark-UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.EmojiArrayOfPage.count+1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JGZEmojiCell *cell = [self.CollectionView dequeueReusableCellWithReuseIdentifier:@"JGZEmojiCell" forIndexPath:indexPath];
    cell.EmojiImageView.image=[UIImage imageNamed:@""];
    cell.backgroundColor=[UIColor clearColor];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (indexPath.item==self.EmojiArrayOfPage.count) {
            UIImage *emojiImage = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"JGZEmoji_Expression" ofType:@"bundle"] stringByAppendingPathComponent:@"delete"]];
            dispatch_async(dispatch_get_main_queue(), ^{
              cell.EmojiImageView.image = emojiImage;
            });
            
        }else{
            JGZEmojiModel *emojimodel=self.EmojiArrayOfPage[indexPath.item];
            UIImage *emojiImage = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"JGZEmoji_Expression" ofType:@"bundle"] stringByAppendingPathComponent:emojimodel.emojiImageString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.EmojiImageView.image = emojiImage;
            });
        }
    });
   
   // cell.backgroundColor = JGZRandomColor;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item==self.EmojiArrayOfPage.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didDeleteEmoji" object:nil];
        
    }else{
        JGZEmojiModel *emojimodel=self.EmojiArrayOfPage[indexPath.item];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectEmoji" object:emojimodel];
    }

}
@end
