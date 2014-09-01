//
//  Category.m
//  SandTableNavigation
//
//  Created by gjt on 12-11-23.
//  Copyright (c) 2012年 voole. All rights reserved.
//

#import "VideoCategory.h"

@implementation VideoCategory

@synthesize name;
@synthesize code;
@synthesize subCategoryArray;
@synthesize videoAbstractArray;
-(id)init{
    self=[super init];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    self.subCategoryArray=array;
    [array release];
    array=[[NSMutableArray alloc]init];
    self.videoAbstractArray=array;
    [array release];
    return self;
}
-(void)dealloc{
    [self.name release];
    [self.code release];
    [self.subCategoryArray release];
    [self.videoAbstractArray release];
    [super dealloc];
}

@end
