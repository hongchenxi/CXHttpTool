//
//  CXHttpTool.m
//  AFN和MBProgressHUD组合封装
//
//  Created by cx on 16/1/3.
//  Copyright © 2016年 cx. All rights reserved.
//

#import "CXHttpTool.h"
#import <AFNetworkReachabilityManager.h>
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import <objc/runtime.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <UIImage+GIF.h>
#define k_window [[UIApplication sharedApplication].windows lastObject]

@implementation CXHttpTool

+ (BOOL)hasNetworkReachability{
    
    return flag;
}

+ (void)get:(NSString *)url params:(NSDictionary *)params graceTime:(NetWorkRequestGraceTimeType)graceTime success:(void (^) (id responseObj))success failure:(void (^) (NSError *error))failure{
    
        AFHTTPSessionManager *manager = [self getManager];
        MBProgressHUD *hud = [self hud:graceTime];
        [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            hud.taskInProgress = NO;
            [hud hide:YES];
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            hud.taskInProgress = NO;
            [hud hide:YES];
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params graceTime:(NetWorkRequestGraceTimeType)graceTime success:(void (^) (id responseObj))success failure:(void (^) (NSError *error))failure{
    
        AFHTTPSessionManager *manager = [self getManager];
        MBProgressHUD *hud = [self hud:graceTime];
        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            hud.taskInProgress = NO;
            [hud hide:YES];
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            hud.taskInProgress = NO;
            [hud hide:YES];
            if (failure) {
                failure(error);
            }
        }];
}


+ (MBProgressHUD *)hud:(NetWorkRequestGraceTimeType)graceTimeType{
    NSTimeInterval graceTime = 0;
    switch (graceTimeType) {
        case NetWorkRequestGraceTimeTypeNone:
            return nil;
            break;
        case NetWorkRequestGraceTimeTypeNomal:
            graceTime = 0.5;
            break;
        case NetWorkRequestGraceTimeTypeLong:
            graceTime = 1.0;
            break;
        case NetWorkRequestGraceTimeTypeShort:
            graceTime = 0.1;
            break;
        case NetWorkRequestGraceTimeTypeAlways:
            graceTime = 0;
            break;
        default:
            break;
    }
    MBProgressHUD *hud = [self hud];
    [k_window addSubview:hud];
    hud.graceTime = graceTime;
    
    hud.taskInProgress = YES;
    [hud show:YES];
    return hud;

}

+ (MBProgressHUD *)hud{
    MBProgressHUD *hud = objc_getAssociatedObject(self, _cmd);
    if (!hud) {
        UIImage *image = [UIImage sd_animatedGIFNamed:@"Loading-225px-W"];
        UIImageView *gifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        hud = [[MBProgressHUD alloc]initWithWindow:k_window];
        gifImageView.image = image;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = gifImageView;
        hud.labelText = @"加载中...";
        objc_setAssociatedObject(self, _cmd, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        NSLog(@"创建了一个hud");
    }
    return hud;
}

+ (AFHTTPSessionManager *)getManager{
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
#pragma mark - 这里是apix.cn的请求头
    [manager.requestSerializer setValue:@"ba4d0c3848f549b87825864a217f92dc" forHTTPHeaderField:@"apix-key"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    return manager;
}

static BOOL flag;
+ (void)openNetworkCheckReachability{
    
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                flag = YES;
                break;
                
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                flag = NO;
                break;

            default:
                flag = NO;
                break;
        }
    }];
}

+ (void)load{
    [self openNetworkCheckReachability];
}

@end
