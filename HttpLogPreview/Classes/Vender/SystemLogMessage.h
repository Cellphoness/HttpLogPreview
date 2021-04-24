//
//  SystemLogMessage.h
//  DragonPassPad
//
//  Created by 冯俊希 on 2018/8/20.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemLogMessage : NSObject

+(nonnull NSString *)getDSYM;

+(instancetype _Nonnull)LogWithMessage:(nonnull NSString *)message;

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, copy, nonnull) NSString *messageText;

@end
