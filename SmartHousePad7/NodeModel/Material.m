//
//  Material.m
//  SmartHousePad7
//
//  Created by gjt on 13-5-1.
//
//

#import "Material.h"
#import "Pod.h"
#import "Node.h"

@implementation Material

@synthesize name;
@synthesize podArray;

-(id)init{
    self=[super init];
    NSMutableArray*tmpArray=[[NSMutableArray alloc]init];
    self.podArray=tmpArray;
    [tmpArray release];
    return self;
}

-(void)dealloc{
    
    [self.name release];
    [self.podArray release];
    [super dealloc];
}

-(Node*)nodeFromName:(NSString*)nodeName{
    
    
    if (0==[nodeName length]) {
        return [Node nullNode];
    }
    for (Pod*pod in self.podArray) {
        for (Node*nd in pod.nodeArray) {
            if([nd.nodeId isEqualToString:nodeName]){
                return nd;
            }
        }
    }
    Node*resultNode=[Node nullNode];
    resultNode.name=nodeName;
    
    return resultNode;
    
}



@end
