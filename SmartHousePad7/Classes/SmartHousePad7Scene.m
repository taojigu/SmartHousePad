/**
 *  SmartHousePad7Scene.m
 *  SmartHousePad7
 *
 *  Created by gjt on 13-4-1.
 *  Copyright __MyCompanyName__ 2013年. All rights reserved.
 */

#import "SmartHousePad7Scene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CGPointExtension.h"
#import "Models.h"
#import "CCLabelTTF.h"
#import "CCActionInstant.h"
#import "CC3Node.h"
#import "CC3PODMesh.h"
#import "Material.h"
#import "MaterialParser.h"
#import "Node.h"
#import "Cocos3dUtility.h"
#import "CC3PODNode.h"
#import "Pod.h"
#import "Node.h"
#import "PodIndexParser.h"
#import "PodIndex.h"
#import "PathUtility.h"




#define GlobalPodFileName @"42216.pod"

#define EasyBoxPodFileName @"42216.pod"

#define HousePodFileName @"4191735.pod"

#define DeclineFloorNodeName @"Box01"
#define StoneNodeName @"Box02"
#define FooterStoneNodeName @"Box03"

#define EasyRoomNodeName @"Group01"
#define EasyFloorNodeName @"floor"
#define EasyRoomPodFileName @"51717.pod"



#define GroupPodFileName @"GroupTest.pod"
#define RootGroupNodeName @"rootbox"

#define TreeNode1 @"YLA543"
#define TreeNode2 @"YLA544"

// Model names
#define kNodeGridName			@"NodeGrid"
#define kHelloWorldName			@"Hello"
#define kBeachBallName			@"BeachBall"
#define kGlobeName				@"Globe"
#define kDieCubeName			@"Cube"
#define kMascotName				@"cocos2d_3dmodel_unsubdivided"

// File names
#define kLogoFileName			@"Default.png"
#define kHelloWorldFileName		@"hello-world.pod"
#define kBeachBallFileName		@"BeachBall.pod"
#define kGlobeTextureFile		@"Earth_1024.jpg"
#define kMascotPODFile			@"cocos3dMascot.pod"
#define kDieCubePODFile			@"DieCube.pod"
#define SkyBoxPODFile           @"CC.pod"
#define SkyBoxNodeName          @"Sphere01"


#define SqureMoveVelocityFactor 0.0005
#define kCamPinchMovementUnit	10
#define CameraRotateFactor 100
#define JoyStickLocationFactor 5
#define JoyStickRotateFactor 5
#define BoundingBoxPadding 0
#define ProbeOffset 1
#define GravityMoveDistance 3
#define CameraHeight 1.5
#define DownwardStep 0.1

#define Floor1 @"Floor1"
#define Floor2 @"Floor_2"

#define AAPodFileName @"AA2.pod"



@implementation SmartHousePad7Scene

@synthesize playerDirectionControl;
@synthesize playerLocationControl;
@synthesize sceneDelegate;

-(void) dealloc {
    [errNodeArray release];
    [meshNodeArray release];
    [floorNodeArray release];
    [headNode release];
	[super dealloc];
}

/**
 * Constructs the 3D scene.
 *
 * Adds 3D objects to the scene, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model scene.
 *
 * NOTE: The POD file used for the 'hello, world' message model is fairly large,
 * because converting a font to a mesh results in a LOT of triangles. When adapting
 * this template project for your own application, REMOVE the POD file 'hello-world.pod'
 * from the Resources folder of your project!!
 */
-(void) initializeScene {

    [self initBufferNodeArray];
    self.isTouchEnabled=NO;
    
    [self loadPodFilesFromIndexFiles];
    return;
    
    
    cameraMoveStartLocation=CC3VectorMake(6, 3, -16);
	// Create the camera, place it back a bit, and add it to the scene
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
    cam.shouldDrawBoundingVolume=YES;
    cam.rotation=CC3VectorMake(6.354,-34.961,0);
	cam.location = cameraMoveStartLocation;
	[self addChild: cam];

	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the scene
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( -2.0, 20, 0.0 );
	lamp.isDirectionalOnly = NO;
    
	[cam addChild: lamp];
    
    CC3Light* innerlamp = [CC3Light nodeWithName: @"innerLamp"];
	innerlamp.location = cc3v( 16, 10, -20 );
	innerlamp.isDirectionalOnly = NO;
	[self addChild: innerlamp];
    
	// This is the simplest way to load a POD resource file and add the
	// nodes to the CC3Scene, if no customized resource subclass is needed.
	
    [self addTinghua0707Pod];
       
	
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex data in main memory because it is now redundant.
	[self createGLBuffers];



	//[self releaseRedundantData];
	


}

