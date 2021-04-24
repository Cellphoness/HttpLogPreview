//
//  HttpServerLogger.h
//  DragonPassPad
//
//  Created by 冯俊希 on 2018/8/20.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpServerLogger : NSObject
+ (nonnull instancetype)shared;

/// 打开本机http://{ip}:{port}的日志服务 如果是模拟器ip可以是localhost或者127.0.0.1
/// @param port 端口号
- (void)startServer:(NSUInteger)port;

/// 关闭监听和http服务
- (void)stopServer;

/// 日志工具是否在启动
@property (nonatomic, assign) BOOL isLogging;

/// 打开 NSLog 重定向
- (void)redirectSTD; //重定向 NSLog

@end
