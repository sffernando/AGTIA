//
//  GooeySlideMenu.m
//  GooeySlideMenu
//
//  Created by fernando on 2017/2/4.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import "GooeySlideMenu.h"
#import "SlideMenuButton.h"

#define buttonSpace 30
#define menuBlankWidth 50

@interface GooeySlideMenu () {
    UIVisualEffectView *blurView;
    UIView *helperSideView;
    UIView *helperCenterView;
    UIWindow *keyWindow;
    BOOL triggered;
    CGFloat diff;
    UIColor *_menuColor;
    CGFloat menuButtonHeight;
}

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger animationCount; // 动画的数量

@end

@implementation GooeySlideMenu

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles {
    return [self initWithTitles:titles buttonHeight:40.0f menuColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1] backBlurStyle:UIBlurEffectStyleDark];
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles buttonHeight:(CGFloat)buttonHeight menuColor:(UIColor *)menuColor backBlurStyle:(UIBlurEffectStyle)blurStyle
{
    if (self = [super init]) {
        keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:blurStyle]];
        blurView.frame = keyWindow.frame;
        blurView.alpha = 0.0;
        
        helperSideView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
        helperSideView.backgroundColor = [UIColor redColor];
        helperSideView.hidden = YES;
        [keyWindow addSubview:helperSideView];
        
        
        helperCenterView = [[UIView alloc] initWithFrame:CGRectMake(-40, CGRectGetHeight(keyWindow.frame)/2 - 20, 40, 40)];
        helperCenterView.backgroundColor = [UIColor yellowColor];
        helperCenterView.hidden = YES;
        [keyWindow addSubview:helperCenterView];
        
        self.frame = CGRectMake(-keyWindow.frame.size.width/2 - menuBlankWidth, 0, keyWindow.frame.size.width/2+menuBlankWidth, keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        [keyWindow insertSubview:self belowSubview:helperSideView];
        
        _menuColor = menuColor;
        menuButtonHeight = buttonHeight;
        [self addButtonsWithTitles:titles];
    }
    return self;
}


- (void)addButtonsWithTitles:(NSArray *)titles {
    if (titles.count % 2 == 0) {
        NSInteger index_down = titles.count / 2;
        NSInteger index_up = -1;
        for (NSInteger i = 0; i < titles.count; i ++) {
            NSString *title = titles[i];
            SlideMenuButton *button = [[SlideMenuButton alloc] initWithTitle:title];
            if (i >= titles.count / 2) {
                index_up ++;
                button.center = CGPointMake(keyWindow.frame.size.width/4, keyWindow.frame.size.height/2 + menuButtonHeight*index_up + buttonSpace*index_up + buttonSpace/2 + menuButtonHeight/2);
            } else {
                index_down --;
                button.center = CGPointMake(keyWindow.frame.size.height/4, keyWindow.frame.size.height/2 - menuButtonHeight*index_down - buttonSpace*index_down - buttonSpace/2 - menuButtonHeight/2);
            }
            
            button.bounds = CGRectMake(0, 0, keyWindow.frame.size.width/2 - 20 * 2, menuButtonHeight);
            button.buttonColor = _menuColor;
            [self addSubview:button];
            
            __weak typeof(self) weakSelf = self;
            button.buttonClickedBlock = ^(){
                [weakSelf tapToUnTrigger];
                weakSelf.menuClickedBlock(i, title);
            };
        }
    } else {
        NSInteger index = (titles.count - 1) / 2 + 1;
        for (NSInteger i = 0; i < titles.count; i++) {
            index --;
            NSString *title = titles[i];
            SlideMenuButton *button = [[SlideMenuButton alloc] initWithTitle:title];
            button.center = CGPointMake(keyWindow.frame.size.width/4, keyWindow.frame.size.height/2 - menuButtonHeight*index - 20 * index);
            button.bounds = CGRectMake(0, 0, keyWindow.frame.size.width/2 - 20*2, menuButtonHeight);
            button.buttonColor = _menuColor;
            [self addSubview:button];
            
            __weak typeof(self) weakSelf = self;
            button.buttonClickedBlock = ^(){
                [weakSelf tapToUnTrigger];
                weakSelf.menuClickedBlock(i, title);
            };
        }
    }
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width-menuBlankWidth, 0)];
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width-menuBlankWidth, self.frame.size.height) controlPoint:CGPointMake(keyWindow.frame.size.width/2+diff, keyWindow.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, path.CGPath);
    [_menuColor set];
    CGContextFillPath(ctx);
}

- (void)trigger {
    if (triggered) {
        [self tapToUnTrigger];
    } else {
        [keyWindow insertSubview:blurView belowSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.bounds;
        }];
        [self beforeAnimation];
//
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            helperSideView.center = CGPointMake(keyWindow.center.x, helperSideView.frame.size.height/2);
        } completion:^(BOOL finished) {
            [self finishAnimation];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            blurView.alpha = 1.0f;
        }];
        
        [self beforeAnimation];

        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8f initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            helperCenterView.center = keyWindow.center;
        } completion:^(BOOL finished) {
            if (finished) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToUnTrigger)];
                [blurView addGestureRecognizer:tap];
                [self finishAnimation];
            }
        }];
        [self animateButtons];
        triggered = YES;
    }
}

- (void)animateButtons {
    for (NSUInteger i = 0; i < self.subviews.count; i++) {
        UIView *menuButton = self.subviews[i];
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        [UIView animateWithDuration:0.7 delay:i*(0.3/self.subviews.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            menuButton.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }
}

- (void)tapToUnTrigger {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(-keyWindow.frame.size.width/2-menuBlankWidth, 0, keyWindow.frame.size.width/2+menuBlankWidth, keyWindow.frame.size.height);
    }];
    
    [self beforeAnimation];
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        helperSideView.center = CGPointMake(-helperSideView.frame.size.height/2, helperSideView.frame.size.height/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        blurView.alpha = 0.0f;
    }];
    [self beforeAnimation];

    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:2.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        helperCenterView.center = CGPointMake(-helperCenterView.frame.size.height/2, CGRectGetHeight(keyWindow.frame)/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    triggered = NO;
}

// 动画之前调用
- (void)beforeAnimation {
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}

// // 动画完成之后调用
- (void)finishAnimation {
    self.animationCount --;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)displayLinkAction:(CADisplayLink *)dis {
    CALayer *sideHelperPresentationLayer = (CALayer *)[helperSideView.layer presentationLayer];
    CALayer *centerHelperPresitationLayer = (CALayer *)[helperCenterView.layer presentationLayer];
    
    CGRect centerRect = [[centerHelperPresitationLayer valueForKey:@"frame"] CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKey:@"frame"] CGRectValue];
    
    diff = sideRect.origin.x = centerRect.origin.x;
    
    [self setNeedsDisplay];
}

@end
