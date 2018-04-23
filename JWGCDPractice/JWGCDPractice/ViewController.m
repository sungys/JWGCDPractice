//
//  ViewController.m
//  JWGCDPractice
//
//  Created by sunjiawen on 2018/4/23.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.1 只要是同步的，无论是串行还是并行都会在当前线程中按照串行方式执行；
    //    [self syncSerialQueue];
    //
    //    [self syncConcurrentQueue];
    
    // 0.2 异步 + 串行： -开启新的线程，同一个串行队列共用一个线程； -按照队列添加顺序执行
    //    [self asyncSerialQueue];
    
    // 0.3 异步 + 并行： -开启新的线程，并发执行；常用这一类
    //    [self asyncConcurrentQueue];
    
    // 0.4 线程通信，从子线程跳转至主线程
    //    [self asyncGlobalQueueSignMainQueue];
    
    // 0.5 同步 + 主队列 会死锁
    [self barrierAsync];
}


/**
 同步 + 串行
 */
- (void)syncSerialQueue {
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start------currentthreadName：%@", [NSThread currentThread]);
        // 总结：
        // 1.在当前线程中进行-不会开启新的线程
        // 2.按照代码顺序串行执行任务
        
        dispatch_queue_t serialQueue = dispatch_queue_create("com.sjw.serial_queue_practice", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t serialQueue2 = dispatch_queue_create("com.sjw.serial_queue_practice2", DISPATCH_QUEUE_SERIAL);
        // 同步 + 串行
        dispatch_sync(serialQueue, ^{
            NSLog(@"……………………syncSerialQueue 1----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(serialQueue, ^{
            NSLog(@"……………………syncSerialQueue 2----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(serialQueue, ^{
            NSLog(@"……………………syncSerialQueue 3----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(serialQueue2, ^{
            NSLog(@"……………………syncSerialQueue2 1----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(serialQueue2, ^{
            NSLog(@"……………………syncSerialQueue2 2----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(serialQueue2, ^{
            NSLog(@"……………………syncSerialQueue2 3----threadName：%@", [NSThread currentThread]);
        });
        
    });
}

/**
 同步 + 并行
 */
- (void)syncConcurrentQueue {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start------currentthreadName：%@", [NSThread currentThread]);
        // 总结：
        // 1.在当前线程中（不一定是主线程）进行-不会开启新的线程
        // 2.按照代码顺序串行执行任务
        
        dispatch_queue_t concurrentQueue1 = dispatch_queue_create("com.sjw.concurrent_queue_practice1", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_t concurrentQueue2 = dispatch_queue_create("com.sjw.concurrent_queue_practice2", DISPATCH_QUEUE_CONCURRENT);
        // 同步 + 并行
        dispatch_sync(concurrentQueue1, ^{
            NSLog(@"……………………concurrentQueue1 1----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(concurrentQueue1, ^{
            NSLog(@"……………………concurrentQueue1 2----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(concurrentQueue1, ^{
            NSLog(@"……………………concurrentQueue1 3----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(concurrentQueue2, ^{
            NSLog(@"……………………concurrentQueue2 1----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(concurrentQueue2, ^{
            NSLog(@"……………………concurrentQueue2 2----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_sync(concurrentQueue2, ^{
            NSLog(@"……………………concurrentQueue2 3----threadName：%@", [NSThread currentThread]);
        });
        
    });
    
}

/**
 异步 + 串行
 */
- (void)asyncSerialQueue {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start------currentthreadName：%@", [NSThread currentThread]);
        // 总结：
        // 1.开启新的线程，同一个串行队列共用一个线程
        // 2.按照队列添加顺序执行
        
        dispatch_queue_t serialQueue = dispatch_queue_create("com.sjw.serial_queue_practice", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t serialQueue2 = dispatch_queue_create("com.sjw.serial_queue_practice2", DISPATCH_QUEUE_SERIAL);
        // 异步 + 串行
        dispatch_async(serialQueue, ^{
            NSLog(@"……………………syncSerialQueue 1----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(serialQueue, ^{
            NSLog(@"……………………syncSerialQueue 2----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(serialQueue, ^{
            NSLog(@"……………………syncSerialQueue 3----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(serialQueue2, ^{
            NSLog(@"……………………syncSerialQueue2 1----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(serialQueue2, ^{
            NSLog(@"……………………syncSerialQueue2 2----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(serialQueue2, ^{
            NSLog(@"……………………syncSerialQueue2 3----threadName：%@", [NSThread currentThread]);
        });
        
    });
}

/**
 异步 + 并行
 */
- (void)asyncConcurrentQueue {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start------currentthreadName：%@", [NSThread currentThread]);
        // 总结：
        // 1.会开启多个新线程进行并发任务
        // 2.系统底层处理并发顺序，不可控
        
        dispatch_queue_t concurrentQueue1 = dispatch_queue_create("com.sjw.concurrent_queue_practice1", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_t concurrentQueue2 = dispatch_queue_create("com.sjw.concurrent_queue_practice2", DISPATCH_QUEUE_CONCURRENT);
        // 同步 + 并行
        dispatch_async(concurrentQueue1, ^{
            NSLog(@"……………………concurrentQueue1 1----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(concurrentQueue1, ^{
            NSLog(@"……………………concurrentQueue1 2----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(concurrentQueue1, ^{
            NSLog(@"……………………concurrentQueue1 3----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(concurrentQueue2, ^{
            NSLog(@"……………………concurrentQueue2 1----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(concurrentQueue2, ^{
            NSLog(@"……………………concurrentQueue2 2----threadName：%@", [NSThread currentThread]);
        });
        
        dispatch_async(concurrentQueue2, ^{
            NSLog(@"……………………concurrentQueue2 3----threadName：%@", [NSThread currentThread]);
        });
        
    });
}


/**
 线程通信
 */
- (void)asyncGlobalQueueSignMainQueue {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"子线程开始工作 thread：%@",[NSThread currentThread]);
        sleep(3);
        NSLog(@"子线程执行完毕 thread：%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"主线程执行 thread：%@",[NSThread currentThread]);
        });
    });
}


/**
 同步+主队列：会死锁！！！
 */
- (void)syncMainQueue {
    NSLog(@"____start-----");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"不会执行滴");
    });
    NSLog(@"____end-----");
    
}


/**
 栅栏函数：不能用全局Global队列，必须创建并行队列
 */
- (void)barrierAsync {
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0); // 不能用全局Global队列
    
    dispatch_queue_t queue = dispatch_queue_create("com.sjw.barrier_practice", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"before barrier 1 thread:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"before barrier 2 thread:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"before barrier 3 thread:%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"dispatch_barrier_async start thread:%@",[NSThread currentThread]);
        sleep(2);
        NSLog(@"dispatch_barrier_async end");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"after barrier 1 thread:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"after barrier 2 thread:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"after barrier 3 thread:%@",[NSThread currentThread]);
    });
    
    for (int i = 0; i < 99; i++) {
        NSLog(@"current task i:%d",i);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
