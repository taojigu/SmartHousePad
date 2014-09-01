//
//  FullImageViewController.m
//  SmartHousePad7
//
//  Created by gjt on 13-7-18.
//
//

#import "FullImageViewController.h"
#import "Photos.h"


@interface FullImageViewController ()

@end

@implementation FullImageViewController

@synthesize imageView;
@synthesize photos;
@synthesize photoIndex;

#define PadLandScapeRecct CGSizeMake(1024, 758)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentSizeForViewInPopover=PadLandScapeRecct;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self addRecognizers];
    [self refreshImageInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshImageInfo{

    UIImage*image=[self.photos imageAtIndex:self.photoIndex];
    self.imageView.image=image;
    NSArray*fileNameArray=[self.photos fileNames];
    //self.title=[fileNameArray objectAtIndex:self.photoIndex];
    self.title=[NSString stringWithFormat:@"%i of %i",self.photoIndex+1,[fileNameArray count]];
}

-(void)addRecognizers{
    UISwipeGestureRecognizer*leftRecg=[[UISwipeGestureRecognizer alloc]initWithTarget:self  action:@selector(swipe:)];
    leftRecg.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:leftRecg];
    [leftRecg release];
    
    UISwipeGestureRecognizer*rightRecg=[[UISwipeGestureRecognizer alloc]initWithTarget:self  action:@selector(swipe:)];
    rightRecg.direction=UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:rightRecg];
    [rightRecg release];
    return;
}

#pragma mark -- selector messages

-(void)swipe:(UISwipeGestureRecognizer*)recognizer{
    NSArray*array=[self.photos fileNames];
    NSInteger photoCount=[array count];
    NSInteger indx=-1;
    if(UISwipeGestureRecognizerDirectionRight==recognizer.direction){
        indx=self.photoIndex-1;
    }
    
    if (UISwipeGestureRecognizerDirectionLeft==recognizer.direction) {
        indx=self.photoIndex+1;
    }
    
    if (0<=indx&&photoCount>indx) {
        self.photoIndex=indx;
        [self refreshImageInfo];
    }
}

@end
