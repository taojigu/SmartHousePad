//
//  Pod.m
//  SmartHousePad7
//
//  Created by gjt on 13-5-1.
//
//

#import "Pod.h"

@implementation Pod

@synthesize fileName;
@synthesize type;
@synthesize opacity;
@synthesize nodeArray;
@synthesize collided;


-(id)init{
    self=[super init];
    NSMutableArray*tmpArray=[[NSMutableArray alloc]init];
    self.nodeArray=tmpArray;
    [tmpArray release];
    return self;
}

-(void)dealloc{
    [self.collided release];
    [self.type release];
    [self.opacity release];
    [self.fileName release];
    [self.nodeArray release];
    [super dealloc];
}

@end
