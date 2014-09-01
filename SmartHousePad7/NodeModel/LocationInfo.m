//
//  LocationInfo.m
//  SmartHousePad7
//
//  Created by gjt on 13-7-11.
//
//

#import "LocationInfo.h"
#import "CC3Foundation.h"
#import "CC3VectorUtility.h"


#define LocationIdTag @"locationId"
#define LocationNameTag @"locationName"
#define LocationStringTag @"locationString"
#define RotationStringTag @"rotationString"
#define UrlStringTag @"urlString"



@implementation LocationInfo

@synthesize locationId;
@synthesize locationName;
@synthesize location;
@synthesize rotation;
@synthesize urlString;
@synthesize locationString;
@synthesize rotationString;

-(void)dealloc{
    
    [self.urlString release];
    [self.locationName release];
    [self.locationId release];
    [self.locationString release];
    [self.rotationString release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    self.locationString=[CC3VectorUtility stringFromVector:self.location];
    self.rotationString=[CC3VectorUtility stringFromVector:self.rotation];
    
    [aCoder encodeObject:self.locationId forKey:LocationIdTag];
    [aCoder encodeObject:self.locationName forKey:LocationNameTag];
    [aCoder encodeObject:self.urlString forKey:UrlStringTag];
    [aCoder encodeObject:self.locationString forKey:LocationStringTag];
    [aCoder encodeObject:self.rotationString forKey:RotationStringTag];
    return;
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    self.locationId=[aDecoder decodeObjectForKey:LocationIdTag];
    self.locationName=[aDecoder decodeObjectForKey:LocationNameTag];
    self.urlString=[aDecoder decodeObjectForKey:UrlStringTag];
    self.locationString=[aDecoder decodeObjectForKey:LocationStringTag];
    self.location=[CC3VectorUtility vectorFromString:self.locationString];
    self.rotationString=[aDecoder decodeObjectForKey:RotationStringTag];
    self.rotation=[CC3VectorUtility vectorFromString:self.rotationString];
    return self;
                                                
}

+(void)synchronizeToFile:(NSString*)fileName array:(NSArray*)array{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSData* artistData = [NSKeyedArchiver archivedDataWithRootObject:array];
    [artistData writeToFile:path atomically:YES];

}
+(NSMutableArray*)arrayFromFile:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSMutableArray*array= [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (nil==array) {
        array=[[[NSMutableArray alloc]init]autorelease];
    }
    return array;
}


+(NSMutableArray*)sampleLocationArray{
    NSMutableArray*array=[[[NSMutableArray alloc]init]autorelease];
    
    LocationInfo*startLocation=[[LocationInfo alloc]init];
    startLocation.locationId=@"StartPoint";
    startLocation.locationName=@"测试点";
    startLocation.location=CC3VectorMake(60, 0, 20);
    startLocation.rotation=CC3VectorMake(0, 0, 0);
    
    [array addObject:startLocation];
    
    LocationInfo*indoorLoc=[[LocationInfo alloc]init];
    indoorLoc.locationId=@"indoor";
    indoorLoc.locationName=@"室内";
    indoorLoc.location=CC3VectorMake(17.206, 2.7017, -38.817);
    indoorLoc.rotation=CC3VectorMake(-6.8, 84.861, 0);
    
    [array addObject:indoorLoc];
    [indoorLoc release];
    
    LocationInfo*outDoor=[[LocationInfo alloc]init];
    outDoor.locationId=@"birdViewPoint";
    outDoor.locationName=@"鸟瞰";
    outDoor.location=CC3VectorMake(12.6829, 41.4352, 0.5604);
    outDoor.rotation=CC3VectorMake(-42.817, -3.8574, 0);
    [array addObject:outDoor];
    [outDoor release];
    return array;
}

@end
