//
//  VideoAbstract.m
//  SandTableNavigation
//
//  Created by gjt on 12-11-23.
//  Copyright (c) 2012年 voole. All rights reserved.
//

#import "VideoAbstract.h"

@implementation VideoAbstract

@synthesize imageUrl;
@synthesize  code;
@synthesize  name;
@synthesize playUrl;

-(void)dealloc{
    [self.playUrl release];
    [self.imageUrl release];
    [self.code release];
    [self.name release];
    [super dealloc];
}

@end
