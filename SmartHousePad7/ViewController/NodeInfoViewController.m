//
//  NodeInfoViewController.m
//  SmartHousePad7
//
//  Created by gjt on 13-4-11.
//
//

//#define DefaultControlUrl  @"https://surge.groov.com:9014"

#import "SystemConfig.h"
#import "NodeInfoViewController.h"
#import "Node.h"
#import "Material.h"




@interface NodeInfoViewController ()

@end

@implementation NodeInfoViewController

@synthesize material;
@synthesize webView;
@synthesize nameLabel;
@synthesize introductionTextView;
@synthesize imageView;
@synthesize nodeId;
@synthesize node;
//@synthesize node;

-(void)dealloc{
    [self.node release];
    [self.material release];
    [self.nodeId release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
 
        self.webView.backgroundColor=[UIColor blackColor];
    
        
    }
    return self;
}

#define DefaultControlPageFileName @"DefaultControlPage"
#define LocalHtmlTag 100

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.node=[self.material nodeFromName:self.nodeId];
    self.nameLabel.text=self.node.name;

    self.webView.scalesPageToFit=YES;
    self.webView.hidden=NO;
    
    self.introductionTextView.text=self.node.nodeDescription;
    //NSString*urlString=[[NSUserDefaults standardUserDefaults]stringForKey:nodeData.controlUrl];
    NSString*pathString=[[NSBundle mainBundle] pathForResource:DefaultControlPageFileName ofType:@"html"];

    NSURLRequest*fileRequest=[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pathString]];
    
    
    [self.webView loadRequest:fileRequest];
    //self.webView.tag=LocalHtmlTag;
    self.webView.delegate=self;

    self.imageView.frame=self.webView.bounds;
    [self.webView addSubview:self.imageView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSURL*url=self.webView.request.URL;
    NSString*pathString=url.path;
    NSURL*filePathUrl=url.filePathURL;
    
    NSString*urlString=url.absoluteString;
    //if (![urlString isEqualToString:self.node.controlUrl]) {
    if (nil!=filePathUrl) {
        NSURL* url=[NSURL URLWithString:self.node.controlUrl];
        NSURLRequest*request=[NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];

    }
    
           
   
}

@end
