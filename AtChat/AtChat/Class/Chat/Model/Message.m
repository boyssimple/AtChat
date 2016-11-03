//
//  Message.m
//  LifeChat
//
//  Created by zhouMR on 16/5/6.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "Message.h"

@implementation Message
- (instancetype)init{
    self = [super init];
    if (self) {
        _voiceTime = @"";
        _time = @"";
        _msgType = TEXT;
        _type = ME;
    }
    return self;
}
@end
