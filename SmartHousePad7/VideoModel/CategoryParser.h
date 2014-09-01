//
//  CategoryParser.h
//  SandPad
//
//  Created by gjt on 12-11-25.
//  Copyright (c) 2012年 voole. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoCategory.h"
@interface CategoryParser : NSObject<NSXMLParserDelegate>{
    @private
    NSXMLParser*parser;
    VideoCategory*resultCategory;
    VideoCategory*currentSubCategory;
    BOOL isTravellingControls;
    
    
}

-(VideoCategory*)parse:(NSData*)data;


@end
