//
//  PodIndex.m
//  SmartHousePad7
//
//  Created by gjt on 13-10-8.
//
//

#import "PodIndex.h"

@implementation PodIndex

@synthesize name;
@synthesize podArray;

-(id)init{
    self=[super init];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    self.podArray=array;
    [array release];
    return self;
}

-(void)dealloc{
    [self.podArray release];
    [self.name release];
    [super dealloc];
}

@end
