//
//  AddLocationViewController.h
//  SmartHousePad7
//
//  Created by gjt on 13-7-11.
//
//

#import <UIKit/UIKit.h>

@class AddLocationViewController;
@class LocationInfo;


@protocol AddLocationViewControllerDelegate <NSObject>

-(void)locationDidAdd:(AddLocationViewController*)viewController location:(LocationInfo*)location;

@end

@interface AddLocationViewController : UIViewController<UITextFieldDelegate>{
    @private
    IBOutlet UITextField*tfName;
    IBOutlet UITextView*tvUrlString;
    
}

@property(nonatomic,assign)id<AddLocationViewControllerDelegate>delegate;
@property(nonatomic,retain)LocationInfo*locationInfo;


-(IBAction)saveButtonClicked:(id)sender;
-(IBAction)cancelButtonClicked:(id)sender;


@end
