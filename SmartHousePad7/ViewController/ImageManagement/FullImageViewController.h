//
//  FullImageViewController.h
//  SmartHousePad7
//
//  Created by gjt on 13-7-18.
//
//

#import <UIKit/UIKit.h>
@class Photos;
@interface FullImageViewController : UIViewController{
    
}

@property(nonatomic,retain)IBOutlet UIImageView*imageView;
@property(nonatomic,retain)Photos*photos;
@property(nonatomic,assign)NSInteger photoIndex;

@end
