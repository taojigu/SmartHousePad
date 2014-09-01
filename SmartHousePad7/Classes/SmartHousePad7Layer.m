/**
 *  SmartHousePad7Layer.m
 *  SmartHousePad7
 *
 *  Created by gjt on 13-4-1.
 *  Copyright __MyCompanyName__ 2013年. All rights reserved.
 */

#import "SmartHousePad7Layer.h"
#import "SmartHousePad7Scene.h"
#import "CGPointExtension.h"
#import "CC3CC2Extensions.h"

#import "Joystick.h"

/** Parameters for setting up the joystick and button controls */
#define kJoystickThumbFileName			@"JoystickThumb.png"
#define kJoystickSideLength				80.0
#define kJoystickPadding				18//8.0
#define kButtonGrid						40.0
#define kSwitchViewButtonFileName		@"ArrowLeftButton48x48.png"
#define kInvasionButtonFileName			@"GridButton48x48.png"
#define kSunlightButtonFileName			@"SunlightButton48x48.png"
#define kZoomButtonFileName				@"ZoomButton48x48.png"
#define kShadowButtonFileName			@"ShadowButton48x48.png"
#define kShadowButtonLatchedFileName	@"ShadowButtonLatched48x48.png"
#define kButtonRingFileName				@"ButtonRing48x48.png"
#define kButtonShineFileName			@"Shine48x48.png"
#define kGlobeName						@"Globe"
#define kPeakShineOpacity				180
#define kButtonAdornmentScale			1.5
#define kHUDPadding						8


@interface SmartHousePad7Layer (TemplateMethods)

-(void) addJoysticks;
-(void) addSwitchViewButton;
-(void) addInvasionButton;
-(void) addSunlightButton;
-(void) addZoomButton;
-(void) addShadowButton;
-(void) positionLocationJoystick;
-(void) positionButtons;
-(CC3Scene*) makeHUDScene;

@property(nonatomic, readonly) SmartHousePad7Scene* mashUpScene;

@end


@implementation SmartHousePad7Layer


- (void)dealloc {
    [super dealloc];
}


/**
 * Returns the contained CC3Scene, cast into the appropriate type.
 * This is a convenience method to perform automatic casting.
 */
-(SmartHousePad7Scene*) mashUpScene { return (SmartHousePad7Scene*) cc3Scene;
}
/**
 * Override to set up your 2D controls and other initial state.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) initializeControls {

    shouldUseGestures = YES;
	
	// If not using gestures, enable touch event handling for 3D object picking
	self.isTouchEnabled = !shouldUseGestures;
	
	[self addJoysticks];
    self.color=ccWHITE;
    
    
}

/** Creates the two joysticks that control the 3D camera direction and location. */
-(void) addJoysticks {
	CCSprite* jsThumb;
    
	// Change thumb scale if you like smaller or larger controls.
	// Initially, just compensate for Retina display.
	GLfloat thumbScale = CC_CONTENT_SCALE_FACTOR();
    
	// The joystick that controls the player's (camera's) direction
	jsThumb = [CCSprite spriteWithFile: kJoystickThumbFileName];
	jsThumb.scale = thumbScale;
	
	directionJoystick = [Joystick joystickWithThumb: jsThumb
											andSize: CGSizeMake(kJoystickSideLength, kJoystickSideLength)];
	
	// If you want to see the size of the Joystick backdrop, comment out the line above
	// and uncomment the three lines below. This just adds a simple bland colored backdrop
	// to demonstrate that the thumb and backdrop can be any CCNode, but normally you
	// would use a nice graphical CCSprite for the Joystick backdrop.
    // CCLayer* jsBackdrop = [CCLayerColor layerWithColor: ccc4(255, 255, 255, 63)
    // 											 width: kJoystickSideLength height: kJoystickSideLength];
    //	jsBackdrop.isRelativeAnchorPoint = YES;
    //	directionJoystick = [Joystick joystickWithThumb: jsThumb andBackdrop: jsBackdrop];
	
	directionJoystick.position = ccp(kJoystickPadding, kJoystickPadding);
	[self addChild: directionJoystick];
    directionJoystick.visible=NO;
	
	// The joystick that controls the player's (camera's) location
	jsThumb = [CCSprite spriteWithFile: kJoystickThumbFileName];
	jsThumb.scale = thumbScale;
	
	locationJoystick = [Joystick joystickWithThumb: jsThumb
										   andSize: CGSizeMake(kJoystickSideLength, kJoystickSideLength)];
	[self positionLocationJoystick];
	[self addChild: locationJoystick];
}
/**
 * Positions the right-side location joystick at the right of the layer.
 * This is called at initialization, and anytime the content size of the layer changes
 * to keep the joystick in the correct location within the new layer dimensions.
 */
