//
//  LocationDetailPadViewController.h
//  SmartHousePad7
//
//  Created by gjt on 13-7-12.
//
//

#import <UIKit/UIKit.h>

@class LocationInfo;

@interface LocationDetailPadViewController : UIViewController<NSURLConnectionDelegate,UIWebViewDelegate>{
    @private
    

    IBOutlet UIWebView*wvControlUrl;
    //NSURLConnection* _urlConnection;
    BOOL _authenticated;
}

@property(nonatomic,retain)NSURLRequest*request;
@property(nonatomic,retain)NSURLConnection*connection;

@property(nonatomic,retain)LocationInfo*locationInfo;


@end
