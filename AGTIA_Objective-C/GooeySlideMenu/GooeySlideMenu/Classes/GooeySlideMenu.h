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

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
                  buttonHeight:(CGFloat)buttonHeight
                     menuColor:(UIColor *)menuColor
                 backBlurStyle:(UIBlurEffectStyle)blurStyle;

- (void)trigger;

@property (nonatomic, copy) void(^menuClickedBlock)(NSInteger index, NSString *title);

@end
