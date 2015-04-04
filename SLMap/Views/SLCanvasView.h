//
//  SLCanvasView.h
//  SLMap
//
//  Created by LiuShulong on 3/29/15.
//  Copyright (c) 2015 daDreams. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SLCanvasViewDelegate <NSObject>

- (void)touchesBegan:(UITouch*)touch;
- (void)touchesMoved:(UITouch*)touch;
- (void)touchesEnded:(UITouch*)touch;

@end


/*
 绘图板
 **/
@interface SLCanvasView : UIImageView


@property (nonatomic,assign) CGPoint leftBottom;

@property (nonatomic,assign) CGPoint rightTop;

@property (nonatomic, weak) id<SLCanvasViewDelegate> delegate;


@end
