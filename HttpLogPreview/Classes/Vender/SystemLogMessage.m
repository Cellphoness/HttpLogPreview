//
//  SystemLogMessage.m
//  DragonPassPad
//
//  Created by 冯俊希 on 2018/8/20.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "SystemLogMessage.h"
#import <sys/utsname.h>
#import <mach-o/ldsyms.h>

@implementation SystemLogMessage

//+(NSString *)getDSYM
//{
//    const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
//    for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx) {
//        if (((const struct load_command *)command)->cmd == LC_UUID) {
//            command += sizeof(struct load_command);
//            return [NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
//                    command[0], command[1], command[2], command[3],
//                    command[4], command[5],
//                    command[6], command[7],
//                    command[8], command[9],
//                    command[10], command[11], command[12], command[13], command[14], command[15]];
//        } else {
//            command += ((const struct load_command *)command)->cmdsize;
//        }
//    }
//    return @"unknown";
//}

+(instancetype)LogWithMessage:(NSString *)message
{
    SystemLogMessage *ins = [SystemLogMessage new];
    ins.messageText = [self removeHtmlWithString:message];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time= [date timeIntervalSince1970]*1000;
    ins.timeInterval = time;
    return ins;
}

+(NSString *)removeHtmlWithString:(NSString *)htmlString{
    NSRegularExpression * regularExpretion= [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    htmlString = [regularExpretion stringByReplacingMatchesInString:htmlString options:NSMatchingReportProgress range:NSMakeRange(0, htmlString.length) withTemplate:@""];
    return htmlString;
}

@end
