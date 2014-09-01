//
//  ControlUrlSettingViewController.m
//  SmartHousePad7
//
//  Created by gjt on 13-4-14.
//
//

#import "ControlUrlSettingViewController.h"
#import "SystemConfig.h"


#define ControlUrlPlaceHolderText @"请输入控制URL地址"

@interface ControlUrlSettingViewController ()

@end

@implementation ControlUrlSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    textView.delegate=self;
    NSString*urlString=[[NSUserDefaults standardUserDefaults]stringForKey:SampeUrlKey];
    if (0!=[urlString length]) {
        textView.text=urlString;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextViewDelegate messages

- (void)textViewDidEndEditing:(UITextView *)tv{
    [[NSUserDefaults standardUserDefaults]setObject:textView.text forKey:SampeUrlKey];
}

@end
