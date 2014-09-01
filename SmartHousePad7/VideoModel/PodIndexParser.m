//
//  PodIndexParser.m
//  SmartHousePad7
//
//  Created by gjt on 13-8-15.
//
//

#import "PodIndexParser.h"


#define PodTag @"Pod"
#define NodeTag @"Node"

#define FileNameTag @"fileName"
#define TypeTag @"type"
#define OpacityTag @"opacity"
#define IDTag @"id"
#define CollidedTag @"collided"


#define IntroductionTag @"Description"

#define NameTag @"name"
#define XTag @"x"
#define YTag @"y"
#define ZTag @"z"




/*
<Pod  type="CodeCreated" fileName="">
<PodName>
<![CDATA[CodeCreateNodes]]>
</PodName>
<NodeArray>
<Node id="Light1" name="lamp" type="Light"  x="" y="48" z="83">
<Description>
<![CDATA[Global Light]]>
</Description>
</Node>
<Node id="Light2" name="innerLight" type="Light"  x="" y="48" z="83">
<Description>
<![CDATA[Light inside the House]]>
</Description>
</Node>
<Node id="Camera1" name="globalCaremra" type="Camera"  x="" y="48" z="83">
<Description>
<![CDATA[Light inside the House]]>
</Description>
</Node>
</NodeArray>
</Pod>
 */

@implementation PodIndexParser

-(id)init{
    self=[super init];
    podIndexResult=[[[PodIndex alloc]init]autorelease];
    return self;
}

-(void)dealloc{
    if (nil!=tempNode) {
        [tempNode release];
    }
    if (nil!=tempPod) {
        [tempPod release];
    }

    [super dealloc];
}

-(PodIndex*)parse:(NSData*)data{
 

    
    
    if (nil!=parser) {
        [parser release];
    }

    parser=[[NSXMLParser alloc]initWithData:data];
    parser.delegate=self;
    [parser parse];
    return podIndexResult;
}

#pragma mark -- parser delegate messages

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([PodTag isEqualToString:elementName]) {
        [self processPod:attributeDict];
        return;
    }
    
    if ([NodeTag isEqualToString:elementName]) {
        [self processNode:attributeDict];
    }
}

#pragma mark-- private messages

-(void)processPod:(NSDictionary*)attributeDict{
    if (nil!=tempPod) {
        [tempPod release];
    }
    tempPod=[[Pod alloc]init];
    [podIndexResult.podArray addObject:tempPod];
    NSString*value=[attributeDict valueForKey:FileNameTag];
    tempPod.fileName=value;
    value=[attributeDict valueForKey:OpacityTag];
    tempPod.opacity=value;
    value=[attributeDict valueForKey:TypeTag];
    tempPod.type=value;
    value=[attributeDict valueForKey:CollidedTag];
    tempPod.collided=value;
    return;
}

-(void)processNode:(NSDictionary*)attributeDict{
    
    if (nil!=tempNode) {
        [tempNode release];
    }
    tempNode=[[Node alloc]init];
    [tempPod.nodeArray addObject:tempNode];
    tempNode.nodeId=[attributeDict valueForKey:IDTag];
    tempNode.name=[attributeDict valueForKey:NameTag];
    tempNode.type=[attributeDict valueForKey:TypeTag];
    tempNode.xPosition=[attributeDict valueForKey:XTag];
    tempNode.yPosition=[attributeDict valueForKey:YTag];
    tempNode.zPosition=[attributeDict valueForKey:ZTag];
    return;
}

@end
