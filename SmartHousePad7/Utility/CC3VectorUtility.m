//
//  CC3VectorUtility.m
//  SmartHousePad7
//
//  Created by gjt on 13-7-11.
//
//

#import "CC3VectorUtility.h"

@implementation CC3VectorUtility

+(CC3Vector)vectorFromString:(NSString*)str{
    NSArray*array=[str componentsSeparatedByString:@":"];
    NSString*xString=[array objectAtIndex:0];
    NSString*yString=[array objectAtIndex:1];
    NSString*zString=[array objectAtIndex:2];
    return CC3VectorMake([xString floatValue], [yString floatValue], [zString floatValue]);
}
+(NSString*)stringFromVector:(CC3Vector)vector{
    return [NSString stringWithFormat:@"%f:%f:%f",vector.x,vector.y,vector.z];
}

@end
