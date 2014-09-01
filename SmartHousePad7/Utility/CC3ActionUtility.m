//
//  CC3ActionUtility.m
//  SmartHousePad7
//
//  Created by gjt on 13-6-2.
//
//

#import "CC3ActionUtility.h"

#import "CC3Node.h"
#import "CC3ActionInterval.h"

@implementation CC3ActionUtility

+(void)actionChangeColor:(CC3Node*)node{
    
    GLfloat tintTime = 1.0f;
	ccColor3B startColor = node.color;
	ccColor3B endColor = { 50, 0, 200 };
	CCActionInterval* tintDown = [CCTintTo actionWithDuration: tintTime
														  red: endColor.r
														green: endColor.g
														 blue: endColor.b];
	CCActionInterval* tintUp = [CCTintTo actionWithDuration: tintTime
														red: startColor.r
													  green: startColor.g
													   blue: startColor.b];
    CCActionInterval* tintCycle = [CCSequence actionOne: tintDown two: tintUp];
	[node runAction: [CCRepeatForever actionWithAction: tintCycle]];
    
}

@end
