//
//  GooeySlideMenu.h
//  GooeySlideMenu
//
//  Created by fernando on 2017/2/4.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooeySlideMenu : UIView

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles;

-(id)initWithTitles:(NSArray *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style;

- (void)trigger;

@property (nonatomic, copy) void(^menuClickedBlock)(NSInteger index, NSString *title);

@end
