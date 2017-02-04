//
//  SlideMenuButton.h
//  GooeySlideMenu
//
//  Created by fernando on 2017/2/4.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuButton : UIView


/**
 convenient init method

 @param title title
 @return instancetype
 */
- (instancetype)initWithTitle:(NSString *)title;


/**
 button color
 */
@property (nonatomic, strong) UIColor *buttonColor;


/**
 button clicked block
 */
@property (nonatomic, copy) void(^buttonClickedBlock)();

@end
