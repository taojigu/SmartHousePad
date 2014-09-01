//
//  AddLocationViewController.m
//  SmartHousePad7
//
//  Created by gjt on 13-7-11.
//
//

#import "AddLocationViewController.h"
#import "LocationInfo.h"

@interface AddLocationViewController ()

@end

@implementation AddLocationViewController

@synthesize delegate;
@synthesize locationInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentSizeForViewInPopover=CGSizeMake(320, 548);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tfName.delegate=self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selector messages


-(IBAction)saveButtonClicked:(id)sender{
    if ([tfName.text length]==0) {
        tfName.backgroundColor=[UIColor redColor];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.locationInfo.locationName=tfName.text;
    self.locationInfo.urlString=tvUrlString.text;
    [self.delegate locationDidAdd:self location:self.locationInfo];
    return;
}
-(IBAction)cancelButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.backgroundColor=[UIColor whiteColor];
}

@end