-(void)initBufferNodeArray{
    meshNodeArray=[[NSMutableArray alloc]init];
    floorNodeArray=[[NSMutableArray alloc]init];
    errNodeArray=[[NSMutableArray alloc]init];
    
}

#pragma mark Updating custom activity





#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {

	// Uncomment this line to have the camera move to show the entire scene. This must be done after the
	// CC3Layer has been attached to the view, because this makes use of the camera frustum and projection.
	// If you uncomment this line, you might also want to uncomment the LogDebug line in the updateAfterTransform:
	// method to track how the camera moves, and where it ends up, in order to determine where to position
	// the camera to see the entire scene.
//	[self.activeCamera moveWithDuration: 3.0 toShowAllOf: self];

	// Uncomment this line to draw the bounding box of the scene.
//	self.shouldDrawWireframeBox = YES;

}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *up
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


#pragma mark Handling touch events 

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touch events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint {}

/**
 * This callback template method is invoked automatically when a node has been picked
 * by the invocation of the pickNodeFromTapAt: or pickNodeFromTouchEvent:at: methods,
 * as a result of a touch event or tap gesture.
 *
 * Override this method to perform activities on 3D nodes that have been picked by the user.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {

    
    [aNode stopAllActions];
    aNode.shouldDrawBoundingVolume=NO;
    aNode.shouldDrawWireframeBox=NO;
    
	// Remember the node that was selected
	selectedNode = aNode;
	
	// Uncomment to toggle the display of a descriptor label on the node
    //aNode.shouldDrawDescriptor = !aNode.shouldDrawDescriptor;
    
    if (nil!=self.sceneDelegate) {
        [self.sceneDelegate nodeSelected:aNode byTouchEvent:touchType at:touchPoint];
    }
    
	// Briefly highlight the location where the node was touched.
	[self markTouchPoint: touchPoint on: aNode];
}


-(void)updateBeforeTransform:(CC3NodeUpdatingVisitor *)visitor{
    if (0==playerLocationControl.x && 0== playerLocationControl.y) {
        return;
    }


    CGFloat height=[self getCurrentCameraFloorHeight:self.activeCamera];
    
    if (fabs(height-CameraHeight)>0.1) {
        
        if (height>CameraHeight) {
            NSLog(@"Camera is at %@, too hight",NSStringFromCC3Vector(self.activeCamera.location));
            CC3Vector vct=CC3VectorMake(0, 0-DownwardStep, 0);
            CC3Vector lcl=CC3VectorAdd(self.activeCamera.location, vct);
            self.activeCamera.location=lcl;
            return;
            
        }
        else{
            [self leverageCamera:CameraHeight-height];
        }

    }

    [self updateCameraFromControls:visitor];
    
    return;
   
}


#define GravityDetectDistance 1000

-(GLfloat)getCurrentCameraFloorHeight:(CC3Node*)node{
    GLfloat height=GravityDetectDistance;
    for (CC3Node*flrNode in floorNodeArray) {
        CGFloat tmpHeight=0;
        if ([flrNode class]==[CC3PODNode class]) {
           tmpHeight=[Cocos3dUtility getFloorHeight:node podFloorNode:(CC3PODNode*)flrNode];

        }
        else{
            tmpHeight=[Cocos3dUtility getFloorHeight:node floor:(CC3MeshNode*)flrNode];
        }
        if (tmpHeight<height) {
            height=tmpHeight;
        }
    }   
    
    return height;
}



-(void)dropCamera:(CC3NodeUpdatingVisitor*)visitor{
    
}
-(void)leverageCamera:(GLfloat)heightDistance{
    NSAssert(heightDistance>=0, @"The camear height has problem");
    NSLog(@"The camera move upward %f",heightDistance);
    CC3Vector upVector=CC3VectorMake(0, heightDistance, 0);
    CC3Vector targetVector=CC3VectorAdd(self.activeCamera.location, upVector);
    self.activeCamera.location=targetVector;
    
}
/** After all the nodes have been updated, check for collisions. */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {
    
    [self checkForCollisions];
}

