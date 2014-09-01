//
//  Node.m
//  SmartHousePad7
//
//  Created by gjt on 13-5-1.
//
//

#import "Node.h"

#define NullNodeID @"NullNodeId"
#define NullNodeName @"无名节点"
#define NullNodeDescription @"无该节点的描述"
#define DefaulControlUrl @"http://www.sina.com"


@implementation Node

@synthesize nodeId;
@synthesize name;
@synthesize type;
@synthesize controlUrl;
@synthesize nodeDescription;
@synthesize xPosition;
@synthesize yPosition;
@synthesize zPosition;

-(void)dealloc{
    [self.nodeId release];
    [self.name release];
    [self.type release];
    [self.controlUrl release];
    [self.nodeDescription release];
    [self.xPosition release];
    [self.yPosition release];
    [self.zPosition release];
    
    
    [super dealloc];
}

+(Node*)nullNode{
    Node*node=[[[Node alloc]init]autorelease];
    node.nodeId=NullNodeID;
    node.name=NullNodeName;
    node.nodeDescription=NullNodeDescription;
    node.controlUrl=DefaulControlUrl;
    return node;
}
+(BOOL)isNullNode:(Node*)node{
    return [node.nodeId isEqualToString:NullNodeID];
}

@end
