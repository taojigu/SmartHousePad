//
//  LocationInfo.h
//  SmartHousePad7
//
//  Created by gjt on 13-7-11.
//
//

#import <Foundation/Foundation.h>
#import "CC3Foundation.h"


@interface LocationInfo : NSObject <NSCoding>{
    
}

@property(nonatomic,retain)NSString*locationId;
@property(nonatomic,retain)NSString*locationName;
@property(nonatomic,assign)CC3Vector location;
@property(nonatomic,assign)CC3Vector rotation;
@property(nonatomic,retain)NSString*urlString;
@property(nonatomic,retain)NSString*locationString;
@property(nonatomic,retain)NSString*rotationString;


+(NSArray*)sampleLocationArray;
+(void)synchronizeToFile:(NSString*)fileName array:(NSArray*)array;
+(NSMutableArray*)arrayFromFile:(NSString*)fileName;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
