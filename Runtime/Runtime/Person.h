//
//  Person.h
//  Runtime
//
//  Created by zhouyuxi on 2017/11/13.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int age;

- (void)run;


@end