-(void) positionLocationJoystick {
	locationJoystick.position = ccp(self.contentSize.width - kJoystickSideLength - kJoystickPadding, kJoystickPadding);
}

/**
 * Positions the buttons between the two joysticks.
 * This is called at initialization, and anytime the content size of the layer changes
 * to keep the button in the correct location within the new layer dimensions.
 */
-(void) positionButtons {
	GLfloat middle = self.contentSize.width / 2.0;
	GLfloat btnY = (kJoystickPadding * 0.5) + (kButtonGrid * 0.5);
    /*
	shadowMI.position = ccp(middle - (kButtonGrid * 0.5), btnY);
	zoomMI.position = ccp(middle + (kButtonGrid * 0.5), btnY);
    
	btnY += kButtonGrid;
	switchViewMI.position = ccp(middle - (kButtonGrid * 1.0), btnY);
	invasionMI.position = ccp(middle, btnY);
	sunlightMI.position = ccp(middle + (kButtonGrid * 1.0), btnY);
     */
}


#pragma mark Updating layer

/**
 * Updates the player (camera) direction and location from the joystick controls
 * and then updates the 3D scene.
 */
-(void) update: (ccTime)dt {
	
	// Update the player direction and position in the scene from the joystick velocities
	self.mashUpScene.playerDirectionControl = directionJoystick.velocity;
	self.mashUpScene.playerLocationControl = locationJoystick.velocity;
	[super update: dt];
}


/**
 * Override to perform tear-down activity prior to the scene disappearing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onCloseCC3Layer {}

/**
 * The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 * The event dispatcher will not dispatch events for which there is no method
 * implementation. Since the touch-move events are both voluminous and seldom used,
 * the implementation of ccTouchMoved:withEvent: has been left out of the default
 * CC3Layer implementation. To receive and handle touch-move events for object
 * picking, uncomment the following method implementation.
 */
/*
-(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event {
	[self handleTouch: touch ofType: kCCTouchMoved];
}
 */


#pragma mark Gesture support

/**
 * Invoked when this layer is being opened on the view.
 *
 * If we want to use gestures, we add the gesture recognizers here.
 *
 * By using the cc3AddGestureRecognizer: method to add the gesture recognizers,
 * we ensure that they will be torn down when this layer is removed from the view.
 *
 * This layer has child buttons on it. To ensure that those buttons receive their
 * touch events, we set cancelsTouchesInView to NO on the tap gestures recognizer
 * so that that gesture recognizer allows the touch events to propagate to the buttons.
 * We do not need to do that for the other recognizers because we don't want buttons
 * to receive touch events in the middle of a pan or pinch.
 */
-(void) onOpenCC3Layer {
	if ( !shouldUseGestures ) return;
	
	// Register for tap gestures to select 3D nodes.
	// This layer has child buttons on it. To ensure that those buttons receive their
	// touch events, we set cancelsTouchesInView to NO so that the gesture recognizer
	// allows the touch events to propagate to the buttons.
	UITapGestureRecognizer* tapSelector = [[UITapGestureRecognizer alloc]
										   initWithTarget: self action: @selector(handleTapSelection:)];
	tapSelector.numberOfTapsRequired = 1;
	tapSelector.cancelsTouchesInView = NO;		// Ensures touches are passed to buttons
	[self cc3AddGestureRecognizer: tapSelector];
	[tapSelector release];
	
	// Register for single-finger dragging gestures used to spin the two cubes.
	UIPanGestureRecognizer* dragPanner = [[UIPanGestureRecognizer alloc]
										  initWithTarget: self action: @selector(handleCameraPan:)];
	dragPanner.minimumNumberOfTouches = 1;
	dragPanner.maximumNumberOfTouches = 1;
	[self cc3AddGestureRecognizer: dragPanner];
    [dragPanner release];
    
	// Register for double-finger dragging to pan the camera.
	UIPanGestureRecognizer* cameraPanner = [[UIPanGestureRecognizer alloc]
											initWithTarget: self action: @selector(handeleCameraSqureMove:)];
	cameraPanner.minimumNumberOfTouches = 2;
	cameraPanner.maximumNumberOfTouches = 2;
	[self cc3AddGestureRecognizer: cameraPanner];
    [cameraPanner release];
	
	// Register for double-finger dragging to pan the camera.
	UIPinchGestureRecognizer* cameraMover = [[UIPinchGestureRecognizer alloc]
											 initWithTarget: self action: @selector(handleCameraMove:)];
	[self cc3AddGestureRecognizer: cameraMover];
    [cameraMover release];
}

/**
 * This handler is invoked when a single-tap gesture is recognized.
 *
 * If the tap occurs within a descendant CCNode that wants to capture the touch,
 * such as a menu or button, the gesture is cancelled. Otherwise, the tap is
 * forwarded to the CC3Scene to pick the 3D node under the tap.
 */
