//
//  PodIndexParser.h
//  SmartHousePad7
//
//  Created by gjt on 13-8-15.
//
//

#import <Foundation/Foundation.h>

#import "Pod.h"
#import "Node.h"
#import "PodIndex.h"

@interface PodIndexParser : NSObject <NSXMLParserDelegate>{
    @private
    PodIndex*podIndexResult;
    Pod*tempPod;
    Node*tempNode;
    NSXMLParser*parser;
    
}

-(PodIndex*)parse:(NSData*)data;


@end
