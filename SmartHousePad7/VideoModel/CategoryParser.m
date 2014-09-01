//
//  CategoryParser.m
//  SandPad
//
//  Created by gjt on 12-11-25.
//  Copyright (c) 2012年 voole. All rights reserved.
//

#import "CategoryParser.h"
#import "VideoAbstract.h"

#define CategoryTag @"CategoryAbstract"
#define VideoAbtractTag @"VideoAbstract"
#define PlayControlCategoryTag @"ExtraCategoryAbstractArray"

#define NodeTag @"node"
#define NameTag @"name"
#define CodeTag @"code"
#define ImageUrlTag @"posterUrl"


@implementation CategoryParser

-(id)init{
    self=[super init];
    resultCategory=[[[VideoCategory alloc]init]autorelease];
    isTravellingControls=NO;
    return self;
}
-(VideoCategory*)parse:(NSData*)data{
    if (nil!=parser) {
        [parser release];
    }
    parser=[[NSXMLParser alloc]initWithData:data];
    isTravellingControls=NO;
    parser.delegate=self;
    [parser parse];
    return resultCategory;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if (YES==isTravellingControls) {
        return;
    }
    if ([elementName isEqualToString:PlayControlCategoryTag]) {
        isTravellingControls=YES;
    }
    if ([elementName isEqualToString:CategoryTag]) {
        VideoCategory*vc=[[VideoCategory alloc]init];
        currentSubCategory=vc;
        vc.name=[attributeDict valueForKey:NameTag];
        vc.code=[attributeDict valueForKey:CodeTag];
        [resultCategory.subCategoryArray addObject:vc];
        return;
    }
    if ([elementName isEqualToString:VideoAbtractTag]) {
        VideoAbstract*va=[[VideoAbstract alloc]init];
        [currentSubCategory.videoAbstractArray addObject:va];
        va.name=[attributeDict valueForKey:NameTag];
        va.code=[attributeDict valueForKey:CodeTag];
        va.imageUrl=[attributeDict valueForKey:ImageUrlTag];
        return;
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
}
@end
