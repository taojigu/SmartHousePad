
//  Cocos3dUtility.m
//  SmartHousePad7
//
//  Created by gjt on 13-5-13.
//
//

#import "Cocos3dUtility.h"
#import "CC3Matrix3x3.h"
#import "CC3MeshModel.h"
#import "CC3PODMesh.h"
#import "CCActionInterval.h"
#import "CC3ActionUtility.h"
#import "CC3PODNode.h"

#define GravityDetectDistance 100000


@implementation Cocos3dUtility

+(CC3Vector)globalVector:(CC3Vector)vector scale:(CC3Vector)scale location:(CC3Vector)location rotation:(CC3Vector)rotation{
    
    CC3Vector resultVector=[Cocos3dUtility scaleVector:vector scale:scale];
    resultVector=[Cocos3dUtility rotationVector:resultVector rotation:rotation];
    resultVector=[Cocos3dUtility translationVector:resultVector location:location];
    /*
    CC3Vector resultVector=[Cocos3dUtility translationVector:vector location:location];
    resultVector=[Cocos3dUtility rotationVector:resultVector rotation:rotation];
    resultVector=[Cocos3dUtility scaleVector:resultVector scale:scale];
    */
    return resultVector;
}

+(CC3Vector)scaleVector:(CC3Vector)vector scale:(CC3Vector)scale{

    CC3Vector resultVector=CC3VectorScale(vector, scale);
    return resultVector;
}
+(CC3Vector)rotationVector:(CC3Vector)vector rotation:(CC3Vector)rotation{
    CC3Matrix3x3 rotateMatrix;
    CC3Matrix3x3PopulateFromRotationX(&rotateMatrix, rotation.x);
    CC3Vector xVector=CC3Matrix3x3TransformCC3Vector(&rotateMatrix,vector);
    CC3Matrix3x3PopulateFromRotationY(&rotateMatrix, rotation.y);
    CC3Vector yVector=CC3Matrix3x3TransformCC3Vector(&rotateMatrix, xVector);
    CC3Matrix3x3PopulateFromRotationZ(&rotateMatrix, rotation.z);
    CC3Vector zVector=CC3Matrix3x3TransformCC3Vector(&rotateMatrix, yVector);
    
    return zVector;
}
+(CC3Vector)translationVector:(CC3Vector)vector location:(CC3Vector)location{

    CC3Vector resultVector=CC3VectorAdd(vector, location);
    return resultVector;
}



+(double)lineIntersectedWithFace:(CC3Vector)startLocation end:(CC3Vector)targetLocation vector1:(CC3Vector)v1 vector2:(CC3Vector)v2 vector3:(CC3Vector)v3 {
   /*
    if (fabs(v1.x>0.2)||fabs(v1.y)||fabs(v1.z)>0.2) {
        NSLog(@"Vector more than 0.2 %@",NSStringFromCC3Vector(v1));
        
    }
    */
    
    double ratio=-1;
    if (CC3VectorsAreEqual(v1, v2)||CC3VectorsAreEqual(v1, v2)||CC3VectorsAreEqual(v2, v3)) {
        return ratio;
    }
    CC3Vector vse=CC3VectorDifference(targetLocation, startLocation);
    CC3Vector v12=CC3VectorDifference(v2, v1);
    CC3Vector n12=CC3VectorCross(v12, vse);
    double ds12 = CC3VectorDot(CC3VectorDifference(startLocation, v1), n12);
    double d312 = CC3VectorDot(CC3VectorDifference(v3, v1), n12);
    if(d312 >= 0.0)
    {
        if(ds12<0.0) return ratio;
        if(ds12 > d312) return ratio;
    }
    else
    {
        if(ds12>0.0) return ratio;
        if(ds12<d312)return ratio;
    }
    
    
    
    CC3Vector v23=CC3VectorDifference(v3, v2);
    CC3Vector n23=CC3VectorCross(v23, vse);
    double ds23=CC3VectorDot(CC3VectorDifference(startLocation, v2), n23);
    double d123=CC3VectorDot(CC3VectorDifference(v1, v2), n23);
    if(d123 >=0)
    {
        if(ds23  < 0.0) return ratio;
        if(ds23 > d123) return ratio;
    }
    else
    {
        if(ds23 > 0.0) return ratio;
        if(ds23 < d123) return ratio;
    }
    
    
    CC3Vector v31=CC3VectorDifference(v1, v3);
    CC3Vector n31=CC3VectorCross(v31, vse);
    double ds31=CC3VectorDot(CC3VectorDifference(startLocation, v3), n31);
    double d231=CC3VectorDot(CC3VectorDifference(v2, v3), n31);
    if(d231>=0.0)
    {
        if(ds31<0.0) return ratio;
        if(ds31>d231)return ratio;
    }
    else
    {
        if(ds31>0.0)return ratio;
        if(ds31<d231)return ratio;
    }
    
    
    
    if(abs(d312) < 0.000001 || abs(d123) < 0.000001 || abs(d231) < 0.000001){
        return ratio;
    }
    
    double r3 = ds12/d312;
    double r1 = ds23/d123;
    double r2 = ds31/d231;
    
    
    CC3Vector vr1=CC3VectorScaleUniform(v1, r1);
    CC3Vector vr2=CC3VectorScaleUniform(v2, r2);
    CC3Vector vr3=CC3VectorScaleUniform(v3, r3);
    CC3Vector inVector=CC3VectorAdd(CC3VectorAdd(vr1, vr2), vr3);
    double length=CC3VectorLength(vse);
    vse=CC3VectorScaleUniform(vse, 1.0/length);
    double d=CC3VectorDot(CC3VectorDifference(inVector, startLocation), vse);
    
    if(d <0.0) return ratio;
    if(d > length) return ratio;
    
    ratio=d/length;
    
    return ratio;
    
}