-(void) handleTapSelection: (UITapGestureRecognizer*) gesture {
    
	// Once the gesture has ended, convert the UI location to a 2D node location and
	// pick the 3D node under that location. Don't forget to test that the gesture is
	// valid and does not conflict with touches handled by this layer or its descendants.
	if ( [self cc3ValidateGesture: gesture] && (gesture.state == UIGestureRecognizerStateEnded) ) {
        
		CGPoint touchPoint = [self cc3ConvertUIPointToNodeSpace: gesture.location];
		[self.mashUpScene pickNodeFromTapAt: touchPoint];
	}
}

/**
 * This handler is invoked when a single-finger drag gesture is recognized.
 *
 * If the drag starts within a descendant CCNode that wants to capture the touch,
 * such as a menu or button, the gesture is cancelled.
 *
 * The CC3Scene marks where dragging begins to determine the node that is underneath
 * the touch point at that time, and is further notified as dragging proceeds.
 * It uses the velocity of the drag to spin the cube nodes. Finally, the scene is
 * notified when the dragging gesture finishes.
 *
 * The dragging movement is normalized to be specified relative to the size of the
 * layer, making it independant of the size of the layer.
 */
-(void) handleDrag: (UIPanGestureRecognizer*) gesture {
	switch (gesture.state) {
		case UIGestureRecognizerStateBegan:
			if ( [self cc3ValidateGesture: gesture] ) {
				[self.mashUpScene startDraggingAt: [self cc3ConvertUIPointToNodeSpace: gesture.location]];
			}
			break;
		case UIGestureRecognizerStateChanged:
			[self.mashUpScene dragBy: [self cc3NormalizeUIMovement: gesture.translation]
						  atVelocity:[self cc3NormalizeUIMovement: gesture.velocity]];
			break;
		case UIGestureRecognizerStateEnded:
			[self.mashUpScene stopDragging];
			break;
		default:
			break;
	}
}



/**
 * This handler is invoked when a double-finger pan gesture is recognized.
 *
 * If the panning starts within a descendant CCNode that wants to capture the touch,
 * such as a menu or button, the gesture is cancelled.
 *
 * The CC3Scene marks the camera orientation when dragging begins, and is notified
 * as dragging proceeds. It uses the relative translation of the panning movement
 * to determine the new orientation of the camera. Finally, the scene is notified
 * when the dragging gesture finishes.
 *
 * The dragging movement is normalized to be specified relative to the size of the
 * layer, making it independant of the size of the layer.
 */
-(void) handleCameraPan: (UIPanGestureRecognizer*) gesture {
	switch (gesture.state) {
		case UIGestureRecognizerStateBegan:
			if ( [self cc3ValidateGesture: gesture] ) [self.mashUpScene startPanningCamera];
			break;
		case UIGestureRecognizerStateChanged:
			[self.mashUpScene panCameraBy: [self cc3NormalizeUIMovement: gesture.translation]];
			break;
		case UIGestureRecognizerStateEnded:
			[self.mashUpScene stopPanningCamera];
			break;
		default:
			break;
	}
}




/**
 * This handler is invoked when a pinch gesture is recognized.
 *
 * If the pinch starts within a descendant CCNode that wants to capture the touch,
 * such as a menu or button, the gesture is cancelled.
 *
 * The CC3Scene marks the camera location when pinching begins, and is notified
 * as pinching proceeds. It uses the relative scale of the pinch gesture to determine
 * a new location for the camera. Finally, the scene is notified when the pinching
 * gesture finishes.
 *
 * Note that the pinching does not zoom the camera, although the visual effect is
 * very similar. For this application, moving the camera is more flexible and useful
 * than zooming. But other application might prefer to use the pinch gesture scale
 * to modify the uniformScale or fieldOfView properties of the camera, to perform
 * a true zooming effect.
 */
-(void) handleCameraMove: (UIPinchGestureRecognizer*) gesture {
    
	switch (gesture.state) {
		case UIGestureRecognizerStateBegan:
			if ( [self cc3ValidateGesture: gesture] ) [self.mashUpScene startMovingCamera];
			break;
		case UIGestureRecognizerStateChanged:
			[self.mashUpScene moveCameraBy: gesture.scale];
			break;
		case UIGestureRecognizerStateEnded:
			[self.mashUpScene stopMovingCamera];
			break;
		default:
			break;
	}
}

-(void)handeleCameraSqureMove:(UIPanGestureRecognizer*)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            if ([self cc3ValidateGesture:gesture]) {
                [self.mashUpScene startSquareMovingCamera];
            }
        case UIGestureRecognizerStateChanged:
            [self.mashUpScene squareMoveCamera:gesture.velocity];
            break;
        case UIGestureRecognizerStateEnded:
            [self.mashUpScene stopSquareMovingCamera];
            break;
        default:
            break;
    }
    
}



@end
