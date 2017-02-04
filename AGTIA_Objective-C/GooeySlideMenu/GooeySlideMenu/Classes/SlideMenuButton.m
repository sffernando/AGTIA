//
//  SlideMenuButton.m
//  GooeySlideMenu
//
//  Created by fernando on 2017/2/4.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import "SlideMenuButton.h"

@interface SlideMenuButton ()

@property (nonatomic, copy) NSString  *buttonTitle;

@end

@implementation SlideMenuButton

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.buttonTitle = title;
        self.buttonColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, rect);
    [self.buttonColor set];
    CGContextFillPath(ctx);
    
    UIBezierPath *roundedRactabglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:rect.size.height/2];
    [self.buttonColor setFill];
    [roundedRactabglePath fill];
    [[UIColor whiteColor] setStroke];
    roundedRactabglePath.lineWidth = 1;
    [roundedRactabglePath stroke];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attr = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:24], NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGSize size = [self.buttonTitle sizeWithAttributes:attr];
    
    CGRect r = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - size.height)/2.0, rect.size.width, size.height);
    [self.buttonTitle drawInRect:r withAttributes:attr];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            if (self.buttonClickedBlock) {
                self.buttonClickedBlock();
            }
            break;
            
        default:
            break;
    }
}

@end
