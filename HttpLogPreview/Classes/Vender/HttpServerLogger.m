//
//  HttpServerLogger.m
//  DragonPassPad
//
//  Created by 冯俊希 on 2018/8/20.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "HttpServerLogger.h"

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>

#import "SystemLogMessage.h"

#define kMinRefreshDelay 500  // In milliseconds
@interface HttpServerLogger ()
@property (nonatomic,strong) GCDWebServer* webServer;
@property (nonatomic,strong) NSMutableArray *msgArray;
@end
@implementation HttpServerLogger

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static HttpServerLogger *shared;
    dispatch_once(&onceToken, ^{
        shared = [HttpServerLogger new];
        shared.msgArray = @[].mutableCopy;
        shared.isLogging = false;
        [GCDWebServer setLogLevel:3];
    });
    return shared;
}

- (GCDWebServer *)webServer {
    if (!_webServer) {
        _webServer = [[GCDWebServer alloc] init];
        __weak __typeof__(self) weakSelf = self;
        // Add a handler to respond to GET requests on any URL
        [_webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                      return [weakSelf createResponseBody:request];
                                      
                                      
                                  }];
//        NSLog(@"Visit %@ in your web browser", _webServer.serverURL);
    }
    return _webServer;
}
- (void)startServer:(NSUInteger)port {
//#if DEBUG
    // Use convenience method that runs server on port 8080
    // until SIGINT (Ctrl-C in Terminal) or SIGTERM is received
    NSLog(@"Visit http://localhost:%ld in your web browser", port == nil ? 8080 : port);
//    [self redirectSTD]; //NSLog重定向
    [self redirectPrint]; //接受swift的loggerPrint()
    if (port == nil) {
        [self.webServer startWithPort:8080 bonjourName:nil];
    } else {
        [self.webServer startWithPort:port bonjourName:nil];
    }
    self.isLogging = YES;
//#else
//
//#endif
}

- (void)stopServer {
    [_webServer stop];
    _webServer = nil;
    [self stopRedirect];
}


//当浏览器请求的时候,返回一个由日志信息组装成的html返回给浏览器
- (GCDWebServerDataResponse *)createResponseBody :(GCDWebServerRequest* )request{
    GCDWebServerDataResponse *response = nil;
    
    NSString* path = request.path;
    NSDictionary* query = request.query;
    //NSLog(@"path = %@,query = %@",path,query);
    NSMutableString* string;
    if ([path isEqualToString:@"/"]) {
        string = [[NSMutableString alloc] init];
        [string appendString:@"<!DOCTYPE html><html lang=\"en\">"];
        [string appendString:@"<head><meta charset=\"utf-8\"></head>"];
        [string appendFormat:@"<title>%s[%i]</title>", getprogname(), getpid()];
        [string appendString:@"<style>\
         body {\n\
         margin: 0px;\n\
         font-family: Courier, monospace;\n\
         font-size: 0.8em;\n\
         }\n\
         table {\n\
         width: 100%;\n\
         border-collapse: collapse;\n\
         }\n\
         tr {\n\
         vertical-align: top;\n\
         }\n\
         tr:nth-child(odd) {\n\
         background-color: #eeeeee;\n\
         }\n\
         td {\n\
         padding: 2px 10px;\n\
         }\n\
         #footer {\n\
         margin: 20px 0px;\n\
         color: darkgray;\n\
         }\n\
         .error {\n\
         color: red;\n\
         font-weight: bold;\n\
         }\n\
         .btn {\n\
         margin-right: 10px;\n\
         }\n\
         .bottom {\n\
         margin-top: 20px;\n\
         text-align: center;\n\
         }\n\
          .filter {\n\
             text-align: left;\n\
             margin: 0px 10px;\n\
             width: 120px;\n\
          }\n\
          #content {\n\
             display: flex;\n\
             flex-direction: column;\n\
          }\n\
         </style>"];
        [string appendFormat:@"<script type=\"text/javascript\">\n\
         var t = null;\n\
         var refreshDelay = %i;\n\
         var footerElement = null;\n\
         var contentElement = null;\n\
         function updateTimestamp() {\n\
         var now = new Date();\n\
         footerElement.innerHTML = \"Last updated on \" + now.toLocaleDateString() + \" \" + now.toLocaleTimeString();\n\
         }\n\
         function filterFunction() {\n\
             var x = document.getElementById(\"fname\");\n\
             var getValue = x.value;\n\
             var table = document.getElementById(\"content\");\n\
               for (let index = 0; index < table.childElementCount; index++) {\n\
                    const ele = table.children.item(index);\n\
                    const txt = ele.textContent;\n\
                    if (txt.indexOf(getValue) != -1) {\n\
                        ele.style.display = \"block\";\n\
                    } else {\n\
                        ele.style.display = \"none\";\n\
                    }\n\
                }\n\
         }\n\
         function reverseHandle() {\n\
              var reverseBtn = document.getElementById('reverseBtn');\n\
              var table = document.getElementById('content');\n\
              if (table.style['flex-direction'] == 'column-reverse') {\n\
                  reverseBtn.innerHTML = 'Reverse';\n\
                  table.style['flex-direction'] = 'column';\n\
              } else {\n\
                  reverseBtn.innerHTML = 'Order';\n\
                  table.style['flex-direction'] = 'column-reverse';\n\
              }\n\
         }\n\
         function refresh() {\n\
         var timeElement = document.getElementById(\"maxTime\");\n\
         var maxTime = timeElement.getAttribute(\"data-value\");\n\
         timeElement.parentNode.removeChild(timeElement);\n\
         \n\
         var xmlhttp = new XMLHttpRequest();\n\
         xmlhttp.onreadystatechange = function() {\n\
         if (xmlhttp.readyState == 4) {\n\
         if (xmlhttp.status == 200) {\n\
         contentElement = document.getElementById(\"content\");\n\
         contentElement.innerHTML = contentElement.innerHTML + xmlhttp.responseText;\n\
         updateTimestamp();\n\
         t = setTimeout(refresh, refreshDelay);\n\
         } else {\n\
         footerElement.innerHTML = \"<span class=\\\"error\\\">Connection failed! Reload page to try again.</span>\";\n\
         }\n\
         }\n\
         }\n\
         xmlhttp.open(\"GET\", \"/log?after=\" + maxTime, true);\n\
         xmlhttp.send();\n\
         }\n\
         window.onload = function() {\n\
         footerElement = document.getElementById(\"footer\");\n\
         updateTimestamp();\n\
         t = setTimeout(refresh, refreshDelay);\n\
         }\n\
         function stopHandle() {\n\
         var stopBtn = document.getElementById(\"stopBtn\");\n\
         if (t) { \n\
         stopBtn.innerHTML = \"Start Timer\";\n\
         clearTimeout(t)\n\
         t = null;\n\
         } else { \n\
         stopBtn.innerHTML = \"Stop Timer\";\n\
         t = setTimeout(refresh, refreshDelay);\n\
         } \n\
         }\n\
         function clearHandle() {\n\
         var timeElement = document.getElementById(\"maxTime\");\n\
         var maxTime = timeElement.getAttribute(\"data-value\");\n\
         document.getElementById(\"content\");\n\
         contentElement.innerHTML = \"<tr id=\\\"maxTime\\\" data-value=\" + maxTime + \"></tr>\";\n\
         }\n\
         </script>", kMinRefreshDelay];
        [string appendString:@"</head>"];
        [string appendString:@"<body>"];
        [string appendString:@"<div class=\"bottom\">"];
        [string appendString:@"<button class=\"btn\" onClick=\"clearHandle()\">Clear Console</button>"];
        [string appendString:@"<button id=\"stopBtn\" onClick=\"stopHandle()\">Stop Timer</button>"];
        [string appendString:@"<input id=\"fname\" class=\"filter\" placeholder=\"Filter For Less\"  onchange=\"filterFunction()\"></input>"];
        [string appendString:@"<button id=\"reverseBtn\" onclick=\"reverseHandle()\" class=\"btn\">Reverse</button>"];
        [string appendString:@"<div id=\"footer\"></div>"];
        [string appendString:@"</div>"];
        [string appendString:@"<table><tbody id=\"content\">"];
        [self _appendLogRecordsToString:string afterAbsoluteTime:0.0];
        
        [string appendString:@"</tbody></table>"];
        [string appendString:@"</body>"];
        [string appendString:@"</html>"];
        
        
    }
    else if ([path isEqualToString:@"/log"] && query[@"after"]) {
        string = [[NSMutableString alloc] init];
        double time = [query[@"after"] doubleValue];
        [self _appendLogRecordsToString:string afterAbsoluteTime:time];
        
    }
    else {
        string = [@" <html><body><p>无数据</p></body></html>" mutableCopy];
    }
    if (string == nil) {
        string = [@"" mutableCopy];
    }
    response = [GCDWebServerDataResponse responseWithHTML:string];
    return response;
}