/**
 * Check for collisions.
 *
 * Invoke the doesIntersectNode: method to determine whether the rainbow teapot has
 * collided with the brick wall.
 *
 * If the teapot is colliding with the wall, it may do so for several update frames.
 * On each frame, we need to determine whether it is heading towards the wall, or
 * away from it. If it's heading towards the wall we turn it around. If it's already
 * been turned around and is heading away from the wall, we let it continue.
 *
 * All movement is handled by CCActions.
 *
 * The effect is to see the teapot collide with the wall, bounce off it,
 * and head the other way.
 */
-(void) checkForCollisions {
    if ([self.activeCamera doesIntersectNodeWithDistance:headNode]) {
        NSLog(@"Collision with head");
    }
    else{
       // NSLog(@"NO Collision");
    }
	
}

/** Update the location and direction of looking of the 3D camera */
-(void) updateCameraFromControls: (CC3NodeUpdatingVisitor*)visitor {
	
    
    ccTime dt=visitor.deltaTime;
    
    if (fabs(playerLocationControl.x)>2*fabs(playerLocationControl.y)) {
        playerLocationControl.y=0;
    }
    
	// Update the location of the player (the camera)
	if ( playerLocationControl.x || playerLocationControl.y ) {
		
		// Get the X-Y delta value of the control and scale it to something suitable
		CGPoint delta = ccpMult(playerLocationControl, dt * JoyStickLocationFactor);
        

        
        CC3Vector moveVector = CC3VectorAdd(CC3VectorScaleUniform(activeCamera.globalRightDirection, 0),
											CC3VectorScaleUniform(activeCamera.globalForwardDirection, delta.y));
        
        moveVector.y=0;
        CC3Vector probeVector=CC3VectorAdd(moveVector, CC3VectorScaleUniform(CC3VectorNormalize(moveVector),ProbeOffset)) ;
        
        CC3Vector probeTarget=CC3VectorAdd(activeCamera.location, probeVector);
      
        for (CC3Node*mshNode in meshNodeArray) {
            BOOL collision=[Cocos3dUtility collisionWith:self.activeCamera withNode:mshNode targetLocation:probeTarget padding:BoundingBoxPadding];
           // BOOL collision=[self.activeCamera doesIntersectNode:headNode];
            if (collision) {
                NSLog(@"Collision happened,with %@",mshNode.name);
                return;
            }

        }
        CC3Vector targetVector=CC3VectorAdd(activeCamera.location, moveVector);
        activeCamera.location = targetVector;
        CC3Vector camRot = activeCamera.rotation;
        camRot.y-=delta.x*JoyStickRotateFactor;
		activeCamera.rotation = camRot;
        
	}
    

}
#pragma mark Gesture handling

-(void) startMovingCamera { cameraMoveStartLocation = activeCamera.location; }

-(void) stopMovingCamera {}

/** Set this parameter to adjust the rate of camera movement during a pinch gesture. */


-(void) moveCameraBy:  (CGFloat) aMovement {
    
	// Convert to a logarithmic scale, zero is backwards, one is unity, and above one is forward.
	GLfloat camMoveDist = logf(aMovement) * kCamPinchMovementUnit;
    
	CC3Vector moveVector = CC3VectorScaleUniform(activeCamera.globalForwardDirection, camMoveDist);
	activeCamera.location = CC3VectorAdd(cameraMoveStartLocation, moveVector);
}

-(void) startPanningCamera { cameraPanStartRotation = activeCamera.rotation; }

-(void) stopPanningCamera {}


-(void) panCameraBy:  (CGPoint) aMovement {
	CC3Vector camRot = cameraPanStartRotation;
	CGPoint panRot = ccpMult(aMovement, CameraRotateFactor);		// Full pan swipe is 90 degrees
	camRot.y += panRot.x;
	camRot.x -= panRot.y;
	activeCamera.rotation = camRot;
}

