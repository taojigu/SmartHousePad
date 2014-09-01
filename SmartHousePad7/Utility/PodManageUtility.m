//
//  PodManageUtility.m
//  SmartHousePad7
//
//  Created by gjt on 13-10-8.
//
//

#import "PodManageUtility.h"

#import "Pod.h"
#import "CC3Scene.h"

@implementation PodManageUtility

+(void)loadPod:(Pod*)pod scene:(CC3Scene*)scene{
    if ([PodTypeResource isEqualToString:pod.type]) {
        [PodManageUtility loadResourceFilePod:pod scene:scene];
        return;
    }
    
    if ([PodTypeCodeCreated isEqualToString:pod.type]) {
        [PodManageUtility loadCodeCreatedPod:pod scene:scene];
    }
   
}

+(void)loadResourceFilePod:(Pod*)pod scene:(CC3Scene*)scene{
    


    
}
+(void)loadCodeCreatedPod:(Pod*)pod scene:(CC3Scene*)scene{
    
}


@end
