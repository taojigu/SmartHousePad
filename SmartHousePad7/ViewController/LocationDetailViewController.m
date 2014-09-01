//
//  LocationDetailViewController.m
//  SmartHousePad7
//
//  Created by gjt on 13-7-12.
//
//

#import "LocationDetailViewController.h"
#import "LocationInfo.h"

#define DefaultControlPageFileName @"DefaultControlPage"
#define LocalHtmlTag 100

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController


@synthesize request;
@synthesize locationInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [self.request release];
    [self.locationInfo release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentSizeForViewInPopover=self.view.frame.size;
    labelName.text=self.locationInfo.locationName;
    labelLocation.text=NSStringFromCC3Vector(self.locationInfo.location);
    labelRotation.text=NSStringFromCC3Vector(self.locationInfo.rotation);
    tvUrl.text=self.locationInfo.urlString;
    self.title=self.locationInfo.locationName;
    wvControlUrl.userInteractionEnabled=YES;
    wvControlUrl.scalesPageToFit=YES;
    wvControlUrl.scrollView.contentSize=CGSizeMake(350, 640);
    
    if ([self.locationInfo.urlString length]!=0) {
        [self startVisitControlPage];
        sampleImageView.hidden=YES;
    }
    
    else{
        tvUrl.text=@"未设置遥控URL";
        sampleImageView.frame=wvControlUrl.bounds;
        wvControlUrl.hidden=YES;
        //[wvControlUrl addSubview:sampleImageView];
        //[self loadLocalPage];
    }
    wvControlUrl.delegate=self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private messages

-(void)startVisitControlPage{
    NSURL* url=[NSURL URLWithString:self.locationInfo.urlString];
    self.request=[NSURLRequest requestWithURL:url];
    
    [wvControlUrl loadRequest:self.request];
}
-(void)loadLocalPage{
    NSString*pathString=[[NSBundle mainBundle] pathForResource:DefaultControlPageFileName ofType:@"html"];
    NSURLRequest*fileRequest=[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pathString]];
    
    [wvControlUrl loadRequest:fileRequest];
}
#pragma mark - UIWebViewDelegate messages



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSLog(@"Did start loading: %@ auth:%d", [[self.request URL] absoluteString], _authenticated);
    
    if (!_authenticated) {
        _authenticated = NO;
        _urlConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        [_urlConnection start];
        return NO;
    }
    return YES;
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if ([challenge previousFailureCount] == 0)
    {
        _authenticated = YES;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    _authenticated =YES;
    [wvControlUrl loadRequest:self.request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

@end
