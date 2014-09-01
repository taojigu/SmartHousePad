//
//  VideoAbstract.h
//  SandTableNavigation
//
//  Created by gjt on 12-11-23.
//  Copyright (c) 2012年 voole. All rights reserved.
//
//用于存储从主机读取Video信息
#import <Foundation/Foundation.h>

@interface VideoAbstract : NSObject{
    
}

@property(nonatomic,retain)NSString*name;
@property(nonatomic,retain)NSString*code;
@property(nonatomic,retain)NSString*imageUrl;
@property(nonatomic,retain)NSString*playUrl;
@end
