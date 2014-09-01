//
//  LocationViewController.h
//  SmartHousePad7
//
//  Created by gjt on 13-7-11.
//
//

#import <UIKit/UIKit.h>
@class CC3Scene;
#import "AddLocationViewController.h"

@interface LocationViewController : UITableViewController<AddLocationViewControllerDelegate>{
    
}

@property(nonatomic,retain)NSMutableArray*locationArray;
@property(nonatomic,retain)CC3Scene*mainCC3Scene;

@end
