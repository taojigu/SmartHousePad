//
//  ImageCollectionViewController.m
//  SmartHousePad7
//
//  Created by gjt on 13-7-17.
//
//

#import "ImageCollectionViewController.h"
#import "ImageCell.h"
#import "FullImageViewController.h"

#define ImageCellText @"ImageCell"

@interface ImageCollectionViewController ()

@end

@implementation ImageCollectionViewController

@synthesize imageCollectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentSizeForViewInPopover=CGSizeMake(1024, 748);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addPhotoImportButton];
    // Do any additional setup after loading the view from its nib.
    
    [self.imageCollectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:ImageCellText];
    self.imageCollectionView.scrollEnabled=YES;
    self.imageCollectionView.contentSize=CGSizeMake(1000,1000);
    
    NSMutableArray*rightButtonArray=[[NSMutableArray alloc]init];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self
        action:@selector(addPhoto)];
    
    //[[self navigationItem] setRightBarButtonItem:addButton];
    [rightButtonArray addObject:addButton];
    [addButton release];
    
    UIBarButtonItem*clearButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearPhotos)];
    [rightButtonArray addObject:clearButton];
    [clearButton release];
    
    self.navigationItem.rightBarButtonItems=rightButtonArray;
    [rightButtonArray release];
    
    
    if (myPhotos_ == nil) {
        myPhotos_ = [[Photos alloc] init];
        [myPhotos_ setDelegate:self];
    }
    //[self setDataSource:myPhotos_];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = ImageCellText;
    
    ImageCell *cell = (ImageCell *)[self.imageCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImage*image=[myPhotos_ imageAtIndex:indexPath.row];
    UIImageView*imageView=(UIImageView*)[cell viewWithTag:100];
    imageView.image=image;
    
    return cell;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [myPhotos_ numberOfPhotos];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage*image=[myPhotos_ imageAtIndex:indexPath.row];
    FullImageViewController*fivc=[[FullImageViewController alloc]init];
    fivc.imageView.image=image;
    fivc.photos=myPhotos_;
    fivc.photoIndex=indexPath.row;
    [self.navigationController pushViewController:fivc animated:YES];
    [fivc release];
    
}


#pragma mark -- private messages

-(void)addPhotoImportButton{
    
    
    return;
}

#pragma mark -
#pragma mark Actions


-(void)clearPhotos{
    UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"清空" message:@"确定清空所有当前图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];

}


- (void)addPhoto {
    if (!photoPicker_) {
        photoPicker_ = [[PhotoPickerController alloc] initWithDelegate:self];
    }
    [photoPicker_ show];
}

#pragma mark  -- alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1==buttonIndex) {
        [myPhotos_ clearPhotos];
    }
}

#pragma mark -
#pragma mark PhotosDelegate

- (void)didFinishSave {
    [self.imageCollectionView reloadData];
}
#pragma mark -
#pragma mark PhotoPickerControllerDelegate

- (void)photoPickerController:(PhotoPickerController *)controller didFinishPickingWithImage:(UIImage *)image isFromCamera:(BOOL)isFromCamera {
    //[self showActivityIndicator];
    
    NSString * const key = @"nextNumber";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *nextNumber = [defaults valueForKey:key];
    if ( ! nextNumber ) {
        nextNumber = [NSNumber numberWithInt:1];
    }
    [defaults setObject:[NSNumber numberWithInt:([nextNumber intValue] + 1)] forKey:key];
    
    NSString *name = [NSString stringWithFormat:@"picture-%05i", [nextNumber intValue]];
    
    // Save to the photo album if picture is from the camera.
    [myPhotos_ savePhoto:image withName:name addToPhotoAlbum:isFromCamera];
   
}



@end
