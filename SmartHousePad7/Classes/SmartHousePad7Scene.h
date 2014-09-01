/**
 *  SmartHousePad7Scene.h
 *  SmartHousePad7
 *
 *  Created by gjt on 13-4-1.
 *  Copyright __MyCompanyName__ 2013年. All rights reserved.
 */


#import "CC3Scene.h"
#import "CC3SceneDelegate.h"
@class CC3MeshNode;
@class Material;

/** A sample application-specific CC3Scene subclass.*/
@interface SmartHousePad7Scene : CC3Scene {
    
    CC3Vector cameraMoveStartLocation;
	CC3Vector cameraPanStartRotation;
    
    CC3Node* selectedNode;
	CGPoint lastTouchEventPoint;
	struct timeval lastTouchEventTime;
	//CameraZoomType cameraZoomType;
	CC3Ray lastCameraOrientation;
	GLubyte bmLabelMessageIndex;
	BOOL isManagingShadows;
    CC3MeshNode*headNode;
    CC3MeshNode*houseNode;
    
    NSMutableArray*meshNodeArray;
    NSMutableArray*floorNodeArray;
    NSMutableArray*errNodeArray;
    Material*material;
    
}

@property(nonatomic,assign)CGPoint playerDirectionControl;
@property(nonatomic,assign)CGPoint playerLocationControl;

@property(nonatomic,assign)id<CC3SceneDelegate>sceneDelegate;

-(void)startSquareMovingCamera;
-(void)squareMoveCamera:(CGPoint)velocity;
-(void)stopSquareMovingCamera;


-(void) startMovingCamera;
-(void) stopMovingCamera;
-(void) moveCameraBy:  (CGFloat) aMovement;
-(void) startPanningCamera;
-(void) stopPanningCamera;
-(void) panCameraBy:  (CGPoint) aMovement;
-(void) startDraggingAt: (CGPoint) touchPoint;
-(void) dragBy: (CGPoint) aMovement atVelocity: (CGPoint) aVelocity;
-(void) stopDragging;

@end

#pragma mark -
#pragma mark CC3Node extensions to support PVR POD content

@interface CC3Node (CollisionCheck)

-(BOOL)doesIntersectNodeWithDistance:(CC3Node*)otherNode;

@end