-(void) startDraggingAt: (CGPoint) touchPoint { [self pickNodeFromTapAt: touchPoint]; }

-(void) dragBy: (CGPoint) aMovement atVelocity: (CGPoint) aVelocity {
    [self rotate: ((SpinningNode*)selectedNode) fromSwipeVelocity: aVelocity];
	//if (selectedNode == dieCube || selectedNode == texCubeSpinner) {
	//	[self rotate: ((SpinningNode*)selectedNode) fromSwipeVelocity: aVelocity];
	//}
}
-(void) stopDragging {
    return;
}
-(void)startSquareMovingCamera{
    cameraMoveStartLocation=activeCamera.location;
    
}


-(void)squareMoveCamera:(CGPoint)velocity{
    CC3Vector camLoc=activeCamera.location;
    CGPoint movement=ccpMult(velocity, SqureMoveVelocityFactor);
    CC3Vector moveVector= CC3VectorScaleUniform(activeCamera.globalRightDirection, (0.0-movement.x));
    moveVector.y+=movement.y;
   
    activeCamera.location=CC3VectorAdd(camLoc, moveVector);

}
-(void)stopSquareMovingCamera{
    
}




/**
 * Unproject the 2D touch point into a 3D global-coordinate ray running from
 * the camera through the touched node. Find the node that is punctured by the
 * ray, the location at which the ray punctures the node's bounding volume
 * in the local coordinates of the node, and add a temporary visible marker
 * at that local location that fades in and out, and then removes itself.
 */
-(void) markTouchPoint: (CGPoint) touchPoint on: (CC3Node*) aNode {
    
	if (!aNode) {
		LogInfo(@"You selected no node.");
		return;
	}
    
    NSLog(@"Node %@ is selected",aNode.name);
    
	// Get the location where the node was touched, in its local coordinates.
	// Normally, in this case, you would invoke nodesIntersectedByGlobalRay:
	// on the touched node, not on this CC3Scene. We do so here, to show that
	// all of the nodes under the ray will be detected, not just the touched node.
	CC3Ray touchRay = [self.activeCamera unprojectPoint: touchPoint];
	CC3NodePuncturingVisitor* puncturedNodes = [self nodesIntersectedByGlobalRay: touchRay];
	
	// The reported touched node may be a parent. We want to find the descendant node that
	// was actually pierced by the touch ray, so that we can attached a descriptor to it.
	CC3Node* localNode = puncturedNodes.closestPuncturedNode;
	CC3Vector nodeTouchLoc = puncturedNodes.closestPunctureLocation;
    
	// Create a descriptor node to display the location on the node
	NSString* touchLocStr = [NSString stringWithFormat: @"(%.1f, %.1f, %.1f)", nodeTouchLoc.x, nodeTouchLoc.y, nodeTouchLoc.z];
	CCLabelTTF* dnLabel = [CCLabelTTF labelWithString: touchLocStr
											 fontName: @"Arial"
											 fontSize: 8];
	CC3Node* dn = [CC3NodeDescriptor nodeWithName: [NSString stringWithFormat: @"%@-TP", localNode.name]
									withBillboard: dnLabel];
	//dn.color = localNode.initialDescriptorColor;
//    
	// Use actions to fade the descriptor node in and then out, and remove it when done.
	CCActionInterval* fadeIn = [CCFadeIn actionWithDuration: 0.3];
	CCActionInterval* fadeOut = [CCFadeOut actionWithDuration: 5.0];
	CCActionInstant* remove = [CCCallFunc actionWithTarget: dn selector: @selector(remove)];
	[dn runAction: [CCSequence actions: fadeIn, fadeOut, remove, nil]];
	
	// Set the location of the descriptor node to the touch location,
	// which are in the touched node's local coordinates, and add the
	// descriptor node to the touched node.
	dn.location = nodeTouchLoc;
	[localNode addChild: dn];
    
	// Log everything that happened.
	NSMutableString* desc = [NSMutableString stringWithCapacity: 500];
	[desc appendFormat: @"You selected %@", aNode];
	[desc appendFormat: @" located at %@", NSStringFromCC3Vector(aNode.globalLocation)];
	[desc appendFormat: @", or at %@ in 2D.", NSStringFromCC3Vector([activeCamera projectNode: aNode])];
	[desc appendFormat: @"\nThe actual node touched was %@", localNode];
	[desc appendFormat: @" at %@ on its boundary", NSStringFromCC3Vector(nodeTouchLoc)];
	[desc appendFormat: @" (%@ globally).", NSStringFromCC3Vector(puncturedNodes.closestGlobalPunctureLocation)];
	[desc appendFormat: @"\nThe nodes punctured by the ray %@ were:", NSStringFromCC3Ray(touchRay)];
	NSUInteger puncturedNodeCount = puncturedNodes.nodeCount;
	for (NSUInteger i = 0; i < puncturedNodeCount; i++) {
		[desc appendFormat: @"\n\t%@", [puncturedNodes puncturedNodeAt: i]];
		[desc appendFormat: @" at %@ on its boundary.", NSStringFromCC3Vector([puncturedNodes punctureLocationAt: i])];
		[desc appendFormat: @" (%@ globally).", NSStringFromCC3Vector([puncturedNodes globalPunctureLocationAt: i])];
	}
	LogInfo(@"%@", desc);
}

