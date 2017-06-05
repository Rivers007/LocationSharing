//
//  JGZEmojiCollectionCell.h
//  JGZInputTextView
//
//  Created by 江贵铸 on 2016/12/31.
//  Copyright © 2016年 江贵铸. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGZEmojiCollectionCell : UICollectionViewCell
@property (nonatomic,strong) NSArray *EmojiArrayOfPage;
+(id)CellWithCollectionView:(UICollectionView *)CollectionView ReuseIdentifier:(NSString *)ReuseIdentifier EmojiArrayOfPage:(NSArray *)EmojiArrayOfPage forIndexPath:(NSIndexPath *)IndexPath;
@end
