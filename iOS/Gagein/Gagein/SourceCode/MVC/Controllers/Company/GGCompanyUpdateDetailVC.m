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
@property (weak, nonatomic) IBOutlet UIWebView *wvTextView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GGCompanyUpdateDetailVC
{
    GGCompanyUpdate *_companyUpdateDetail;
    UIButton *_btnPrevUpdate;
    UIButton *_btnNextUpdate;
    CGRect  _originalTextViewFrame;
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
    _btnPrevUpdate = [UIButton buttonWithType:UIButtonTypeInfoLight];
    //prevBtn.tag = 20001;
    CGRect naviRc = self.navigationController.navigationBar.frame;
    _btnPrevUpdate.frame = CGRectMake(naviRc.size.width - _btnPrevUpdate.frame.size.width - 50
                                      , (naviRc.size.height - _btnPrevUpdate.frame.size.height) / 2
                                      , _btnPrevUpdate.frame.size.width
                                      , _btnPrevUpdate.frame.size.height);
    [_btnPrevUpdate addTarget:self action:@selector(prevUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btnNextUpdate = [UIButton buttonWithType:UIButtonTypeInfoLight];
    //nextBtn.tag = 20002;
    _btnNextUpdate.frame = CGRectMake(naviRc.size.width - _btnNextUpdate.frame.size.width - 10
                                      , (naviRc.size.height - _btnNextUpdate.frame.size.height) / 2
                                      , _btnNextUpdate.frame.size.width
                                      , _btnNextUpdate.frame.size.height);
    [_btnNextUpdate addTarget:self action:@selector(nextUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //
    _originalTextViewFrame = self.wvTextView.frame;
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
    [self setWvTextView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:_btnPrevUpdate];
    [self.navigationController.navigationBar addSubview:_btnNextUpdate];
    [self _updateNaviBtnState];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_btnPrevUpdate removeFromSuperview];
    [_btnNextUpdate removeFromSuperview];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Actions
-(IBAction)sendMailAction:(id)sender
{
    if (![MFMailComposeViewController canSendMail])
    {
        [GGAlert alert:@"Sorry, You can't send email on this device."];
        return;
    }
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:_companyUpdateDetail.headline];
    if (_companyUpdateDetail.textview.length)
    {
        [controller setMessageBody:_companyUpdateDetail.textview isHTML:YES];
    }
    else
    {
        [controller setMessageBody:[NSString stringWithFormat:@"<div><a href=\"%@\"> See Detail </a></div>", _companyUpdateDetail.url] isHTML:YES];
    }
    
    [self presentModalViewController:controller animated:YES];

}


-(IBAction)saveAction:(id)sender
{
    GGCompanyUpdate *data = _updates[_updateIndex];
    if (data.saved)
    {
        [GGSharedAPI unsaveUpdateWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                data.saved = NO;
                [GGAlert alert:@"unsaved!"];
            }
            else
            {
                [GGAlert alert:parser.message];
            }
        }];
    }
    else
    {
        [GGSharedAPI saveUpdateWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                data.saved = YES;
                [GGAlert alert:@"saved!"];
            }
            else
            {
                [GGAlert alert:parser.message];
            }
        }];
    }
}

-(void)prevUpdateAction:(id)sender
{
    if (_updateIndex > 0) {
        _updateIndex--;
        [self _callApiGetCompanyUpdateDetail];
        
        [self _updateNaviBtnState];
    }
}

-(void)nextUpdateAction:(id)sender
{
    if (_updateIndex < _updates.count - 1) {
        _updateIndex++;
        [self _callApiGetCompanyUpdateDetail];
        
        [self _updateNaviBtnState];
    }
}

-(void)_updateNaviBtnState
{
    _btnPrevUpdate.enabled = (_updateIndex > 0);
    _btnNextUpdate.enabled = (_updateIndex < _updates.count - 1);
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
        [_webView loadHTMLString:@"" baseURL:nil];
        _webView.hidden = YES;
        self.lblTitle.text = _companyUpdateDetail.headline;

        [self.wvTextView loadHTMLString:_companyUpdateDetail.textview baseURL:nil];
        self.lblSource.text = ((GGCompanyUpdate *)(_updates[_updateIndex])).fromSource;
        
        NSString *urlStr = nil;
        if (_companyUpdateDetail.pictures.count)
        {
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
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
                activityIndicator.hidesWhenStopped = YES;
                activityIndicator.hidden = NO;
                [activityIndicator startAnimating];
                activityIndicator.center = CGPointMake(self.ivPhoto.frame.size.width / 2, self.ivPhoto.frame.size.height / 2);
                [self.ivPhoto addSubview:activityIndicator];
                
                UIImage *placeholderImage = GGSharedImagePool.placeholder;
                //[self.ivPhoto setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholderImage];
                [self.ivPhoto setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    [activityIndicator stopAnimating];
                    [activityIndicator removeFromSuperview];
                }];
            }
        }
        
        [self _adjustLayoutHasImage:(urlStr.length)];
        self.ivPhoto.hidden = (urlStr.length <= 0);
        self.scrollView.hidden = NO;
    }
}


-(void)_adjustLayoutHasImage:(BOOL)aHasImage
{
    if (!aHasImage)
    {
        CGRect longRect = _originalTextViewFrame;
        float offsetY = _originalTextViewFrame.origin.y - self.ivPhoto.frame.origin.y;
        longRect.origin.y -= offsetY;
        longRect.size.height += offsetY;
        self.wvTextView.frame = longRect;
    }
    else
    {
        self.wvTextView.frame = _originalTextViewFrame;
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
