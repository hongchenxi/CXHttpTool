//
//  CXHttpTool.h
//  AFN和MBProgressHUD组合封装
//
//  Created by cx on 16/1/3.
//  Copyright © 2016年 cx. All rights reserved.
//

#import <Foundation/Foundation.h>

//若干秒后网络数据还没返回则出现提示框
typedef NS_ENUM(NSUInteger, NetWorkRequestGraceTimeType){
    NetWorkRequestGraceTimeTypeNomal, //0.5s
    NetWorkRequestGraceTimeTypeLong,  //1.0s
    NetWorkRequestGraceTimeTypeShort, //0.1s
    NetWorkRequestGraceTimeTypeNone, //没有提示框
    NetWorkRequestGraceTimeTypeAlways, //总是有提示框
};

@interface CXHttpTool : NSObject

+ (BOOL)hasNetworkReachability;

+ (void)get:(NSString *)url params:(NSDictionary *)params graceTime:(NetWorkRequestGraceTimeType)graceTime success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params graceTime:(NetWorkRequestGraceTimeType)graceTime success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

@end
