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

@property (weak, nonatomic) IBOutlet UIView *viewUpdate;
@property (weak, nonatomic) IBOutlet UIImageView *ivUpdateBg;
@property (weak, nonatomic) IBOutlet UILabel *lblSource;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UITextView *textView;
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
    self.title = _naviTitle;
    self.view.backgroundColor = GGSharedColor.silver;
    
    //
    UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    CGRect naviRc = self.navigationController.navigationBar.frame;
    prevBtn.frame = CGRectMake(naviRc.size.width - prevBtn.frame.size.width - 50, (naviRc.size.height - prevBtn.frame.size.height) / 2, prevBtn.frame.size.width, prevBtn.frame.size.height);
    [prevBtn addTarget:self action:@selector(prevUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:prevBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    nextBtn.frame = CGRectMake(naviRc.size.width - nextBtn.frame.size.width - 10, (naviRc.size.height - nextBtn.frame.size.height) / 2, nextBtn.frame.size.width, nextBtn.frame.size.height);
    [prevBtn addTarget:self action:@selector(nextUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:nextBtn];
    
    //
    self.scrollView.hidden = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, CGRectGetMaxY(self.viewUpdate.frame) + 10);
    
    self.ivUpdateBg.image = [[UIImage imageNamed:@"shadowedBgWhite.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self _callApiGetCompanyUpdateDetail];
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setLblTitle:nil];
    [self setIvPhoto:nil];
    [self setLblContent:nil];
    [self setWebView:nil];
    [self setLblSource:nil];
    [self setLblDate:nil];
    [self setViewUpdate:nil];
    [self setIvUpdateBg:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}

#pragma mark - Actions
-(void)prevUpdateAction:(id)sender
{
    
}

-(void)nextUpdateAction:(id)sender
{
    
}

#pragma mark - UI
-(void)_updateUIWithUpdateDetail
{
    if (_companyUpdateDetail.textview.length <= 0)
    {
        NSURL *url = [NSURL URLWithString:_companyUpdateDetail.url];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        _webView.hidden = NO;
        [self showLoadingHUD];
    }
    else
    {
        self.lblTitle.text = _companyUpdateDetail.headline;
        self.textView.text = _companyUpdateDetail.textview;
        self.lblSource.text = _companyUpdateDetail.fromSource;
        
        if (_companyUpdateDetail.pictures.count)
        {
            NSString *urlStr = nil;
            for (NSString *str in _companyUpdateDetail.pictures)
            {
                if ([str.lowercaseString rangeOfString:@".gif"].location == NSNotFound
                    && [str.lowercaseString rangeOfString:@"css"].location == NSNotFound
                    && [str.lowercaseString rangeOfString:@"logo"].location == NSNotFound)
                {
                    urlStr = str;
                    break;
                }
            }
        
            if (urlStr.length)
            {
                [self.ivPhoto setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
            }
        }
        self.scrollView.hidden = NO;
    }
}



#pragma mark - API calls
-(void)_callApiGetCompanyUpdateDetail
{
    GGCompanyUpdate *updateData = [self.updates objectAtIndex:_updateIndex];
    [GGSharedAPI getCompanyUpdateDetailWithNewsID:updateData.ID callback:^(id operation, id aResultObject, NSError *anError) {
        
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
    [self hideLoadingHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadingHUD];
}

@end
