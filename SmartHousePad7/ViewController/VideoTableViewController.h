//
//  VideoTableViewController.h
//  SmartHousePad7
//
//  Created by gjt on 13-7-2.
//
//

#import <UIKit/UIKit.h>
@class VideoCategory;

@interface VideoTableViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    @private
    //NSMutableArray*videoNameArray;
    UIPopoverController*videoPopover;
    
}

@property(nonatomic,retain)VideoCategory*videoCategory;


-(void)initVideoData;


@end
