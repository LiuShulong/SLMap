//
//  SLOverlayView.h
//  SLMap
//
//  Created by LiuShulong on 4/2/15.
//  Copyright (c) 2015 daDreams. All rights reserved.
//

#import "BMapKit.h"

@interface SLOverlayView : BMKOverlayView

/// 填充颜色
@property (retain) UIColor *fillColor;
/// 画笔颜色
@property (retain) UIColor *strokeColor;
/// 画笔宽度，默认为0
@property CGFloat lineWidth;

@property (nonatomic,strong)  CAShapeLayer *myLayer;

@property (nonatomic,strong) UIBezierPath *path;

///是否发送销毁通知
@property (nonatomic,assign) BOOL isSendDeallocNoti;

@property (nonatomic,strong) NSArray *overlays;


- (id)initWithOverlays:(NSArray *)overlays;



@end
