//
//  Node.h
//  SmartHousePad7
//
//  Created by gjt on 13-5-1.
//
//

#import <Foundation/Foundation.h>

#define NodeTypeControl @"Control"
#define NodeTypeCamara @"Camera"
#define NodeTypeLight @"Light"
#define NodeTypeFloor @"Floor"





@interface Node : NSObject{
    
}


@property(nonatomic,retain)NSString*nodeId;
@property(nonatomic,retain)NSString*name;
@property(nonatomic,retain)NSString*type;
@property(nonatomic,retain)NSString*controlUrl;
@property(nonatomic,retain)NSString*nodeDescription;
@property(nonatomic,retain)NSString*xPosition;
@property(nonatomic,retain)NSString*yPosition;
@property(nonatomic,retain)NSString*zPosition;


+(Node*)nullNode;
+(BOOL)isNullNode:(Node*)node;

@end
