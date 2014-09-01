//
//  CC3SceneDelegate.h
//  SmartHousePad7
//
//  Created by gjt on 13-4-8.
//
//

#import <Foundation/Foundation.h>

@class CC3Node;

@protocol CC3SceneDelegate <NSObject>

-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint;

@end