/** Set this parameter to adjust the rate of rotation from the length of swipe gesture. */
#define kSwipeVelocityScale		400

/**
 * Rotates the specified spinning node by setting its rotation axis
 * and spin speed from the specified 2D drag velocity.
 */
-(void) rotate: (SpinningNode*) aNode fromSwipeVelocity: (CGPoint) swipeVelocity {
	
	// The 2D rotation axis is perpendicular to the drag velocity.
	CGPoint axis2d = ccpPerp(swipeVelocity);
	
	// Project the 2D rotation axis into a 3D axis by mapping the 2D X & Y screen
	// coords to the camera's rightDirection and upDirection, respectively.
	CC3Camera* cam = self.activeCamera;
	aNode.spinAxis = CC3VectorAdd(CC3VectorScaleUniform(cam.rightDirection, axis2d.x),
								  CC3VectorScaleUniform(cam.upDirection, axis2d.y));
    
	// Set the spin speed from the scaled drag velocity.
	aNode.spinSpeed = ccpLength(swipeVelocity) * kSwipeVelocityScale;
    
	// Mark the spinning node as free-wheeling, so that it will start spinning.
	aNode.isFreeWheeling = YES;
}


/** Set this parameter to adjust the rate of rotation from the length of touch-move swipe. */
#define kSwipeScale 0.6

/**
 * Rotates the specified node, by determining the direction of each touch move event.
 *
 * The touch-move swipe is measured in 2D screen coordinates, which are mapped to
 * 3D coordinates by recognizing that the screen's X-coordinate maps to the camera's
 * rightDirection vector, and the screen's Y-coordinates maps to the camera's upDirection.
 *
 * The node rotates around an axis perpendicular to the swipe. The rotation angle is
 * determined by the length of the touch-move swipe.
 *
 * To allow freewheeling after the finger is lifted, we set the spin speed and spin axis
 * in the node. We indicate for now that the node is not freewheeling.
 */
-(void) rotate: (SpinningNode*) aNode fromSwipeAt: (CGPoint) touchPoint interval: (ccTime) dt {
	
	CC3Camera* cam = self.activeCamera;
    
	// Get the direction and length of the movement since the last touch move event, in
	// 2D screen coordinates. The 2D rotation axis is perpendicular to this movement.
	CGPoint swipe2d = ccpSub(touchPoint, lastTouchEventPoint);
	CGPoint axis2d = ccpPerp(swipe2d);
	
	// Project the 2D axis into a 3D axis by mapping the 2D X & Y screen coords
	// to the camera's rightDirection and upDirection, respectively.
	CC3Vector axis = CC3VectorAdd(CC3VectorScaleUniform(cam.rightDirection, axis2d.x),
								  CC3VectorScaleUniform(cam.upDirection, axis2d.y));
	GLfloat angle = ccpLength(swipe2d) * kSwipeScale;
    
	// Rotate the cube under direct finger control, by directly rotating by the angle
	// and axis determined by the swipe. If the die cube is just to be directly controlled
	// by finger movement, and is not to freewheel, this is all we have to do.
	[aNode rotateByAngle: angle aroundAxis: axis];
    
	// To allow the cube to freewheel after lifting the finger, have the cube remember
	// the spin axis and spin speed. The spin speed is based on the angle rotated on
	// this event and the interval of time since the last event. Also mark that the
	// die cube is not freewheeling until the finger is lifted.
	aNode.isFreeWheeling = NO;
	aNode.spinAxis = axis;
	aNode.spinSpeed = angle / dt;
}



