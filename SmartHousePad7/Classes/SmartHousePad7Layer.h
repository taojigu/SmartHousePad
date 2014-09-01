/**
 *  SmartHousePad7Layer.h
 *  SmartHousePad7
 *
 *  Created by gjt on 13-4-1.
 *  Copyright __MyCompanyName__ 2013年. All rights reserved.
 */


#import "CC3Layer.h"


@class Joystick;

/** A sample application-specific CC3Layer subclass. */
@interface SmartHousePad7Layer : CC3Layer {
    
    Joystick* directionJoystick;
	Joystick* locationJoystick;
    BOOL shouldUseGestures;
}

@end
