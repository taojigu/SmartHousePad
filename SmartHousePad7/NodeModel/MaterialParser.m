//
//  MaterialParser.m
//  SmartHousePad7
//
//  Created by gjt on 13-5-1.
//
//

#import "MaterialParser.h"
#import "Material.h"
#import "Node.h"
#import "Pod.h"

#define PodTag @"Pod"
#define MaterialTag @"Material"
#define NodeTag @"Node"

#define FileNameKey @"fileName"

#define IdKey @"id"
#define NameKey @"name"
#define TypeKey @"type"
#define ControlUrlKey @"controlUrl"
#define DetailTextTag @"Description"


@implementation MaterialParser

-(id)init{
    self=[super init];
    
    result=[[[Material alloc]init]autorelease];
    return self;
}

-(void)dealloc{
    
    [parser release];
    [super dealloc];
}

-(Material*)parse:(NSData*)data{
    if (nil!=parser) {
        [parser release];
    }

    [result.podArray removeAllObjects];
    
    
    parser=[[NSXMLParser alloc]initWithData:data];
    parser.delegate=self;
    [parser parse];
    return result;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentElementName=elementName;
    if([elementName isEqualToString:PodTag]){
        [self processPodElement:attributeDict];
        return;
    }
    if ([elementName isEqualToString:NodeTag]) {
        [self processNodeElement:attributeDict];
        return;
    }
    if([elementName isEqualToString:MaterialTag]){
        [self processMaterialElement:attributeDict];
        return;
    }
    
}
-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    NSString*text=[[[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding]autorelease];
    tmpNode.nodeDescription=text;
    //tmpNode.detailText=text;
    return;
}

-(void)processPodElement:(NSDictionary*)attributesDict{
    if (nil!=tempPod) {
        [tempPod release];
    }
    tempPod=[[Pod alloc]init];
    tempPod.fileName=[attributesDict valueForKey:FileNameKey];
    [result.podArray addObject:tempPod];
}
-(void)processNodeElement:(NSDictionary*)attributeDict{
    if (nil!=tmpNode) {
        [tmpNode release];
    }
    
    tmpNode=[[Node alloc]init];
    tmpNode.nodeId=[attributeDict valueForKey:IdKey];
    tmpNode.name=[attributeDict valueForKey:NameKey];
    tmpNode.type=[attributeDict valueForKey:TypeKey];
    tmpNode.controlUrl=[attributeDict valueForKey:ControlUrlKey];
    [tempPod.nodeArray addObject:tmpNode];
}
-(void)processMaterialElement:(NSDictionary*)attributeDict{
    
}




@end
