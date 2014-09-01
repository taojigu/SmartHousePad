//
//  MaterialParser.h
//  SmartHousePad7
//
//  Created by gjt on 13-5-1.
//
//

#import <Foundation/Foundation.h>
@class Material;
@class Pod;
@class Node;
@interface MaterialParser : NSObject<NSXMLParserDelegate>{
    @private
    NSXMLParser*parser;
    Material*result;
    Pod*tempPod;
    Node*tmpNode;
    NSString*currentElementName;
}

-(Material*)parse:(NSData*)data;

@end
