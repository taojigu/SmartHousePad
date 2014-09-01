//
//  Pod.h
//  SmartHousePad7
//
//  Created by gjt on 13-5-1.
//
//

#import <Foundation/Foundation.h>



#define PodTypeFloor @"FloorPod"
#define PodTypeResource @"ResourcePod"
#define PodTypeCodeCreated @"CodeCreated"


#define YesValue @"YES"
#define NoValue @"NO"

@interface Pod : NSObject

@property(nonatomic,retain)NSString*fileName;
@property(nonatomic,retain)NSString*type;
@property(nonatomic,retain)NSString*opacity;
@property(nonatomic,retain)NSMutableArray*nodeArray;
@property(nonatomic,retain)NSString*collided;


@end
