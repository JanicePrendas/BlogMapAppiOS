//
//  WebViewController.m
//  BlogMapApp
//
//  Created by Janice Prendas on 12/1/19.
//  Copyright © 2019 Janice. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSString *stringUrl = @"http://www.apple.com";
    NSURL *url=[NSURL URLWithString:_stringUrl];
    NSURLRequest *requestUrl=[NSURLRequest requestWithURL:url];
    runOnMainThreadWithoutLocking(^{
        [self.webView loadRequest:requestUrl];
    });
}

void runOnMainThreadWithoutLocking(void (^block)(void)){
    if ([NSThread isMainThread]){
        block();
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@end
