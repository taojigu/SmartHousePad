//
//  PodManageUtility.h
//  SmartHousePad7
//
//  Created by gjt on 13-10-8.
//
//

#import <Foundation/Foundation.h>

@class Pod;
@class PodIndex;
@class CC3Scene;

@interface PodManageUtility : NSObject

+(void)loadPod:(Pod*)pod scene:(CC3Scene*)scene;
+(void)loadResourceFilePod:(Pod*)pod scene:(CC3Scene*)scene;
+(void)loadCodeCreatedPod:(Pod*)pod scene:(CC3Scene*)scene;

@end
