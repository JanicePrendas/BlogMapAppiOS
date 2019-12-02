//
//  WebViewController.h
//  BlogMapApp
//
//  Created by Janice Prendas on 12/1/19.
//  Copyright © 2019 Janice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property NSString* stringUrl;
//@property (weak, nonatomic) IBOutlet UIWebViewUIWebView *webView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

NS_ASSUME_NONNULL_END
