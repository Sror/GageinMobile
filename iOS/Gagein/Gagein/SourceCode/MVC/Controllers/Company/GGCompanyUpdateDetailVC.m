//
//  GGCompanyUpdateDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyUpdateDetailVC.h"
#import "GGCompanyUpdate.h"
#import "GGComUpdateDetailView.h"
#import "GGWebVC.h"
#import "CMActionSheet.h"

@interface GGCompanyUpdateDetailVC () <MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIWebView *webviewSignal;
@property (weak, nonatomic) IBOutlet UIView *viewContent;


@end

@implementation GGCompanyUpdateDetailVC
{
    GGCompanyUpdate *_companyUpdateDetail;
    UIButton *_btnPrevUpdate;
    UIButton *_btnNextUpdate;
    CGRect  _originalTextViewFrame;
    
    GGComUpdateDetailView   *_comUpdateDetailCell;
    UIActivityIndicatorView *_activityIndicator;
    
    BOOL                    _isShowingLinkedIn;
    BOOL                    _isShowingTwitter;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = _naviTitleString;
    self.view.backgroundColor = GGSharedColor.silver;
    self.scrollView.alwaysBounceVertical = YES;
    //[_webviewSignal removeFromSuperview];
    _webviewSignal.hidden = YES;
    
    //
    _comUpdateDetailCell = [GGComUpdateDetailView viewFromNibWithOwner:self];
    
    // previous update button
    UIImage *upArrowEnabledImg = [UIImage imageNamed:@"upArrowEnabled"];
    UIImage *upArrowDisabledImg = [UIImage imageNamed:@"upArrowDisabled"];
    CGRect naviRc = self.navigationController.navigationBar.frame;
    CGRect prevBtnRc = CGRectMake(naviRc.size.width - upArrowEnabledImg.size.width * 2 - 10
                                  , (naviRc.size.height - upArrowEnabledImg.size.height) / 2 + 5
                                  , upArrowEnabledImg.size.width
                                  , upArrowEnabledImg.size.height);
    
    _btnPrevUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPrevUpdate.frame = prevBtnRc;
    [_btnPrevUpdate setImage:upArrowEnabledImg forState:UIControlStateNormal];
    [_btnPrevUpdate setImage:upArrowDisabledImg forState:UIControlStateDisabled];
    [_btnPrevUpdate addTarget:self action:@selector(prevUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // next update button
    UIImage *downArrowEnabledImg = [UIImage imageNamed:@"downArrowEnabled"];
    UIImage *downArrowDisabledImg = [UIImage imageNamed:@"downArrowDisabled"];
    _btnNextUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect nextBtnRc = CGRectMake(naviRc.size.width - downArrowEnabledImg.size.width - 10
                                  , (naviRc.size.height - downArrowEnabledImg.size.height) / 2 + 5
                                  , downArrowEnabledImg.size.width
                                  , downArrowEnabledImg.size.height);
    _btnNextUpdate.frame = nextBtnRc;
    [_btnNextUpdate setImage:downArrowEnabledImg forState:UIControlStateNormal];
    [_btnNextUpdate setImage:downArrowDisabledImg forState:UIControlStateDisabled];
    [_btnNextUpdate addTarget:self action:@selector(nextUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //
    //_originalTextViewFrame = self.wvTextView.frame;
    self.scrollView.hidden = YES;
    [self.scrollView addSubview:_comUpdateDetailCell];
    [self _adjustScrollviewContentSize];
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, CGRectGetMaxY(self.viewUpdate.frame) + 10);
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
    
    [self _callApiGetCompanyUpdateDetail];
}

-(void)_adjustScrollviewContentSize
{
    if (_scrollView.frame.size.height > _comUpdateDetailCell.height)
    {
        _comUpdateDetailCell.height = _scrollView.frame.size.height;
    }
    
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = _comUpdateDetailCell.height;
    self.scrollView.contentSize = contentSize;
    self.scrollView.contentOffset = CGPointZero;
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setWebView:nil];
    [self setBtnSave:nil];
    [self setWebviewSignal:nil];
    [self setViewContent:nil];
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
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper
-(void)_updateSaveBtnSaved:(BOOL)aSaved
{
    [_btnSave setImage:(aSaved ? [UIImage imageNamed:@"unsaveIcon"] : [UIImage imageNamed:@"saveIcon"]) forState:UIControlStateNormal];
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
    
    //[self presentModalViewController:controller animated:YES];
    [self presentViewController:controller animated:YES completion:nil];

}

-(IBAction)sendSMSAction:(id)sender
{
    [GGUtils sendSmsTo:[NSArray arrayWithObjects:@"1234567890", nil] body:_companyUpdateDetail.headline vcDelegate:self];
}

-(void)_showWebSignal:(BOOL)aShow url:(NSString *)aURL
{
    BOOL needAnimation = (_webviewSignal.hidden == aShow);
    _webviewSignal.hidden = !aShow;
    if (aShow)
    {
        if (needAnimation)
        {
            [self.viewContent.layer addAnimation:[GGAnimation animationFlipFromRight] forKey:nil];
        }
        
        [_webviewSignal loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aURL]]];
        _webviewSignal.delegate = self;
    }
    else
    {
        if (needAnimation)
        {
            [self.viewContent.layer addAnimation:[GGAnimation animationFlipFromLeft] forKey:nil];
        }
        
        [_webviewSignal stopLoading];
    }
}

-(IBAction)linkedInAction:(id)sender
{
    [self _showWebSignal:!_isShowingLinkedIn url:_companyUpdateDetail.linkedInSignal];
    _isShowingLinkedIn = !_isShowingLinkedIn;
    _isShowingTwitter = NO;
    
//    [self.viewContent.layer addAnimation:[GGAnimation animationFlipFromRight] forKey:nil];
//    _webviewSignal.hidden = NO;
//
//    [_webviewSignal loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_companyUpdateDetail.linkedInSignal]]];
}

-(IBAction)twitterAction:(id)sender
{
    [self _showWebSignal:!_isShowingTwitter url:_companyUpdateDetail.twitterTweets];
    _isShowingTwitter = !_isShowingTwitter;
    _isShowingLinkedIn = NO;
}

-(IBAction)shareAction:(id)sender
{
    CMActionSheet *actionSheet = [[CMActionSheet alloc] init];
    
#warning TODO: Steps for sharing  -- Daniel Dong
    // 1. call API to check for linked account list
    // 2. if linked account is linked, go to step 4.
    // 3. if linked account not linked, go authentication, if auth OK, call API to report the token.
    // 4. Share the update.
    
    UIImage *bgImg = [UIImage imageNamed:@"chatterLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Chatter" bgImage:bgImg block:^{
        DLog(@"Shared to chatter.");
    }];
    
    bgImg = [UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"LinkedIn" bgImage:bgImg block:^{
        DLog(@"Shared to LinkedIn.");
    }];
    
    bgImg = [UIImage imageNamed:@"twitterLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Twitter" bgImage:bgImg block:^{
        DLog(@"Shared to Twitter.");
    }];
    
    bgImg = [UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Facebook" bgImage:bgImg block:^{
        DLog(@"Shared to facebook.");
    }];
    
    bgImg = [UIImage imageNamed:@"chatterLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Yammer" bgImage:bgImg block:^{
        DLog(@"Shared to Yammer.");
    }];
    
    
    
    [actionSheet addSeparator];
    [actionSheet addButtonWithTitle:@"Cancel" type:CMActionSheetButtonTypeGray block:^{
        NSLog(@"Dismiss action sheet with \"Close Button\"");
    }];
    
    // Present
    [actionSheet present];
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
                [self _updateSaveBtnSaved:NO];
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
                //[GGAlert alert:@"saved!"];
                [self _showSavedHUD];
                [self _updateSaveBtnSaved:YES];
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

-(void)_showSavedHUD
{
    [self showCheckMarkHUDWithText:@"Saved"];
}

#pragma mark - UI
-(void)_updateUIWithUpdateDetail
{
    if (_companyUpdateDetail.textview.length <= 0)
    {
        NSURL *url = [NSURL URLWithString:_companyUpdateDetail.url];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        _webView.hidden = NO;
    }
    else
    {
        [_webView loadHTMLString:@"" baseURL:nil];
        _webView.hidden = YES;
        _comUpdateDetailCell.lblTitle.text = _companyUpdateDetail.headline;

        _comUpdateDetailCell.tvContent.text = [_companyUpdateDetail doubleReturnedText];
        
        _comUpdateDetailCell.lblSource.text = ((GGCompanyUpdate *)(_updates[_updateIndex])).fromSource;
        [self _updateSaveBtnSaved:_companyUpdateDetail.saved];
        
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
                //UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
                _activityIndicator.hidesWhenStopped = YES;
                _activityIndicator.hidden = NO;
                [_activityIndicator startAnimating];
                _activityIndicator.center = CGPointMake(_comUpdateDetailCell.ivPhoto.frame.size.width / 2, _comUpdateDetailCell.ivPhoto.frame.size.height / 2);
                [_comUpdateDetailCell.ivPhoto addSubview:_activityIndicator];
                
                UIImage *placeholderImage = GGSharedImagePool.placeholder;

                [_comUpdateDetailCell.ivPhoto setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {

                    CGSize imageSize = image.size;
                    float maxImageSize = _comUpdateDetailCell.contentWidth - 10;
                    float ratio = imageSize.width / maxImageSize;
                    if (ratio > 1)
                    {
                        imageSize.width = maxImageSize;
                        imageSize.height /= ratio;
                    }
                    CGRect photoRc = _comUpdateDetailCell.ivPhoto.frame;
                    _comUpdateDetailCell.ivPhoto.frame = CGRectMake((_comUpdateDetailCell.contentWidth - imageSize.width) / 2
                                                                    , photoRc.origin.y
                                                                    , imageSize.width
                                                                    , imageSize.height);
                    [_comUpdateDetailCell adjustLayout];
                    
                    [self _adjustScrollviewContentSize];
                    
                    [_activityIndicator stopAnimating];
                    [_activityIndicator removeFromSuperview];
                }];
            }
        }
        
        [_comUpdateDetailCell adjustLayoutHasImage:(urlStr.length)];
        
        [self _adjustScrollviewContentSize];
        
        //[_comUpdateDetailCell.wvTextview loadHTMLString:_companyUpdateDetail.textview baseURL:nil];
        
        self.scrollView.hidden = NO;
    }
}





#pragma mark - API calls
-(void)_callApiGetCompanyUpdateDetail
{
//    if (!_webviewSignal.hidden)
//    {
        [self _showWebSignal:NO url:nil];
    //}
    _isShowingLinkedIn = _isShowingTwitter = NO;
    
    GGCompanyUpdate *updateData = [self.updates objectAtIndex:_updateIndex];
    [self showLoadingHUD];
    [GGSharedAPI getCompanyUpdateDetailWithNewsID:updateData.ID callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            updateData.hasBeenRead = YES;
            _companyUpdateDetail = [parser parseGetCompanyUpdateDetail];
            
            [self _updateUIWithUpdateDetail];
            //[_tvContent reloadData];
        }
        
    }];
}



#pragma mark - webview delegate
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

#pragma mark - tableview datasource

#pragma mark - message delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            DLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            DLog(@"Failed");
            break;
        case MessageComposeResultSent:
            [self showCheckMarkHUDWithText:@"Sent OK!"];
            break;
        default:
            break;
    }
    
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
