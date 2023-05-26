//
//  LockQueue.swift
//  gac_nio_app_ios
//
//  Created by 冯俊希 on 2019/9/3.
//  Copyright © 2019 HYCAN合创. All rights reserved.
//

import Foundation

public class LockQueue: NSObject {
   
    public static func with(queue: DispatchQueue, f: @escaping () -> Void) {
        queue.sync(execute: f)
    }

}
