//
//  QQCuteView.h
//  QQCuteView
//
//  Created by fernando on 2017/2/6.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQCuteView : UIView

@property (nonatomic, strong) UIView *containerView; // 父试图
@property (nonatomic, strong) UILabel *bubbleLabel;  // 气泡上显示数字的label
@property (nonatomic, assign) CGFloat bubbleWidth;   // 气泡的直径
@property (nonatomic, assign) CGFloat viscosity;     // 气泡粘性系数，越大拉的越长
@property (nonatomic, strong) UIColor *bubbleColor; // 气泡的颜色
@property (nonatomic, strong) UIView *frontView;     // 隐藏气泡的时候可以使用self.frontView.hidden=YES

- (id)initWithPoint:(CGPoint)point superView:(UIView *)sView;
- (void)setUp;

@end
