//
//  AppDelegate.m
//  SLMap
//
//  Created by yuangong on 2/9/15.
//  Copyright (c) 2015 daDreams. All rights reserved.
//

#import "AppDelegate.h"

#import "BMapKit.h"

@interface AppDelegate ()<BMKGeneralDelegate>
{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"tNQgVPUpsTRb1RBr4FPKSlla"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    return YES;
}

- (void)onGetPermissionState:(int)iError
{
    switch (iError) {
        case 0:
            NSLog(@"pass");
            break;
        case -200:{
            NSLog(@"服务端数据错误，无法解析服务端返回数据");
        }
            break;
            case -300:
            NSLog(@"无法建立与服务端的连接");
            break;
        default:
            NSLog(@"%zd",iError);
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
