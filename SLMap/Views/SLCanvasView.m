//
//  SLCanvasView.m
//  SLMap
//
//  Created by LiuShulong on 3/29/15.
//  Copyright (c) 2015 daDreams. All rights reserved.
//

#import "SLCanvasView.h"

@interface SLCanvasView ()

@property (nonatomic, assign) CGPoint location;

@end

@implementation SLCanvasView
{
    CGFloat _topY;
    CGFloat _leftX;
    CGFloat _bottomY;
    CGFloat _rightX;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self.delegate touchesBegan:touch];
    self.location = [touch locationInView:self];
    _leftX = self.location.x;
    _topY = self.location.y;
    _bottomY = self.location.y;
    _rightX = self.location.y;
}

- (void)setUpPoint:(CGPoint)point
{
    if (point.x < _leftX) {
        _leftX = point.x;
    }
    
    if (point.x > _rightX) {
        _rightX = point.x;
    }
    
    if (point.y <  _topY) {
        _topY = point.y;
    }
    if (point.y > _bottomY) {
        _bottomY = point.y;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    [self setUpPoint:currentLocation];
    
    [self.delegate touchesMoved:touch];
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blueColor] colorWithAlphaComponent:0.7].CGColor);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.location.x, self.location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.location = currentLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    [self setUpPoint:currentLocation];
    
    self.leftBottom = CGPointMake(_leftX, _bottomY);
    self.rightTop = CGPointMake(_topY, _rightX);
    
    [self.delegate touchesEnded:touch];
    
    self.location = currentLocation;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
