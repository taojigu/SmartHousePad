//
//  CC3VectorUtility.h
//  SmartHousePad7
//
//  Created by gjt on 13-7-11.
//
//

#import <Foundation/Foundation.h>
#import "CC3Foundation.h"

@interface CC3VectorUtility : NSObject

+(CC3Vector)vectorFromString:(NSString*)str;
+(NSString*)stringFromVector:(CC3Vector)vector;

@end
