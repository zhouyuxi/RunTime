//
//  NSURL+url.m
//  Runtime
//
//  Created by zhouyuxi on 2017/11/13.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "NSURL+url.h"
#import <objc/runtime.h>

//1.拿到方法名Method(SEL) 相当于一本书的目录
//2.交互方法实现（IMP）相当于一本书目录对应的页面，方法实现的指针

@implementation NSURL (url)

+(void)load
{
    
    // 下钩子 hook
    //拿到Method
//    class_getClassMethod(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>) //拿到类方法
//    class_getInstanceMethod(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>) //拿到实例方法
    Method URLWithString = class_getClassMethod([NSURL class], @selector(URLWithString:));
    Method Zhou_URLWithString = class_getClassMethod([NSURL class], @selector(Zhou_URLWithString:));
    
    //交互IMP
    method_exchangeImplementations(URLWithString, Zhou_URLWithString);
}


//不是递归死循环，IMP已经交换
+(instancetype)Zhou_URLWithString:(NSString *)URLString
{
    NSURL *url = [NSURL Zhou_URLWithString:URLString]; //IMP已经交换
    if (url == nil) {
        NSLog(@"url 为nil");
    }
    
    return url;
    
}

@end
