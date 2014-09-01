//
//  ImageCollectionViewController.h
//  SmartHousePad7
//
//  Created by gjt on 13-7-17.
//
//

#import <UIKit/UIKit.h>

#import "PhotoPickerController.h"
#import "Photos.h"

@interface ImageCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,PhotosDelegate,PhotoPickerControllerDelegate>{
    @private
    
    PhotoPickerController *photoPicker_;
    Photos *myPhotos_;
   
}

@property(nonatomic,retain) IBOutlet UICollectionView*imageCollectionView;

@end
