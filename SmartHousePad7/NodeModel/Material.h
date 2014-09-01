//
//  Material.h
//  SmartHousePad7
//
//  Created by gjt on 13-5-1.
//
//

#import <Foundation/Foundation.h>


@class Node;

@interface Material : NSObject{
    
}

@property(nonatomic,retain)NSString*name;
@property(nonatomic,retain)NSMutableArray*podArray;

-(Node*)nodeFromName:(NSString*)nodeName;


@end
