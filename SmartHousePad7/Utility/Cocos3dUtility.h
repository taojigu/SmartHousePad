//
//  Cocos3dUtility.h
//  SmartHousePad7
//
//  Created by gjt on 13-5-13.
//
//

#import <Foundation/Foundation.h>
#import "CC3Foundation.h"
#import "CC3Node.h"
#import "CC3MeshNode.h"
@class CC3PODNode;

@interface Cocos3dUtility : NSObject




+(CC3Vector)globalVector:(CC3Vector)vector scale:(CC3Vector)scale location:(CC3Vector)location rotation:(CC3Vector)rotation;


+(double)lineIntersectedWithFace:(CC3Vector)startLocation end:(CC3Vector)targetLocation vector1:(CC3Vector)v1 vector2:(CC3Vector)v2 vector3:(CC3Vector)v3;

+(BOOL)collisionWith:(CC3Node*)node withNode:(CC3Node*)anotherNode targetLocation:(CC3Vector)targetLocation padding:(CGFloat)padding;

+(BOOL)doesInsectedWithBoundingBox:(CC3Vector)start target:(CC3Vector)end boundingBox:(CC3BoundingBox)bb padding:(GLfloat)padding;

+(GLfloat)getFloorHeight:(CC3Node*)node floor:(CC3MeshNode*)floorNode;
+(GLfloat)getFloorHeight:(CC3Node *)node podFloorNode:(CC3PODNode*)podNode;

+(BOOL)vectorInside:(CC3Vector)vct boundingBox:(CC3BoundingBox)boundingBox;

+(void)touchEnableWhoeNodeTree:(CC3Node*)node;

+(BOOL)collisionWithFaces:(CC3Node*)node withNode:(CC3MeshNode*)anotherNode targetLocation:(CC3Vector)targetLocation;

@end