+(BOOL)collisionWith:(CC3Node*)node withNode:(CC3Node*)anotherNode targetLocation:(CC3Vector)targetLocation padding:(CGFloat)padding{

    
    CC3BoundingBox globalBBox=anotherNode.globalBoundingBox;
    
    //NSLog(@"The global bounding boxi is %@",NSStringFromCC3BoundingBox(globalBBox));
    
    if ([Cocos3dUtility doesInsectedWithBoundingBox:node.globalLocation target:targetLocation boundingBox:globalBBox padding:padding]) {
        
        if ([anotherNode.children count]==0&&[anotherNode isKindOfClass:[CC3MeshNode class]]) {
            //[CC3ActionUtility actionChangeColor:anotherNode];
            
            NSLog(@"The childNode collided is %@",anotherNode.name);
            
            return YES;
        }
        
        for(CC3Node* childNode in anotherNode.children){
            if ([Cocos3dUtility collisionWith:node withNode:childNode targetLocation:targetLocation padding:padding]) {
                
                return YES;
            }
            
        }
        
        return NO;
        

    }

    
    return NO;
}


//Step < Eye sight distance
+(BOOL)collisionWithFaces:(CC3Node*)node withNode:(CC3MeshNode*)anotherNode targetLocation:(CC3Vector)targetLocation{
    CC3PODMesh*podMesh=(CC3PODMesh*)anotherNode.mesh;
    
    
    for (NSInteger faceIndex=0; faceIndex<podMesh.faceCount; faceIndex++) {
        CC3Face face=[podMesh faceAt:faceIndex];
        CC3Vector v0=[Cocos3dUtility globalVector:face.vertices[0] scale:anotherNode.globalScale location:anotherNode.globalLocation rotation:anotherNode.globalRotation];
        //CC3VectorAdd(face.vertices[0],anotherNode.globalLocation);
        CC3Vector v1=[Cocos3dUtility globalVector:face.vertices[1] scale:anotherNode.globalScale location:anotherNode.globalLocation rotation:anotherNode.globalRotation];
        //CC3VectorAdd(face.vertices[1], anotherNode.globalLocation);
        CC3Vector v2=[Cocos3dUtility globalVector:face.vertices[2] scale:anotherNode.globalScale location:anotherNode.globalLocation rotation:anotherNode.globalRotation];
        //CC3VectorAdd(face.vertices[2], anotherNode.globalLocation);
        
        
        double ratio=[Cocos3dUtility lineIntersectedWithFace:node.location end:targetLocation vector1:v0 vector2:v1 vector3:v2];
        if (0<ratio) {
            
           /* NSLog(@"The v0 is %@",NSStringFromCC3Vector(v0));
            NSLog(@"The v1 is %@",NSStringFromCC3Vector(v1));
            NSLog(@"The v2 is %@",NSStringFromCC3Vector(v2));
            
            NSLog(@"The node locaion is %@",NSStringFromCC3Vector(node.globalLocation));
            NSLog(@"The target Node location is %@",NSStringFromCC3Vector(targetLocation));
            */
            NSLog(@"Collide face with %@",anotherNode.name);
            return YES;
        }
        
    }
    
    return NO;
}