#pragma mark private messsages

-(void)loadPodFilesFromIndexFiles{
    NSString*filePaht=[[NSBundle mainBundle] pathForResource:@"PodIndex" ofType:@"xml"];
    NSData*data=[NSData dataWithContentsOfFile:filePaht];
    PodIndexParser*parser=[[PodIndexParser alloc]init];
    PodIndex*pdIndex=[parser parse:data];
    [parser release];
    
    for(Pod*pd in pdIndex.podArray){
        [self loadPod:pd];
       
    }
}
-(void)loadPod:(Pod*)pod{
    if ([PodTypeResource isEqualToString:pod.type]) {
        [self loadResourceFilePod:pod];
        return;
    }
    
    if ([PodTypeCodeCreated isEqualToString:pod.type]) {
        [self loadCodeCreatedPod:pod];
    }

}

-(void)loadResourceFilePod:(Pod*)pod{
    NSString*podName=pod.fileName;
    //NSString* podPath=[PathUtility podFilePath:podName];
    NSString*podPath=[[NSBundle mainBundle] pathForResource:podName ofType:nil];
    CC3PODResourceNode*podNode=[CC3PODResourceNode nodeFromFile:podPath];
    if (0==[pod.nodeArray count]) {
        [Cocos3dUtility touchEnableWhoeNodeTree:podNode];
        podNode.isTouchEnabled=NO;
        if ([YesValue isEqualToString:pod.collided]) {
            [meshNodeArray addObject:podNode];
        }
        [self addChild:podNode];
        return;
    }
    else{
    
        for (Node* nd in pod.nodeArray) {
            CC3Node*c3Node=[self cc3Node:nd];
            [self addChild:c3Node];
            if ([NodeTypeFloor isEqualToString:nd.type]) {
                [floorNodeArray addObject:c3Node];
            }
        }
    }

}
-(void)loadCodeCreatedPod:(Pod*)pod{
    NSAssert([PodTypeCodeCreated isEqualToString:pod.type], @"Not the CodeCreated Pod");
    for (Node*nd in pod.nodeArray) {
        CC3Node*c3Node=[self cc3Node:nd];
        [self addChild:c3Node];
    }
}

-(CC3Node*)cc3Node:(Node*)node{
    NSAssert([node.name length]>0,@"node name should not be nil");
    CC3Node*resultNode=nil;
    if ([NodeTypeFloor isEqualToString:node.type]) {
        resultNode=[CC3MeshNode nodeWithName:node.name];
    }
    if ([NodeTypeCamara isEqualToString:node.type]) {
        //resultNode=self.c
        resultNode=[[CC3Camera alloc]initWithName:node.name];
    }
    
    if ([NodeTypeLight isEqualToString:node.type]) {
        resultNode=[CC3Light nodeWithName:node.name];
    }
    
    //CC3Node*c3node=[CC3Node nodeWithName:node.name];
    [self modifyNodeC3NodePosition:resultNode nodeInfo:node];
    return  resultNode;

}
-(void)modifyNodeC3NodePosition:(CC3Node*)c3node nodeInfo:(Node*)node{
    if ([node.xPosition length]>0&&[node.yPosition length]>0&&[node.zPosition length]>0) {
    
        CGFloat xValue=[node.xPosition floatValue];
        CGFloat yValue=[node.yPosition floatValue];
        CGFloat zValue=[node.zPosition floatValue];
        c3node.location=CC3VectorMake(xValue, yValue, zValue);
        return;
    }
}

