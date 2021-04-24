//
//  LogPreviewManager.swift
//  gac_nio_app_ios
//
//  Created by 冯俊希 on 2019/6/6.
//  Copyright © 2021 Cellphoness All rights reserved.
//

public class LogPreviewManager {

    private static let shared = LogPreviewManager()

    public static func `default`() -> LogPreviewManager {
        return shared
    }

    //属性锁的Swift封装
//    @synchronized (<#token#>) {
//    <#statements#>
//    }

    static private let queue = DispatchQueue(label: "com.custom.globalLogger.lock.property", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem)
    static private var _myTempArray = [Any]()
    static var tempArray: [Any] {
        get {
            var result = [Any]()
            LockKit.with(queue: queue) {
                result = _myTempArray
            }
            return result
        }
        set {
            LockKit.with(queue: queue) {
                _myTempArray = newValue
            }
        }
    }

    public static func loggerBrowserSingleLine(_ log: Any, shouldPrint: Bool = true) {
        var logg: String?
        if let str = log as? String {
            logg = str
        } else {
            let obj = log as AnyObject
            logg = obj.description
        }
        if let logg = logg {
            NotificationCenter.default.post(name: HttpLogDefine.Notification.httpLog, object: logg)
        }
        if shouldPrint {
            print(log)
        }
    }

    public static func loggerBrowserMultibleLines(_ log: Any, lines: Int = 3, shouldPrint: Bool = true) {
        //考虑多线程打印
        tempArray.append(log)
        if self.tempArray.count != lines {
        } else {
            let printResult = tempArray.map { ($0 as? String) ?? "\($0)" }.joined(separator: "\n")
            tempArray.reversed().forEach { (ins) in
                var logg: String?
                if let str = ins as? String {
                    logg = str
                } else {
                    let obj = ins as AnyObject
                    logg = obj.description
                }
//                else {
//                    logg = "\(ins)"
//                }
                if let logg = logg {
                    NotificationCenter.default.post(name: HttpLogDefine.Notification.httpLog, object: logg)
                }
            }
            tempArray.removeAll()
            if shouldPrint {
                print(printResult)
            }
        }
    }
}
