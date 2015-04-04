//
//  SLOverlayView.m
//  SLMap
//
//  Created by LiuShulong on 4/2/15.
//  Copyright (c) 2015 daDreams. All rights reserved.
//

#import "SLOverlayView.h"

#import "BMapKit.h"

@implementation SLOverlayView

- (void)dealloc
{
    [self sendDeallocBroadcast];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOverlays:(NSArray *)overlays
{
    if (self = [super initWithOverlay:[overlays objectAtIndex:0]]) {
        self.overlays = overlays;
    }
    return self;
}


- (void)sendDeallocBroadcast
{
    // 获取通知中心，单例!
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"overLay" object:self.overlay];
    
}

- (void)drawMapRect:(BMKMapRect)mapRect zoomScale:(BMKZoomScale)zoomScale inContext:(CGContextRef)context{
    if ([self.overlay isKindOfClass:[BMKPolygon class]]) {
        
        if (self.myLayer) {
            [self.myLayer removeFromSuperlayer];
        }
        
        self.myLayer = [[CAShapeLayer alloc] init];
        
            //判断是奇数和偶数
        BOOL isEven = self.overlays.count%2 == 0;
        
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
        
        CGRect frame = CGRectMake(-width * 2, -height * 2, width * 4, height * 4);
        
        int startIndex = 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
        BMKPolygon *polygon = nil;
        if (!isEven) {
            polygon = [self.overlays objectAtIndex:0];
                //移动到某一点
            BMKMapPoint mapPoint = polygon.points[0];
            CGPoint firstPoint = [self pointForMapPoint:mapPoint];
            [path moveToPoint:firstPoint];
                
            for (NSInteger i = 0; i < polygon.pointCount; i++) {
                BMKMapPoint mapPoint = polygon.points[i];
                CGPoint point = [self pointForMapPoint:mapPoint];
                [path addLineToPoint:point];
            }
                
            //闭合路径
            [path addLineToPoint:firstPoint];
                
            startIndex = 1;
        } else {
            startIndex = 0;
        }
            
        for (int i = startIndex; i < self.overlays.count; i++) {
            @autoreleasepool {
                    
                UIBezierPath *subPath = [UIBezierPath bezierPathWithRect:frame];
                    //移动到某一点
                polygon = ((BMKPolygon *)[self.overlays objectAtIndex:i]);
                BMKMapPoint mapPoint =  polygon.points[0];
                CGPoint firstPoint = [self pointForMapPoint:mapPoint];
                [subPath moveToPoint:firstPoint];
                for (NSInteger i = 0; i < polygon.pointCount; i++) {
                    BMKMapPoint mapPoint =polygon.points[i];
                    CGPoint point = [self pointForMapPoint:mapPoint];
                    [subPath addLineToPoint:point];
                }
                    
                [subPath addLineToPoint:firstPoint];
                [subPath closePath];
                [path appendPath:subPath];
        }
    }
    path.usesEvenOddFillRule = NO;
    _myLayer.path = path.CGPath;
    _myLayer.fillRule = kCAFillRuleEvenOdd;
    _myLayer.lineWidth = self.lineWidth;
    _myLayer.fillColor = [self.fillColor colorWithAlphaComponent:0.3].CGColor;
    _myLayer.opacity = 1;
    _myLayer.strokeColor = self.strokeColor.CGColor;
    [self.layer addSublayer:self.myLayer];
    }
}



@end
