//
//  PathUtility.m
//  SmartHousePad7
//
//  Created by gjt on 13-10-11.
//
//

#import "PathUtility.h"

#define PodResurceDirName @"PodResource"

@implementation PathUtility

+(NSString*)podFilePath:(NSString*)podFileName{
    NSAssert([podFileName length]>0, @"pod file name should not be nil");
    NSString*docPath=[PathUtility documentDirectoryPath];
    docPath=[docPath stringByAppendingPathComponent:PodResurceDirName];
    docPath=[docPath stringByAppendingPathComponent:podFileName];
    return  docPath;
}

+(NSString*)documentDirectoryPath{
    NSArray*pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*docPath=[pathArray objectAtIndex:0];
    return docPath;
}

@end
