//
//  GGCompanyUpdateDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyUpdateDetailVC.h"
#import "GGCompanyUpdate.h"

@interface GGCompanyUpdateDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GGCompanyUpdateDetailVC
{
    GGCompanyUpdate *_companyUpdateDetail;
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
    
    [self _callApiGetCompanyUpdateDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setLblTitle:nil];
    [self setIvPhoto:nil];
    [self setLblContent:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}

#pragma mark - UI
-(void)_updateUIWithUpdateDetail
{
    self.lblTitle.text = _companyUpdateDetail.headline;
    self.lblContent.text = _companyUpdateDetail.content;
    
    if (_companyUpdateDetail.content.length <= 0)
    {
        NSURL *url = [NSURL URLWithString:_companyUpdateDetail.url];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        _webView.hidden = NO;
    }
}

#pragma mark - API calls
-(void)_callApiGetCompanyUpdateDetail
{
    [GGSharedAPI getCompanyUpdateDetailWithNewsID:self.newsID callback:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK) {
            _companyUpdateDetail = [parser parseGetCompanyUpdateDetail];
            
            [self _updateUIWithUpdateDetail];
        }
        
    }];
}

#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
