//
//  QQCuteView.m
//  QQCuteView
//
//  Created by fernando on 2017/2/6.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import "QQCuteView.h"

@implementation QQCuteView {
    UIBezierPath *cutePath;
    UIColor *fillColorForCute; // 气泡填充颜色
    UIDynamicAnimator *animator;
    UISnapBehavior  *snap; // dynamic 震荡效果 UISnapBehavior 震荡行为 荡行为定义了一个动态运动，达到指定点后实现震荡效果，震荡的数量是可以设置的。 配置属性： damping － 动画结束的时候的震荡值 0.0-1.0；其中0.0最小，1.0最大。默认0.5
    
    UIView *backView;
    CGFloat r1; // 小圆半径
    CGFloat r2; // 大圆半径
    CGFloat x1; // 小圆中心x坐标
    CGFloat y1; // 小圆中心y坐标
    CGFloat x2; // 大圆中心x坐标
    CGFloat y2; // 大圆中心y坐标
    CGFloat centerDistance; // 俩圆心之间的距离
    CGFloat cosDigree;
    CGFloat sinDigree;
    
    // http://kittenyang.com/content/images/2015/Mar/Screen-Shot-2015-03-03-at-14-25-22.png
    CGPoint pointA; //A
    CGPoint pointB; //B
    CGPoint pointD; //D
    CGPoint pointC; //C
    CGPoint pointO; //O
    CGPoint pointP; //P
    
    CGRect oldBackViewFrame;
    CGPoint initialPoint;
    CGPoint oldBackViewCenter;
    CAShapeLayer *shapeLayer;
}

- (id)initWithPoint:(CGPoint)point superView:(UIView *)sView {
    self = [super initWithFrame:CGRectMake(point.x, point.y, self.bubbleWidth, self.bubbleWidth)];
    if (self) {
        initialPoint = point;
        self.containerView = sView;
        [self.containerView addSubview:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)drawRect {
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    } else {
        cosDigree = (y2 - y1)/centerDistance;
        sinDigree = (x2 - x1)/centerDistance;
    }
    
    r1 = oldBackViewFrame.size.width/2 - centerDistance/self.viscosity;
    
    pointA = CGPointMake(x1 - r1 * cosDigree, y1 + r1 * sinDigree);
    pointB = CGPointMake(x1 + r1 * cosDigree, y1 - r1 * sinDigree);
    pointD = CGPointMake(x2 - r2 * cosDigree, y2 + r2 * sinDigree);
    pointC = CGPointMake(x2 + r2 * cosDigree, y2 - r2 * sinDigree);
    
    pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
    
    backView.center = oldBackViewCenter;
    backView.bounds = CGRectMake(0, 0, r1*2, r2*2);
    backView.layer.cornerRadius = r1;
    
    cutePath = [UIBezierPath bezierPath];
    [cutePath moveToPoint:pointA];
    [cutePath addQuadCurveToPoint:pointD controlPoint:pointO];
    [cutePath moveToPoint:pointC];
    [cutePath addQuadCurveToPoint:pointB controlPoint:pointP];
    [cutePath moveToPoint:pointA];

    if (!backView.hidden) {
        shapeLayer.path = cutePath.CGPath;
        shapeLayer.fillColor = fillColorForCute.CGColor;
        [self.containerView.layer insertSublayer:shapeLayer below:self.frontView.layer];
    }
}

- (void)setUp {
    shapeLayer = [CAShapeLayer layer];
    self.backgroundColor = [UIColor clearColor];
    self.frontView = [[UIView alloc] initWithFrame:CGRectMake(initialPoint.x, initialPoint.y, self.bubbleWidth, self.bubbleWidth)];
    
    r2 = self.frontView.bounds.size.width/2;
    self.frontView.layer.cornerRadius = r2;
    self.frontView.backgroundColor = self.bubbleColor;

    backView = [[UIView alloc] initWithFrame:self.frontView.frame];
    r1 = backView.bounds.size.width/2;
    backView.layer.cornerRadius = r1;
    backView.backgroundColor = self.bubbleColor;
    
    self.bubbleLabel = [[UILabel alloc]init];
    self.bubbleLabel.frame = CGRectMake(0, 0, self.frontView.bounds.size.width, self.frontView.bounds.size.height);
    self.bubbleLabel.textColor = [UIColor whiteColor];
    self.bubbleLabel.textAlignment = NSTextAlignmentCenter;

    [self.frontView insertSubview:self.bubbleLabel atIndex:0];

    [self.containerView addSubview:backView];
    [self.containerView addSubview:self.frontView];

    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;

    pointA = CGPointMake(x1-r1,y1);   // A
    pointB = CGPointMake(x1+r1, y1);  // B
    pointD = CGPointMake(x2-r2, y2);  // D
    pointC = CGPointMake(x2+r2, y2);  // C
    pointO = CGPointMake(x1-r1,y1);   // O
    pointP = CGPointMake(x2+r2, y2);  // P
//
    oldBackViewFrame = backView.frame;
    oldBackViewCenter = backView.center;
//
    backView.hidden = YES;//为了看到 frontView 的气泡晃动效果，需要暂时隐藏 backView
    [self addAniamtionLikeGameCenterBubble];
//
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleDragGesture:)];
    [self.frontView addGestureRecognizer:pan];
}

- (void)handleDragGesture:(UIPanGestureRecognizer *)ges {
    CGPoint dragPoint = [ges locationInView:self.containerView];
    if (ges.state == UIGestureRecognizerStateBegan) {
        backView.hidden = NO;
        fillColorForCute = self.bubbleColor;
        [self RemoveAniamtionLikeGameCenterBubble];
    } else if (ges.state == UIGestureRecognizerStateChanged) {
        self.frontView.center = dragPoint;
        if (r1 < 6) {
            fillColorForCute = [UIColor clearColor];
            backView.hidden = YES;
            [shapeLayer removeFromSuperlayer];
        }
        [self drawRect];
    } else if (ges.state == UIGestureRecognizerStateEnded || ges.state ==UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateFailed) {
        backView.hidden = YES;
        fillColorForCute = [UIColor clearColor];
        [shapeLayer removeFromSuperlayer];
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frontView.center = oldBackViewCenter;
        } completion:^(BOOL finished) {
            if (finished) {
                [self addAniamtionLikeGameCenterBubble];
            }
        }];
    }
}
//---- 类似GameCenter的气泡晃动动画 ------

-(void)addAniamtionLikeGameCenterBubble {
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.frontView.frame, self.frontView.bounds.size.width / 2 - 3, self.frontView.bounds.size.width / 2 - 3);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.frontView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}

-(void)RemoveAniamtionLikeGameCenterBubble {
    [self.frontView.layer removeAllAnimations];
}

@end