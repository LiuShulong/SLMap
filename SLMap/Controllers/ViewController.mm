//
//  ViewController.m
//  SLMap
//
//  Created by yuangong on 2/9/15.
//  Copyright (c) 2015 daDreams. All rights reserved.
//

#import "ViewController.h"
#import "BMapKit.h"
#import "SLOverlayView.h"
#import "SLCanvasView.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<SLCanvasViewDelegate,BMKMapViewDelegate>
{
    BOOL _hasOverLay;//是否有覆盖物
    SLOverlayView *_overlayPathView;
}

@property (strong, nonatomic) BMKMapView *mapView;

///从点击到touchEnd所有得点
@property (nonatomic, strong) NSMutableArray *coordinates;

///coordinates的集合
@property (nonatomic, strong) NSMutableArray *polygonPoints;

@property (nonatomic,strong) CALayer * maskLayer;

///画板
@property (nonatomic,strong)  SLCanvasView *canvasView;

@property (nonatomic,strong)   SLOverlayView *overlayPathView;

///覆盖物
@property (nonatomic,strong) BMKPolygon *polygon;

///是否正在绘制
@property (nonatomic,assign) BOOL isDrawingPolygon;

//画圈的点的polygon数组
@property (nonatomic,strong) NSMutableArray *polygonArray;


///当前限定区域覆盖物数组
@property (nonatomic,assign) NSUInteger currentPolygonCount;

@end

@implementation ViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self configureFrames];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化地图数据

- (void)configureUI
{
    [self.view addSubview:self.mapView];
}

- (void)configureFrames
{
    self.mapView.frame = CGRectMake(0, 0,
                                    CGRectGetWidth(self.view.bounds),
                                    CGRectGetHeight(self.view.bounds) - 50);
}

#pragma mark - notification

- (void)addOberser
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"overLay" object:nil];
}

// 这个参数是通知中心发送的通知
- (void)receiveNotification:(NSNotification *)noti
{
    ///判断是哪一个
    _currentPolygonCount--;
    if (_currentPolygonCount == 0) {
        [self.view.layer addSublayer:self.maskLayer];
    }
    
}

#pragma mark - 绘制相关

- (void)drawCircle{
    
    [self.polygonArray removeAllObjects];
    
    NSUInteger count = self.polygonPoints.count;
    
    for (int i = 0; i < count; i++) {
        
        NSArray *cos = self.polygonPoints[i];
        NSUInteger count = cos.count;
        CLLocationCoordinate2D arr[count];
        for (int j = 0; j < count; j++) {
            NSValue *value = cos[j];
            CLLocationCoordinate2D point;
            [value getValue:&point];
            arr[j] = point;
        }
        
        BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates: arr count:count];
        [self.polygonArray addObject:polygon];
        
    }
    
    [self.polygonPoints removeAllObjects];
    
    if (self.polygonArray.count > 0) {
        [self.mapView addOverlay:_polygonArray[0]];
    }

    self.isDrawingPolygon = NO;
    self.canvasView.image = nil;
    [self.canvasView removeFromSuperview];
    self.canvasView = nil;


}

//清除绘制状态
- (void)clearDrawStatus
{
    
    _hasOverLay = NO;
        
    [self.mapView removeOverlays:self.polygonArray];
    [self.polygonArray removeAllObjects];
    
    //清除蒙层
    [self.maskLayer removeFromSuperlayer];
    
    self.isDrawingPolygon = NO;
    self.canvasView.image = nil;
    [self.canvasView removeFromSuperview];
    self.canvasView = nil;
    
}

//设置为绘制状态
- (void)becomeDrawDrawStatus
{
    self.isDrawingPolygon = YES;
    
    [self.coordinates removeAllObjects];
    
    [self.view addSubview:self.canvasView];
    [self.mapView removeOverlays:self.polygonArray];
    [self.polygonArray removeAllObjects];
    
    _hasOverLay = NO;
    [self.maskLayer removeFromSuperlayer];
    
}


/*
  添加移动的点
 **/
- (void)addTouchPoints:(UITouch *)touch{
    CGPoint location = [touch locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:location
                                              toCoordinateFromView:self.mapView];
    NSValue *value = [NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)];
    [self.coordinates addObject:value];

}


#pragma mark - click事件

///绘制和清除按钮点击
- (IBAction)operationButtonClick:(UIButton *)sender {
    
    NSString *title = sender.currentTitle;
    
    if ([title isEqualToString:@"清除"]) {
        [sender setTitle:@"绘制" forState:UIControlStateNormal];
        [self clearDrawStatus];
    } else {
        [self becomeDrawDrawStatus];
        [sender setTitle:@"清除" forState:UIControlStateNormal];
    }
    
}


///应用按钮点击
- (IBAction)applyButtonClick:(id)sender {
    
    if (self.mapView.overlays.count > 0) {
        return;
    }
    [self drawCircle];
}


#pragma mark - BMKMapViewDelegate

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]]) {
        SLOverlayView * overlayPathView = nil;
        if (self.maskLayer) {
            [self.maskLayer removeFromSuperlayer];
        }
        overlayPathView = [[SLOverlayView alloc] initWithOverlays:self.polygonArray];
        
        overlayPathView.fillColor = [UIColor blackColor];
        overlayPathView.strokeColor = [UIColor whiteColor];
        overlayPathView.lineWidth = 6;        
        _currentPolygonCount++;
        
        return overlayPathView;
    }
    return nil;

}

#pragma mark - SLCanvasViewDelegate

- (void)touchesBegan:(UITouch*)touch
{
    self.coordinates = [NSMutableArray array];
    [self addTouchPoints:touch];
}

- (void)touchesMoved:(UITouch*)touch
{
    
    [self addTouchPoints:touch];
}

- (void)touchesEnded:(UITouch*)touch
{
    [self addTouchPoints:touch];
    
    if (self.coordinates.count > 3) {
        //        [self drawCircle];
        
        [self.polygonPoints addObject:_coordinates];
    } else {///点数太少，恢复初始状态
        //        [self clearDrawStatus];
    }
    
    
}



#pragma mark get && set

- (SLCanvasView *)canvasView
{
    if (_canvasView == nil) {
        _canvasView = [[SLCanvasView alloc] initWithFrame:self.mapView.bounds];
        _canvasView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _canvasView.userInteractionEnabled = YES;
        [_canvasView setDelegate:self];
    }
    return _canvasView;
}

- (CALayer *)maskLayer
{
    if (_maskLayer == nil) {
        _maskLayer = [[CALayer alloc] init];
        _maskLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
        _maskLayer.bounds = CGRectMake(0, 0, 10000, 10000);
    }
    return _maskLayer;
}

- (NSMutableArray *)coordinates
{
    if (_coordinates == nil) {
        _coordinates = [NSMutableArray array];
    }
    return _coordinates;
}

- (NSMutableArray *)polygonArray
{
    if (_polygonArray == nil) {
        _polygonArray = [NSMutableArray array];
    }
    return _polygonArray;
}

- (NSMutableArray *)polygonPoints
{
    if (_polygonPoints == nil) {
        _polygonPoints = [NSMutableArray array];
    }
    return _polygonPoints;
}

- (BMKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.delegate = self;
        _mapView.rotateEnabled = NO;
        _mapView.overlookEnabled = NO;
    }
    return _mapView;
}

@end
