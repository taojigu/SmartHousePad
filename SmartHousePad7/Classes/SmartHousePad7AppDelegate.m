/**
 *  SmartHousePad7AppDelegate.m
 *  SmartHousePad7
 *
 *  Created by gjt on 13-4-1.
 *  Copyright __MyCompanyName__ 2013年. All rights reserved.
 */

#import "SmartHousePad7AppDelegate.h"
#import "SmartHousePad7Layer.h"
#import "SmartHousePad7Scene.h"
#import "CC3EAGLView.h"

#import "MaterialParser.h"
#import "Material.h"
#import "Node.h"

#define UserAgentKey @"UserAgent"
//#define UserAgentValue @"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"
#define UserAgentValue @"Mozilla/5.0 (iPhone; CPU iPhone OS 6_0_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25"

#define kAnimationFrameRate		60		// Animation frame rate

@implementation SmartHousePad7AppDelegate {
	UIWindow *window;
	CC3DeviceCameraOverlayUIViewController *viewController;

}

-(void) dealloc {
	[window release];
	[viewController release];
	[super dealloc];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return UIInterfaceOrientationMaskAll;
}

-(void) applicationDidFinishLaunching: (UIApplication*) application {

    //[self loadNodeResourceXml];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:UserAgentValue, UserAgentKey, nil];
    //[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    //NSLog(@"The user agent is %@",UserAgentValue);


	// Establish the type of CCDirector to use.
	// Try to use CADisplayLink director and if it fails (SDK < 3.1) use the default director.
	// This must be the first thing we do and must be done before establishing view controller.
	if( ! [CCDirector setDirectorType: kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType: kCCDirectorTypeDefault];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images.
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565. You can change anytime.
	CCTexture2D.defaultAlphaPixelFormat = kCCTexture2DPixelFormat_RGBA8888;
	
	// Create the view controller for the 3D view.
	viewController = [CC3DeviceCameraOverlayUIViewController new];
	viewController.supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
    viewController.material=material;
	
	// Create the CCDirector, set the frame rate, and attach the view.
	CCDirector *director = CCDirector.sharedDirector;
	
	director.animationInterval = (1.0f / kAnimationFrameRate);
	director.displayFPS = YES;
	director.openGLView = viewController.view;
	
	// Enables High Res mode on Retina Displays and maintains low res on all other devices
	// This must be done after the GL view is assigned to the director!
	[director enableRetinaDisplay: YES];
    
	
	// Create the window, make the controller (and its view) the root of the window, and present the window
	window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
   // mainScene.sceneDelegate=viewController;
    viewController.title=@"O-House(V1.1)";
    UINavigationController*rootNavi=[[UINavigationController alloc]initWithRootViewController:viewController];
	//[window addSubview: viewController.view];
	window.rootViewController = rootNavi;
    [rootNavi release];
	[window makeKeyAndVisible];
	
	// Set to YES for Augmented Reality 3D overlay on device camera.
	// This must be done after the window is made visible!
//	viewController.isOverlayingDeviceCamera = YES;

	
	// ******** START OF COCOS3D SETUP CODE... ********
	
	// Create the customized CC3Layer that supports 3D rendering and schedule it for automatic updates.
    SmartHousePad7Scene*mainScene=[SmartHousePad7Scene scene];
	CC3Layer* cc3Layer = [SmartHousePad7Layer node];
	[cc3Layer scheduleUpdate];
	
	// Create the customized 3D scene and attach it to the layer.
	// Could also just create this inside the customer layer.
	cc3Layer.cc3Scene = mainScene;//[SmartHousePad7Scene scene];
	
	// Assign to a generic variable so we can uncomment options below to play with the capabilities
	CC3ControllableLayer* mainLayer = cc3Layer;
	
	// The 3D layer can run either directly in the scene, or it can run as a smaller "sub-window"
	// within any standard CCLayer. So you can have a mostly 2D window, with a smaller 3D window
	// embedded in it. To experiment with this smaller embedded 3D window, uncomment the following lines:
//	CGSize winSize = CCDirector.sharedDirector.winSize;
//	cc3Layer.position = ccp(30.0, 30.0);
//	cc3Layer.contentSize = CGSizeMake(winSize.width - 100.0, winSize.width - 40.0);
//	cc3Layer.alignContentSizeWithDeviceOrientation = YES;
//	mainLayer = [CC3ControllableLayer node];
//	[mainLayer addChild: cc3Layer];
	
	// A smaller 3D layer can even be moved around on the screen dyanmically. To see this in action,
	// uncomment the lines above as described, and also uncomment the following two lines.
//	cc3Layer.position = ccp(0.0, 0.0);
//	[cc3Layer runAction: [CCMoveTo actionWithDuration: 15.0 position: ccp(500.0, 250.0)]];
	
	// Attach the layer to the controller and run a scene with it.
	[viewController runSceneOnNode: mainLayer];
    viewController.mainCC3Scene=mainScene;
    mainScene.sceneDelegate=viewController;
}

/** Resume the cocos3d/cocos2d action. */
-(void) resumeApp { [CCDirector.sharedDirector resume]; }

-(void) applicationDidBecomeActive: (UIApplication*) application {
	
	// Workaround to fix the issue of drop to 40fps on iOS4.X on app resume.
	// Adds short delay before resuming the app.
	[NSTimer scheduledTimerWithTimeInterval: 0.5f
									 target: self
								   selector: @selector(resumeApp)
								   userInfo: nil
									repeats: NO];
	
	// If dropping to 40fps is not an issue, remove above, and uncomment the following to avoid delay.
//	[self resumeApp];
}

-(void) applicationDidReceiveMemoryWarning: (UIApplication*) application {
	[CCDirector.sharedDirector purgeCachedData];
}

-(void) applicationDidEnterBackground: (UIApplication*) application {
	[CCDirector.sharedDirector stopAnimation];
}

-(void) applicationWillEnterForeground: (UIApplication*) application {
	[CCDirector.sharedDirector startAnimation];
}

-(void)applicationWillTerminate: (UIApplication*) application {
	[CCDirector.sharedDirector.openGLView removeFromSuperview];
	[CCDirector.sharedDirector end];
}

-(void) applicationSignificantTimeChange: (UIApplication*) application {
	[CCDirector.sharedDirector setNextDeltaTimeZero: YES];
}

#pragma mark NodeResource XML

#define NodeResourceXmlName @"Material"

-(void)loadNodeResourceXml{
    
    
    NSString*pathString=[[NSBundle mainBundle] pathForResource:NodeResourceXmlName ofType:@"xml"];
    NSData*data=[NSData dataWithContentsOfFile:pathString];
    NSAssert(nil!=data, @"no node xml data");
    MaterialParser*parser=[[MaterialParser alloc]init];
    material=[parser parse:data];
    [parser release];
    
}

@end
