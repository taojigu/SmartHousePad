//
//  LocationDetailViewController.h
//  SmartHousePad7
//
//  Created by gjt on 13-7-12.
//
//

#import <UIKit/UIKit.h>

@class LocationInfo;

@interface LocationDetailViewController : UIViewController<UIWebViewDelegate,NSURLConnectionDelegate>{
    @private
    IBOutlet UILabel*labelName;
    IBOutlet UILabel*labelLocation;
    IBOutlet UILabel*labelRotation;
    IBOutlet UITextView*tvUrl;
    IBOutlet UIWebView*wvControlUrl;
    IBOutlet UIImageView*sampleImageView;
    NSURLConnection* _urlConnection;
    BOOL _authenticated;
}

@property(nonatomic,retain)LocationInfo*locationInfo;
@property(nonatomic,retain)NSURLRequest*request;

@end