-(void)addPlaneNode{

    
    CC3PlaneNode*pn=[CC3PlaneNode nodeWithName:@"PlaneNode"];
    pn.color=ccBLUE;
    pn.location=CC3VectorMake(0, 0, 0);
    pn.rotation=CC3VectorMake(0, 90, 0);
    //[self addChild:pn];
    
    [pn populateAsCenteredRectangleWithSize:CGSizeMake(90, 90)];
    
    [meshNodeArray addObject:pn];
    [floorNodeArray addObject:pn];
    
}

-(void)addGroupNodePodTestFile{
    CC3PODResourceNode*podNode=[CC3PODResourceNode nodeFromFile:GroupPodFileName];
    //podNode.isTouchEnabled=YES;
    
    
    CC3Node*rootNode=[podNode getNodeNamed:RootGroupNodeName];
    rootNode.isTouchEnabled=YES;
    NSLog(@"root bounding boxi is %@",NSStringFromCC3BoundingBox(rootNode.boundingBox));
    NSLog(@"root child cound is %i",[rootNode.children count]);
    
    
    rootNode=[podNode getMeshNodeNamed:StoneNodeName];
    rootNode.isTouchEnabled=YES;
    [self addChild:rootNode];
    
    rootNode=[podNode getMeshNodeNamed:DeclineFloorNodeName];
    rootNode.isTouchEnabled=YES;
    [self addChild:rootNode];
    
    rootNode=[podNode getMeshNodeNamed:FooterStoneNodeName];
    //rootNode.location=CC3VectorMake(0, -20, 0);
   // rootNode.rotation=CC3VectorMake(0, 0, 0);
    //rootNode.scale=CC3VectorMake(5,5, 5);
    
    rootNode.isTouchEnabled=YES;
    [self addChild:rootNode];
}




-(void)addRealHousePod0702{
 
    //CC3PODResourceNode*podNode=[CC3PODResourceNode nodeFromFile:@"123.pod"];
    CC3PODResourceNode*podNode=[CC3PODResourceNode nodeFromFile:AAPodFileName];
    [Cocos3dUtility touchEnableWhoeNodeTree:podNode];
    podNode.isTouchEnabled=NO;
    [meshNodeArray addObject:podNode];
    
    [self addChild:podNode];


    CC3Node*realPodNode=[podNode.children objectAtIndex:0];
    CC3Node*flr2Node=[podNode getNodeNamed:Floor2];
    [realPodNode removeChild:flr2Node];
    [self removeChild:flr2Node];
    CC3Node*flr1Node=[podNode getNodeNamed:Floor1];
    [realPodNode removeChild:flr1Node];
    [self removeChild:flr1Node];

    
    [self addFloorNode];
}

-(void)addTinghua0707Pod{
    
    
    CC3PODResourceNode*podNode=[CC3PODResourceNode nodeFromFile:@"House0709_4.pod"];
    podNode.opacity=254;
    [Cocos3dUtility touchEnableWhoeNodeTree:podNode];
    podNode.isTouchEnabled=NO;
    [meshNodeArray addObject:podNode];
    [self addChild:podNode];
    
    CC3PODResourceNode*kPodNode=[CC3PODResourceNode nodeFromFile:@"kuang0709_4.pod"];
    [Cocos3dUtility touchEnableWhoeNodeTree:kPodNode];
    //    podNode.isTouchEnabled=NO;
    [meshNodeArray addObject:kPodNode];
    [self addChild:kPodNode];
    
    CC3PODResourceNode*treePodNode=[CC3PODResourceNode nodeFromFile:@"Tree0709.pod"];
    [Cocos3dUtility touchEnableWhoeNodeTree:treePodNode];
    treePodNode.isTouchEnabled=NO;
    treePodNode.opacity=254;
    [meshNodeArray addObject:treePodNode];
    [self addChild:treePodNode];
    
    CC3PODResourceNode*floorPodNode=[CC3PODResourceNode nodeFromFile:@"Floor0709_2.pod"];
    CC3Node*flr2Node=[floorPodNode getNodeNamed:@"Floor_2"];
    [floorNodeArray addObject:flr2Node];
    [self addChild:flr2Node];
    
    CC3Node*flr1Node=[floorPodNode getNodeNamed:@"Floor_1"];
    [floorNodeArray addObject:flr1Node];
    [self addChild:flr1Node];
    
    CC3PODResourceNode*skyNode=[CC3PODResourceNode nodeFromFile:@"Sky0708.pod"];
    [self addChild:skyNode];
    

}
#define FloorPodName @"Floor.pod"
-(void)addFloorNode{
    CC3PODResourceNode*podNode=[CC3PODResourceNode nodeFromFile:@"123.pod"];
    NSAssert(nil!=podNode,@"floor pod node should not be nil");
    
    CC3MeshNode*floor2Node=[podNode getMeshNodeNamed:Floor2];
    [floorNodeArray addObject:floor2Node];
    [self addChild:floor2Node];
    
    CC3Node*floor1Node=[podNode getNodeNamed:Floor1];
    [floorNodeArray addObject:floor1Node];
    
    [self addChild:floor1Node];
    


}

