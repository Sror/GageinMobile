//
//  GGWebVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-21.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGWebVC.h"

@interface GGWebVC ()

@end

@implementation GGWebVC
{
    UIWebView   *_webview;
}

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
	
    _webview = [[UIWebView alloc] initWithFrame:[self viewportAdjsted]];
    _webview.delegate = self;
    _webview.scalesPageToFit = YES;
    [self.view addSubview:_webview];
    
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    DLog(@"webview loading: {%@}", _urlStr);
}

-(void)dealloc
{
    _webview.delegate = nil;
}

#pragma mark - web view delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadingHUD];
}

@end
