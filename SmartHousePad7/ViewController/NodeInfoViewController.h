//
//  NodeInfoViewController.h
//  SmartHousePad7
//
//  Created by gjt on 13-4-11.
//
//

#import <UIKit/UIKit.h>

@class Node;
@class Material;

@interface NodeInfoViewController : UIViewController<UIWebViewDelegate>{
    @private

}



@property(nonatomic,retain)IBOutlet UILabel*nameLabel;
@property(nonatomic,retain)IBOutlet UIWebView*webView;
@property(nonatomic,retain)IBOutlet UITextView*introductionTextView;
@property(nonatomic,retain)IBOutlet UIImageView*imageView;
@property(nonatomic,retain)NSString*nodeId;
//@property(nonatomic,retain)Node*node;

@property(nonatomic,retain)Material*material;
@property(nonatomic,retain)Node*node;

@end