+(BOOL)doesInsectedWithBoundingBox:(CC3Vector)start target:(CC3Vector)end boundingBox:(CC3BoundingBox)bb padding:(GLfloat)padding{
 /*
    CC3BoundingBox testBox=CC3BoundingBoxAddPadding(bb, CC3VectorMake(padding, padding,padding));
    BOOL startIn=CC3BoundingBoxContainsLocation(testBox, start);
    BOOL endIn=CC3BoundingBoxContainsLocation(testBox, end);
    if (NO==startIn&&NO==endIn) {
        return NO;
    }
    else{
        return YES;
    }
  */
    if (CC3BoundingBoxContainsLocation(bb, start)&&CC3BoundingBoxContainsLocation(bb, end)) {
        return YES;
    }
    /*
    if ([Cocos3dUtility vectorInside:start boundingBox:bb]&&[Cocos3dUtility vectorInside:end boundingBox:bb]) {
        return YES;
    }*/
    
    if(start.x <= end.x)
	{
		if(end.x < bb.minimum.x-padding) return NO;
		if(start.x > bb.maximum.x+padding) return NO;
        
        
	}
	else
	{
		if(start.x < bb.minimum.x-padding) return NO;
        if(end.x > bb.maximum.x+padding) return NO;
        
	}
    
	if(start.y <= end.y)
	{
		if(end.y < bb.minimum.y-padding) return NO;
		if(start.y > bb.maximum.y+padding) return NO;
        
	}
	else
	{
		if(start.y < bb.minimum.y-padding) return NO;
        if(end.y > bb.maximum.y+padding) return NO;
        
    }
    
	if(start.z <= end.z)
	{
		if(end.z < bb.minimum.z-padding) return NO;
		if(start.z > bb.maximum.z+padding) return NO;
        
	}
	else
	{
		if(start.z < bb.minimum.z-padding) return NO;
        if(end.z > bb.maximum.z+padding) return NO;
        
	}
	return YES;
}

+(GLfloat)getFloorHeight:(CC3Node *)node podFloorNode:(CC3PODNode*)podNode{
    GLfloat height=GravityDetectDistance;
    for (CC3MeshNode*meshNode in podNode.children) {
        CGFloat childHeight=[Cocos3dUtility getFloorHeight:node floor:meshNode];
        if (childHeight<height) {
            height=childHeight;
        }
    }
    return height;
}


+(GLfloat)getFloorHeight:(CC3Node*)node floor:(CC3MeshNode*)floorNode{
    GLfloat height=GravityDetectDistance;
    CC3Mesh*mesh=floorNode.mesh;
    
    CC3Vector target=CC3VectorAdd(node.location, CC3VectorMake(0, 0-GravityDetectDistance, 0));
    
    GLfloat distance=CC3VectorDistance(node.location, target);
    for (NSInteger faceIndex=0;faceIndex<mesh.faceCount ; faceIndex++) {
        CC3Face face=[mesh faceAt:faceIndex];
        
        CC3Vector v0=[Cocos3dUtility globalVector:face.vertices[0] scale:floorNode.globalScale location:floorNode.globalLocation rotation:floorNode.globalRotation];
        // CC3VectorAdd(floorNode.globalLocation, face.vertices[0]);
        CC3Vector v1=[Cocos3dUtility globalVector:face.vertices[1] scale:floorNode.globalScale location:floorNode.globalLocation rotation:floorNode.globalRotation];
        //CC3VectorAdd(floorNode.globalLocation, face.vertices[1]);
        CC3Vector v2=[Cocos3dUtility globalVector:face.vertices[2] scale:floorNode.globalScale location:floorNode.globalLocation rotation:floorNode.globalRotation];
        
        double ratio=[Cocos3dUtility lineIntersectedWithFace:node.location end:target vector1:v0 vector2:v1 vector3:v2];
        if (-1==ratio) {
            continue;
        }
        
        GLfloat tmpHeight=ratio*distance;
        if (tmpHeight<height) {
            height=tmpHeight;
        }
    }
    
    return height;
    
}


+(BOOL)vectorInside:(CC3Vector)vct boundingBox:(CC3BoundingBox)boundingBox{
    if (vct.x>boundingBox.minimum.x&&vct.x<boundingBox.maximum.x
        &&vct.y>boundingBox.minimum.y&&vct.y<boundingBox.maximum.y
        &&vct.z>boundingBox.minimum.z&&vct.z<boundingBox.maximum.z) {
        return YES;
    }else{
        
        return NO;
    }
}

+(void)touchEnableWhoeNodeTree:(CC3Node*)node{
    if ([node isKindOfClass:[CC3MeshNode class]]) {
        node.isTouchEnabled=YES;
    }
    if (0==[node.children count]) {
        return;
    }
    for (CC3Node*childNode in node.children) {
        [Cocos3dUtility touchEnableWhoeNodeTree:childNode];
    }
}
    



@end
