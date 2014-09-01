//
//  Category.h
//  SandTableNavigation
//
//  Created by gjt on 12-11-23.
//  Copyright (c) 2012年 voole. All rights reserved.
//
//用于存储从主机读取的Video目录信息（暂停，继续，停止）
#import <Foundation/Foundation.h>

@interface VideoCategory : NSObject{
    
}

@property(nonatomic,retain)NSString*name;
@property(nonatomic,retain)NSString*code;
@property(nonatomic,retain)NSMutableArray*subCategoryArray;
@property(nonatomic,retain)NSMutableArray*videoAbstractArray;

@end
