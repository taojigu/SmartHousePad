//
//  LocationDetailPadViewController.m
//  SmartHousePad7
//
//  Created by gjt on 13-7-12.
//
//

#import "LocationDetailPadViewController.h"
#import "LocationInfo.h"

@interface LocationDetailPadViewController ()

@end

@implementation LocationDetailPadViewController

@synthesize request;
@synthesize locationInfo;
@synthesize connection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentSizeForViewInPopover=CGSizeMake(800,600);
    }
    return self;
}

-(void)dealloc{
    
    [self.connection cancel];
    self.connection=nil;
    
    [self.request release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString*urlString=self.locationInfo.urlString;
    //urlString=@"https://auth.alipay.com/login/index.htm"
    NSURL* url=[NSURL URLWithString:urlString];
    
    self.request=[NSURLRequest requestWithURL:url];
    
    wvControlUrl.delegate=self;
    [wvControlUrl loadRequest:self.request];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate messages



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSLog(@"Did start loading: %@ auth:%d", [[self.request URL] absoluteString], _authenticated);
    
    if (!_authenticated) {
        _authenticated = NO;
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        [self retain];
        [self.connection start];
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
    
    [self.connection cancel];
    [self.connection release];
    self.connection=nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _authenticated =NO;
    [self.connection cancel];
    [self.connection release];
    self.connection=nil;
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


@end
