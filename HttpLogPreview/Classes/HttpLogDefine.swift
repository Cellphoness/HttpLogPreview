//
//  HttpLogDefine.swift
//  HttpLogPreview
//
//  Created by 冯俊希 on 2021/4/24.
//

public class HttpLogDefine: NSObject {
    public class Notification: NSObject {
        public static let httpLog = NSNotification.Name.init("SwiftLoggerPrintNotification")
    }

    public class HttpConfig: NSObject {
        public static let port: UInt = 8080
    }
}
