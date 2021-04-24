//
//  LockKit.swift
//  gac_nio_app_ios
//
//  Created by 冯俊希 on 2019/9/3.
//  Copyright © 2019 HYCAN合创. All rights reserved.
//

import Foundation

public class LockKit: NSObject {
    //swiftlint:disable identifier_name
    public static func with(mutex: UnsafeMutablePointer<pthread_mutex_t>, f: () -> Void) {
        pthread_mutex_lock(mutex)
        f()
        pthread_mutex_unlock(mutex)
    }
    //swiftlint:disable identifier_name
    public static func with_write(rwlock: UnsafeMutablePointer<pthread_rwlock_t>, f: () -> Void) {
        pthread_rwlock_wrlock(rwlock)
        f()
        pthread_rwlock_unlock(rwlock)
    }
    //swiftlint:disable identifier_name
    public static func with(queue: DispatchQueue, f: @escaping () -> Void) {
        queue.sync(execute: f)
    }
    //swiftlint:disable identifier_name
    public static func with(opQ: OperationQueue, f: @escaping () -> Void) {
        let op = BlockOperation(block: f)
        opQ.addOperation(op)
        op.waitUntilFinished()
    }
    //swiftlint:disable identifier_name
    public static func with(lock: NSLock, f: () -> Void) {
        lock.lock()
        f()
        lock.unlock()
    }
    //swiftlint:disable identifier_name
    public static func with(spinlock: UnsafeMutablePointer<OSSpinLock>, f: () -> Void) {
        OSSpinLockLock(spinlock)
        f()
        OSSpinLockUnlock(spinlock)
    }
}
