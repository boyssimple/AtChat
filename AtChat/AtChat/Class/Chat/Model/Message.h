//
//  Message.h
//  LifeChat
//
//  Created by zhouMR on 16/5/6.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    TEXT = 0,
    MEDIA,
    IMAGE,
    RECORD,
    NEWS
} MessageType;

typedef enum{
    OTHER = 0,
    ME
} MessageWho;
@interface Message : NSObject
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *voiceTime;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,assign)MessageType msgType;
@property(nonatomic,assign)MessageWho type;
@end