- (void)_appendLogRecordsToString:(NSMutableString*)string afterAbsoluteTime:(double)time {
    __block double maxTime = time;
    
    NSArray *newArray = [[[NSArray arrayWithArray:self.msgArray] reverseObjectEnumerator] allObjects];
    NSArray *filteredLogMessages = [newArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SystemLogMessage *logMessage, NSDictionary *bindings) {
        if (logMessage.timeInterval > time) {
            return  YES;
        }
        return NO;
    }]];
    [filteredLogMessages enumerateObjectsUsingBlock:^(SystemLogMessage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const char* style = "color: dimgray;";
        NSString* formattedMessage = [self displayedTextForLogMessage:obj.messageText];
        [string appendFormat:@"<tr style=\"%s\">%@</tr>", style, formattedMessage];
        if (obj.timeInterval > maxTime) {
            maxTime = obj.timeInterval ;
        }
    }];
    [string appendFormat:@"<tr id=\"maxTime\" data-value=\"%f\"></tr>", maxTime];
}

- (NSString *)displayedTextForLogMessage:(NSString *)msg{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"<td>%@</td>", msg];
    //[string appendFormat:@"<td>%@</td> <td>%@</td> <td>%@</td>",[SystemLogMessage logTimeStringFromDate:msg.date ],msg.sender, msg.messageText];
    return string;
}

- (void)redirectSTD {
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading];
    int pipeFileHandle = [[pipe fileHandleForWriting] fileDescriptor];
    dup2(pipeFileHandle, STDERR_FILENO) ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle] ;
    [pipeReadHandle readInBackgroundAndNotify];
}

- (void)redirectPrint {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlerSwiftLoggerPrintHandle:)
                                                 name:@"SwiftLoggerPrintNotification"
                                               object:nil] ;
}

-(void)stopRedirect
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.isLogging = NO;
}

- (void)handlerSwiftLoggerPrintHandle:(NSNotification *)nf {
    NSString *string = nf.object;
    if (string && [string length]) {
        [self.msgArray addObject:[SystemLogMessage LogWithMessage:string]];
    }
}

- (void)redirectNotificationHandle:(NSNotification *)nf{
    NSData *data = [[nf userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    if (str && [str length]) {
        [self.msgArray addObject:[SystemLogMessage LogWithMessage:str]];
    }
    [[nf object] readInBackgroundAndNotify];
}

@end
