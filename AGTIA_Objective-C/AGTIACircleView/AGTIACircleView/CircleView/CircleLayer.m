//
//  CircleLayer.m
//  AGTIACircleView
//
//  Created by fernando on 2017/2/3.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import "CircleLayer.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MovingPoint){
    Point_B,
    Point_D
};

// 外接矩形的边长
#define outsideRectSize 90

@interface CircleLayer ()
// 外接矩形的尺寸
@property (nonatomic, assign) CGRect outSideRect;
// 上次的progress， 方便做差得出拖动方向
@property (nonatomic, assign) CGFloat lastProgress;
// 实时记录滑动方向
@property (nonatomic, assign) MovingPoint movingPoint;

@end

@implementation CircleLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lastProgress = 0.5;
    }
    return self;
}

- (instancetype)initWithLayer:(CircleLayer *)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        self.outSideRect = layer.outSideRect;
        self.lastProgress = layer.lastProgress;
        self.movingPoint = layer.movingPoint;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    // 判断拖动的方向
    if (progress <= 0.5) {  // 外接矩形在左，则改变B点
        self.movingPoint = Point_B;
        NSLog(@"B点动");
    } else { // 外接矩形在右，则改变D点
        self.movingPoint = Point_D;
        NSLog(@"D点动");
    }
    
    self.lastProgress = progress;
    
    // 计算外接矩阵的位置大小
    CGFloat x = self.position.x - outsideRectSize/2 + (progress - 0.5)*(self.frame.size.width - outsideRectSize);
    CGFloat y = self.position.y - outsideRectSize/2;
    
    self.outSideRect = CGRectMake(x, y, outsideRectSize, outsideRectSize);
    
    // 开始绘制
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    // “offset 指的是 A-C1,B-C2... 的距离，当该值设置为正方形边长的 1/3.6 倍时，画出来的圆弧近似贴合 1/4 圆。为什么是 3.6 ？这里 有一篇文章。文章里三阶贝塞尔曲线拟合 1/4 圆的时候最佳参数 h=0.552,  表示的意义是：当正方形边长的 1/2 为 1 （ 即正方形边长为 2） 时， offset  等于 0.552  就能使圆弧近似贴近 1/4 圆。所以比例系数为 1/0.552 ，即正方形边长和 offset 的比例系数为：2/0.552 = 3.623。近似于 3.6。其实还有种更直观的近似方法：如果圆心为 O，OC1, OC2  就一定是三等分点，也就是夹角为 30°，那么 AC1 （也就是 offset  ）就等于 1/2的边长 *  tan30° 。
    // “顺便解释两个地方。1.为什么要*2? 因为为了让  D 点区别于 A 点，让 D 移动距离比 A 多，你完全可以 *3 ,*2.5，但是不能移动太远。2.为什么要是1/6？这个 1/6 也是自己定的。你可以让 A 移动 1/7 ，1/10 都可以，但是最好不要太靠近 1/2，这时 A 点就移到中点了，形变的样子就不好看了。”
    // A-C1, B-C2 ... 的距离，当设置为正方形边长的1/3.6时，画出的圆弧完美贴合圆形
    CGFloat offset = self.outSideRect.size.width / 3.6;
    
    // A.B.C.D实际需要移动的距离.系数为滑块偏离中点0.5的绝对值乘以2.当滑到两端的时候，movedDistance为最大值:「外接矩形宽度的1/6」
    CGFloat movedDistance = self.outSideRect.size.width / 6 * fabs(self.progress - 0.5)*2;
    
    // 方便下方计算各点坐标，先计算出外接矩形的中心点坐标
    CGPoint rectCenter = CGPointMake(self.outSideRect.origin.x + self.outSideRect.size.width/2, self.outSideRect.origin.y + self.outSideRect.size.height/2);
    
    CGPoint pointA = CGPointMake(rectCenter.x, self.outSideRect.origin.y + movedDistance);
    CGPoint pointB = CGPointMake(self.movingPoint == Point_D ? rectCenter.x + self.outSideRect.size.width/2 : rectCenter.x + self.outSideRect.size.width/2 + movedDistance * 2, rectCenter.y);
    CGPoint pointC = CGPointMake(rectCenter.x, rectCenter.y + self.outSideRect.size.height/2 - movedDistance);
    CGPoint pointD = CGPointMake(self.movingPoint == Point_D ? rectCenter.x - self.outSideRect.size.width/2 - movedDistance * 2 : self.outSideRect.origin.x, rectCenter.y);

    
    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, self.movingPoint == Point_D ? pointB.y - offset : pointB.y - offset + movedDistance);
    CGPoint c3 = CGPointMake(pointB.x, self.movingPoint == Point_D ? pointB.y + offset : pointB.y + offset - movedDistance);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, self.movingPoint == Point_D ? pointD.y + offset - movedDistance: pointD.y + offset);
    CGPoint c7 = CGPointMake(pointD.x, self.movingPoint == Point_D ? pointD.y - offset + movedDistance: pointD.y - offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
    
    // 外接虚线矩形
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.outSideRect];
    CGContextAddPath(ctx, rectPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGFloat dash[] = {5.0, 5.0};
    CGContextSetLineDash(ctx, 0.0, dash, 2);
    CGContextStrokePath(ctx);
    
    
    // 圆的边界
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalPath closePath];
    
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineDash(ctx, 0.0, NULL, 0.0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    // 标记出每个点并且连接， 方便观察， 给所有关键点染黄色， 所有辅助线，黑色
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    NSArray *values = @[[NSValue valueWithCGPoint:pointA],[NSValue valueWithCGPoint:pointB],[NSValue valueWithCGPoint:pointC],[NSValue valueWithCGPoint:pointD],[NSValue valueWithCGPoint:c1],[NSValue valueWithCGPoint:c2],[NSValue valueWithCGPoint:c3],[NSValue valueWithCGPoint:c4],[NSValue valueWithCGPoint:c5],[NSValue valueWithCGPoint:c6],[NSValue valueWithCGPoint:c7],[NSValue valueWithCGPoint:c8]];
    [self drawPoint:values withContext:ctx];
    
    // 连接辅助线
    UIBezierPath *helperPath = [UIBezierPath bezierPath];
    [helperPath moveToPoint:pointA];
    [helperPath addLineToPoint:c1];
    [helperPath addLineToPoint:c2];
    [helperPath addLineToPoint:pointB];
    [helperPath addLineToPoint:c3];
    [helperPath addLineToPoint:c4];
    [helperPath addLineToPoint:pointC];
    [helperPath addLineToPoint:c5];
    [helperPath addLineToPoint:c6];
    [helperPath addLineToPoint:pointD];
    [helperPath addLineToPoint:c7];
    [helperPath addLineToPoint:c8];
    [helperPath closePath];
    
    CGContextAddPath(ctx, helperPath.CGPath);
    CGFloat dash2[] = {2.0, 2.0};
    CGContextSetLineDash(ctx, 0, dash2, 2);
    CGContextStrokePath(ctx);
}


//ctx字面意思是上下文，你可以理解为一块全局的画布。也就是说，一旦在某个地方改了画布的一些属性，其他任何使用画布的属性的时候都是改了之后的。比如上面在 //1 中把线条样式改成了虚线，那么在下文 //2 中如果不恢复成连续的直线，那么画出来的依然是//1中的虚线样式。

// 在某个point位置画一个点，方便观察运动情况
- (void)drawPoint:(NSArray *)points withContext:(CGContextRef)ctx {
    for (NSValue *pointValue in points) {
        CGPoint point = pointValue.CGPointValue;
        CGContextFillRect(ctx, CGRectMake(point.x - 2, point.y - 2, 4, 4));
    }
}


@end
