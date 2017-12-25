//
//  ViewController.m
//  Runtime
//
//  Created by zhouyuxi on 2017/11/13.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h> // 消息发送机制头文件

@interface ViewController ()

@property (nonatomic,strong) Person *person;

@end

@implementation ViewController
- (IBAction)save:(id)sender {
    
    NSString *path = NSTemporaryDirectory();
    NSString *pathName = [path stringByAppendingPathComponent:@"person.data"];
    NSLog(@"%@",pathName);
    
    
    // 归档对象
    [NSKeyedArchiver archiveRootObject:_person toFile:pathName];
    
}
- (IBAction)read:(id)sender {
    NSString *path = NSTemporaryDirectory();
    NSString *pathName = [path stringByAppendingPathComponent:@"person.data"];
    NSLog(@"%@",pathName);
    
    
//    // 归档对象
//    [NSKeyedArchiver archiveRootObject:_person toFile:pathName];
    
   Person *p =  [NSKeyedUnarchiver unarchiveObjectWithFile:pathName];
    NSLog(@"%@--%d",p.name,p.age);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testURL];
    
//    [self testDongtaijiazaiMethod];
    [self testKVO];
}


// 动态添加方法（懒加载方法）
- (void)testDongtaijiazaiMethod
{
    Person *p = [[Person alloc] init];
    [p performSelector:@selector(eat:) withObject:@"汉堡"];
//     objc_msgSend(p, @selector(eat),@"汉堡");
}

- (void)testKVO
{
     Person *p = [[Person alloc] init];
     [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    _person = p;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    NSLog(@"%@",_person.name);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    static int a = 0;
//    a++;
//    self.person.name = [NSString stringWithFormat:@"%d",a];
    _person.name = @"哈哈哈";

}



-(void)testGuiDang
{
    
    /*
     typedef struct objc_method *Method; // 方法
     typedef struct objc_ivar *Ivar; // 成员变量
     */
    
    Person *p = [[Person alloc] init];
    p.name = @"zhou";
    p.age = 18;
    _person = p;
    
    //    [p run];
    //    [self performSelector:@selector(run) withObject:p];
    //
    //    [p performSelector:@selector(run)];
    
    //    objc_msgSend(p, @selector(run));
    
    //    Person *person = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
    //    person  = objc_msgSend(person, sel_registerName("alloc"));
    
    
    // 返回方法名
//    NSSelectorFromString() ---- sel_registerName()
    
// 返回对象名
//    NSClassFromString()---- objc_getClass()
    
    Person *person  = objc_msgSend(objc_msgSend(objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
    person.name = @"hahhah";
    person.age = 20;
}

- (void)testURL //目的：整个项目一句代码都不用修改，放入我的文件，直接可以判断是否为nil
{
    //1.给NSURL对象发送URLWithString消息（SEL）
    //2.通过SEL 找到IMP（方法实现，实质上是一个指针）
    //3.执行IMP指向的代码code
    
    NSString *url = @"http://www.baidu.com/中文";
    NSURL *path = [NSURL URLWithString:url];
    NSLog(@"%@",path);
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
