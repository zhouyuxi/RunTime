//
//  Person.m
//  Runtime
//
//  Created by zhouyuxi on 2017/11/13.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "Person.h"
#import "SpareWheel.h"
#import <objc/runtime.h>

@implementation Person



// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
//    [aCoder encodeObject:_name forKey:@"name"];
//    [aCoder encodeInt:_age forKey:@"age"];
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count); // 指针数组
    NSLog(@"%d",count);
    
    for (int i = 0 ; i < count; i ++) {
        Ivar ivar = ivars[i]; // 指向对应的ivar成员变量
        const char *name = ivar_getName(ivar);
        NSLog(@"name ---%s",name);
        
        NSString *key  = [NSString stringWithUTF8String:name];
        
        NSLog(@"value --- %@",[self valueForKey:key]);
        //归档
        [aCoder encodeObject:[self valueForKey:key] forKey:key];

    }
    
    free(ivars);
}


// 解挡
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
//        _name = [aDecoder decodeObjectForKey:@"name"];
//        _age = [aDecoder decodeIntForKey:@"age"];
        
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count); // 指针数组
        NSLog(@"%d",count);
        
        for (int i = 0 ; i < count; i ++) {
            Ivar ivar  = ivars[i];
            
            const char *name = ivar_getName(ivar);
             NSString *key  = [NSString stringWithUTF8String:name];
            
            //解档
            id value = [aDecoder decodeObjectForKey:key];
            NSLog(@"value --%@",value);
            //设置到属性上面
            [self setValue:value forKey:key];
            
        }
        free(ivars);
    }
    return  self;
    

}

- (void)run
{
    NSLog(@"跑起来了");
}


- (void)testInvocation:(NSString *)str{
    NSLog(@"invocation --- %@",str);
}

//第一点 防止崩溃
// 第二点 API 兼容

#pragma mark 第一步动态方法解析
// 动态给某个类添加方法，当这个类被调用了一个没有实现的的实例方法
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//    NSString *methodName = NSStringFromSelector(sel);
//    if ([methodName isEqualToString:@"sendMessage:"]) {
//       return  class_addMethod([self class], sel, (IMP)haha, "v@:@"); // v@:@ 可以不写
//    }
//
//    // 1 类 2 方法编号 3 方法实现（函数指针） 4 返回值
//
//    return  [super resolveInstanceMethod:sel];
//}


// 如果是类方法  一定是objc_getMetaClass
//+(BOOL)resolveClassMethod:(SEL)sel{
//
//    NSString *methodName = NSStringFromSelector(sel);
//    if ([methodName isEqualToString:@"testMethod"]) {
////       return  class_addMethod(objc_getClass([NSStringFromClass([Person class]) UTF8String]), sel, (IMP)haha, "v@:@"); // v@:@ 可以不写
//
//        return   class_addMethod(objc_getMetaClass([NSStringFromClass([Person class]) UTF8String]), sel, (IMP)test, "v@:@");
//
//    }
//
//    return  [super resolveInstanceMethod:sel];
//}


// oc方法的调用，默认会传递两个参数，消息接受者，消息本身（方法编号）
void haha(id self ,SEL _cmd, NSString *objc){
    
    NSLog(@"我吃了一个%@",objc);
}

void test(id self ,SEL _cmd){
    
    NSLog(@"test---");
}




//#pragma mark 第二部 消息转发 找到备胎，备胎里面有sendMessage方法
//- (id)forwardingTargetForSelector:(SEL)aSelector{
//
//    NSString *methodName = NSStringFromSelector(aSelector);
//    if ([methodName isEqualToString:@"sendMessage:"]) {
//        return [SpareWheel new];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}


// 如果是类方法

+ (id)forwardingTargetForSelector:(SEL)aSelector{
    
    NSString *methodName = NSStringFromSelector(aSelector);
    if ([methodName isEqualToString:@"testMethod"]) {
        return [SpareWheel class];
    }
    return [super forwardingTargetForSelector:aSelector];
}



//
//#pragma maek 第三部,漂流瓶 invocation
//
//// 因为用到漂流瓶 去寻找处理IMP，需要知道IMP的信息，所以需要提前包装方法签名
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    NSString *methodName = NSStringFromSelector(aSelector);
//    if ([methodName isEqualToString:@"sendMessage:"]) {
//        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
//    }
//    return  [super methodSignatureForSelector:aSelector];
//    
//}
//
//// invoction 处理IMP
//- (void)forwardInvocation:(NSInvocation *)anInvocation{
//    SEL sel = [anInvocation selector];
//    SpareWheel *sp = [SpareWheel new];
//    if ([sp respondsToSelector:sel]) {
//        [anInvocation invokeWithTarget:sp]; // invoke 执行
//    }else{
//        [super forwardInvocation:anInvocation];
//    }
//}


@end
