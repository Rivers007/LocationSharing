//
//  MAAnnotationView+JGZMAAnnotationView.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/6/6.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "MAAnnotationView+JGZMAAnnotationView.h"

@implementation MAAnnotationView (JGZMAAnnotationView)
-(void)rotateWithHeading:(CLHeading *)heading{
    //将设备的方向角度换算成弧度
    CGFloat headings = M_PI * heading.magneticHeading / 180.0;
    //创建不断旋转CALayer的transform属性的动画
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    //动画起始值
    CATransform3D formValue = self.layer.transform;
    rotateAnimation.fromValue = [NSValue valueWithCATransform3D:formValue];
    //绕Z轴旋转heading弧度的变换矩阵
    CATransform3D toValue = CATransform3DMakeRotation(headings, 0, 0, 1);
    //设置动画结束值
    rotateAnimation.toValue = [NSValue valueWithCATransform3D:toValue];
    rotateAnimation.duration = 0.35;
    rotateAnimation.removedOnCompletion = YES;
    //设置动画结束后layer的变换矩阵
    self.layer.transform = toValue;
    //添加动画
    [self.layer addAnimation:rotateAnimation forKey:nil];
    
}
-(void)rotateWithmagneticHeading:(CGFloat)magneticHeading{
    //将设备的方向角度换算成弧度
    CGFloat headings = M_PI * magneticHeading / 180.0;
    //创建不断旋转CALayer的transform属性的动画
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    //动画起始值
    CATransform3D formValue = self.layer.transform;
    rotateAnimation.fromValue = [NSValue valueWithCATransform3D:formValue];
    //绕Z轴旋转heading弧度的变换矩阵
    CATransform3D toValue = CATransform3DMakeRotation(headings, 0, 0, 1);
    //设置动画结束值
    rotateAnimation.toValue = [NSValue valueWithCATransform3D:toValue];
    rotateAnimation.duration = 0.35;
    rotateAnimation.removedOnCompletion = YES;
    //设置动画结束后layer的变换矩阵
    self.layer.transform = toValue;
    //添加动画
    [self.layer addAnimation:rotateAnimation forKey:nil];
    
}
@end