-(void)addBoxNode{
    
    CC3PODResourceNode*rezNode = [CC3PODResourceNode nodeFromFile: kMascotPODFile];
    rezNode.isTouchEnabled=YES;
    
	CC3Node *aNode = [rezNode getNodeNamed: kMascotName];
    headNode=(CC3MeshNode*)aNode;
    [headNode retain];
    
    aNode.isTouchEnabled=YES;
	[aNode remove];
	aNode.name = @"Head";
    //aNode.location=CC3VectorMake(10, 100, 100);
    [self addChild:aNode];
/*
    CC3PODMesh*podMesh=(CC3PODMesh*)headNode.mesh;
    CC3VertexIndices*vid=podMesh.vertexIndices;
    
    for (NSInteger meshIndex=0; meshIndex<vid.faceCount; meshIndex++) {
        CC3FaceIndices face=[vid faceIndicesAt:meshIndex];
        CC3VertexLocations*locals=podMesh.vertexLocations;
        CC3Vector v1=[locals locationAt:face.vertices[0]];
        CC3Vector v2=[locals locationAt:face.vertices[1]];
        CC3Vector v3=[locals locationAt:face.vertices[2]];
    }
 */
}

-(void)addSkyboxNode{
    CC3PODResourceNode*rezNode = [CC3PODResourceNode nodeFromFile: SkyBoxPODFile];
   
    
    //rezNode.location=CC3VectorMake(0, -100, 0);
    rezNode.isTouchEnabled=NO;
    rezNode.name=@"SkyBox";
	CC3MeshNode *aNode =(CC3MeshNode*) [rezNode getNodeNamed: SkyBoxNodeName];
    
    /*
    CC3PODMesh*podMesh=(CC3PODMesh*)aNode.mesh;
    CC3VertexIndices*vid=podMesh.vertexIndices;
    CC3FaceIndices face=[vid faceIndicesAt:0];

    CC3VertexLocations*locals=podMesh.vertexLocations;
    CC3Vector localVector0=[locals locationAt:face.vertices[0]];
    CC3Vector localVector1=[locals locationAt:face.vertices[1]];
    CC3Vector localVector2=[locals locationAt:face.vertices[2]];
    */
    aNode.isTouchEnabled=YES;
    
	[aNode remove];
	aNode.name = @"SkySphere";
    aNode.location=CC3VectorMake(0, 0, 0);
    [self addChild:aNode];

}

-(void)testIntersectionWithFace{
    CC3Vector start=CC3VectorMake(0, 0, 0);
    CC3Vector end=CC3VectorMake(5, 5, 5);
    
    CC3Vector v1=CC3VectorMake(5, 0, 0);
    CC3Vector v2=CC3VectorMake(0, 5, 0);
    CC3Vector v3=CC3VectorMake(0, 0, 5);
    double r=0;
    
   r=[Cocos3dUtility lineIntersectedWithFace:start end:end vector1:v1 vector2:v2 vector3:v3];
    
}



@end

@implementation CC3Node (CollisionCheck)

-(BOOL)doesIntersectNodeWithDistance:(CC3Node*)otherNode{
    return NO;
}

@end

