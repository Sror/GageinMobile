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
#import "GGAppDelegate.h"
#import "GGSalesforceOAuthVC.h"
#import "GGLinkedInOAuthVC.h"

#import "GGSnShareVC.h"
#import "GGFacebookOAuth.h"
#import "GGTwitterOAuthVC.h"
#import "OAToken.h"

@interface GGCompanyUpdateDetailVC () <MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIWebView *webviewSignal;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (weak, nonatomic) IBOutlet UIButton *btnSwitchBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnSms;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;

@end



@implementation GGCompanyUpdateDetailVC
{
    GGCompanyUpdate *_companyUpdateDetail;
    UIButton *_btnPrevUpdate;
    UIButton *_btnNextUpdate;
    CGRect  _originalTextViewFrame;
    
    GGComUpdateDetailView   *_comUpdateDetailCell;
    UIActivityIndicatorView *_activityIndicator;
    
    //BOOL                    _isShowingLinkedIn;
    //BOOL                    _isShowingTwitter;
    
    NSMutableArray          *_snTypes;
    
    //UIImage                 *_switchButtonImage;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _snTypes = [NSMutableArray array];
        //_switchButtonImage = [UIImage imageNamed:@"updateSwitchBackbtn"];
    }
    return self;
}

- (void)viewDidLoad
{
    [self observeNotification:OA_NOTIFY_FACEBOOK_AUTH_OK];
    [self observeNotification:OA_NOTIFY_SALESFORCE_AUTH_OK];
    [self observeNotification:OA_NOTIFY_TWITTER_OAUTH_OK];
    
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
    [self _callApiGetSnList];
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
    [self setBtnSwitchBack:nil];
    [self setBtnEmail:nil];
    [self setBtnShare:nil];
    [self setBtnTwitter:nil];
    [self setBtnSms:nil];
    [self setBtnLinkedIn:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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
    
    [GGSharedDelegate makeNaviBarCustomed:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper
-(void)_updateSaveBtnSaved:(BOOL)aSaved
{
    [_btnSave setImage:(aSaved ? [UIImage imageNamed:@"unsaveIcon"] : [UIImage imageNamed:@"saveIcon"]) forState:UIControlStateNormal];
}

#pragma mark - notification
- (void)handleNotification:(NSNotification *)notification
{
    NSString *notiName = notification.name;
    if ([notiName isEqualToString:OA_NOTIFY_LINKEDIN_AUTH_OK])
    {
        [self unobserveNotification:OA_NOTIFY_LINKEDIN_AUTH_OK];
        
        [self showLoadingHUD];
        [GGSharedAPI snSaveLinedInWithToken:self.linkedInAuthView.accessToken.key secret:self.linkedInAuthView.accessToken.secret callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [self _addSnType:kGGSnTypeLinkedIn];
                [self _shareWithType:kGGSnTypeLinkedIn];
                //#warning TODO: Enter a page to change message and share
            }
        }];
        
    }
    else if ([notiName isEqualToString:OA_NOTIFY_FACEBOOK_AUTH_OK])
    {
        NSString *accessToken = [GGFacebookOAuth sharedInstance].session.accessTokenData.accessToken;
        
        [self showLoadingHUD];
        [GGSharedAPI snSaveFacebookWithToken:accessToken callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [self _addSnType:kGGSnTypeFacebook];
                [self _shareWithType:kGGSnTypeFacebook];
            }
        }];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_SALESFORCE_AUTH_OK]) // salesforce ok
    {
        SFOAuthCredentials *credencial = notification.object;
        
        [self showLoadingHUD];
        [GGSharedAPI snSaveSalesforceWithToken:credencial.accessToken accountID:credencial.userId refreshToken:credencial.refreshToken instanceURL:credencial.instanceUrl.absoluteString callback:^(id operation, id aResultObject, NSError *anError) {
            
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [self _addSnType:kGGSnTypeSalesforce];
                [self _shareWithType:kGGSnTypeSalesforce];
            }
            
        }];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_TWITTER_OAUTH_OK]) // twitter oauth ok
    {
        OAToken *token = notification.object;
        
        [self showLoadingHUD];
        [GGSharedAPI snSaveTwitterWithToken:token.key secret:token.secret callback:^(id operation, id aResultObject, NSError *anError) {
            
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [self _addSnType:kGGSnTypeTwitter];
                [self _shareWithType:kGGSnTypeTwitter];
            }
            
        }];
    }
}

#pragma mark - Actions
-(IBAction)sendMailAction:(id)sender
{
    if (![MFMailComposeViewController canSendMail])
    {
        [GGAlert alertWithMessage:@"Sorry, You can't send email on this device."];
        return;
    }
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:_companyUpdateDetail.headline];
    
    NSString *contentBody = [NSString stringWithFormat:@"<div>I want to share this update with you.<br\\><br\\> \
                             %@\n\n \
                             %@\n\n \
                             %@\n\n \
                             Shared from GageIn, a visual sales intelligence company.</div>", _companyUpdateDetail.url
                             , _companyUpdateDetail.headline
                             , _companyUpdateDetail.contentInDetail];

    
    [controller setMessageBody:contentBody isHTML:YES];
    
//    if (_companyUpdateDetail.textview.length)
//    {
//        [controller setMessageBody:_companyUpdateDetail.textview isHTML:YES];
//    }
//    else
//    {
//        [controller setMessageBody:[NSString stringWithFormat:@"<div><a href=\"%@\"> See Detail </a></div>", _companyUpdateDetail.url] isHTML:YES];
//    }
    
    [GGSharedDelegate makeNaviBarCustomed:NO];
    [self presentViewController:controller animated:YES completion:nil];

}

-(IBAction)sendSMSAction:(id)sender
{
    NSString *body = [NSString stringWithFormat:@"%@\n%@\n\nvia Gagein at www.gagein.com", _companyUpdateDetail.headline, _companyUpdateDetail.url];
    [GGUtils sendSmsTo:nil body:body vcDelegate:self];
    [GGSharedDelegate makeNaviBarCustomed:NO];
}

-(void)_showWebSignal:(BOOL)aShow url:(NSString *)aURL
{
    BOOL needAnimation = (_webviewSignal.hidden == aShow);
    _webviewSignal.hidden = !aShow;
    
    [self _showSwitchButton:aShow];
    
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

-(void)_showSwitchButton:(BOOL)aShow
{
    _btnSwitchBack.hidden = !aShow;
    
    _btnSave.hidden =
    _btnShare.hidden =
    _btnSms.hidden =
    _btnTwitter.hidden =
    _btnLinkedIn.hidden =
    _btnEmail.hidden = aShow;
}

-(IBAction)switchBackAction:(id)sender
{
    [self _showWebSignal:NO url:nil];
    //_isShowingLinkedIn = _isShowingTwitter = NO;
}

-(IBAction)linkedInAction:(id)sender
{
    [self _showWebSignal:YES url:_companyUpdateDetail.linkedInSignal];
//    [self _showWebSignal:!_isShowingLinkedIn url:_companyUpdateDetail.linkedInSignal];
//    _isShowingLinkedIn = !_isShowingLinkedIn;
//    _isShowingTwitter = NO;
}

-(IBAction)twitterAction:(id)sender
{
    [self _showWebSignal:YES url:_companyUpdateDetail.twitterTweets];
//    [self _showWebSignal:!_isShowingTwitter url:_companyUpdateDetail.twitterTweets];
//    _isShowingTwitter = !_isShowingTwitter;
//    _isShowingLinkedIn = NO;
}

-(IBAction)shareAction:(id)sender
{
//#warning TODO: Steps for sharing  -- Daniel Dong
    // 1. call API to check for linked account list
    
    
    // 2. if linked account is linked, go to step 4.
    // 3. if linked account not linked, go authentication, if auth OK, call API to report the token.
    // 4. Share the update.
    
    [self _showActionSheet];
}

-(BOOL)_hasLinedSnType:(EGGSnType)aSnType
{
    for (NSString *type in _snTypes)
    {
        if (type.longLongValue == aSnType)
        {
            return YES;
        }
    }
    
    return NO;
}

-(void)_addSnType:(EGGSnType)aSnType
{
    if (![self _hasLinedSnType:aSnType]) {
        [_snTypes addObject:[NSString stringWithFormat:@"%d", aSnType]];
    }
}

-(void)_shareWithType:(EGGSnType)aType
{
    GGSnShareVC *vc = [[GGSnShareVC alloc] init];
    vc.comUpdateDetail = _companyUpdateDetail;
    vc.snType = aType;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)_showActionSheet
{
    CMActionSheet *actionSheet = [[CMActionSheet alloc] init];
    
    UIImage *bgImg = nil;
    
    if ([self _hasLinedSnType:kGGSnTypeSalesforce])
    {
        bgImg = [UIImage imageNamed:@"chatterLongBtnBg"];
        [actionSheet addButtonWithTitle:@"Chatter" bgImage:bgImg block:^{
            
            DLog(@"Shared to chatter.");
            [self _shareWithType:kGGSnTypeSalesforce];
            
//            if ([self _hasLinedSnType:kGGSnTypeSalesforce])
//            {
//                [self _shareWithType:kGGSnTypeSalesforce];
//            }
//            else
//            {
//                [self connectSalesForce];
//            }
            
        }];
    }
    
    
    bgImg = [UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"LinkedIn" bgImage:bgImg block:^{
        DLog(@"Shared to LinkedIn.");
        if ([self _hasLinedSnType:kGGSnTypeLinkedIn])
        {
//#warning TODO: Enter a page to change message and share
            [self _shareWithType:kGGSnTypeLinkedIn];
        }
        else
        {
            [self connectLinkedIn];
        }
    }];
    
    bgImg = [UIImage imageNamed:@"twitterLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Twitter" bgImage:bgImg block:^{
        DLog(@"Shared to Twitter.");
        
        if ([self _hasLinedSnType:kGGSnTypeTwitter])
        {
            [self _shareWithType:kGGSnTypeTwitter];
        }
        else
        {
            [self connectTwitter];
        }
    
    }];
    
    bgImg = [UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Facebook" bgImage:bgImg block:^{
        DLog(@"Shared to facebook.");
        
        if ([self _hasLinedSnType:kGGSnTypeFacebook])
        {
            [self _shareWithType:kGGSnTypeFacebook];
        }
        else
        {
            [self connectFacebook];
        }
        
    }];
    
    
    if ([self _hasLinedSnType:kGGSnTypeYammer])
    {
        bgImg = [UIImage imageNamed:@"chatterLongBtnBg"];
        [actionSheet addButtonWithTitle:@"Yammer" bgImage:bgImg block:^{
            DLog(@"Shared to Yammer.");
            [self _shareWithType:kGGSnTypeYammer];
        }];
    }
    
    
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
                [GGAlert alertWithApiMessage:parser.message];
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
                [GGAlert alertWithApiMessage:parser.message];
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
    [self _showWebSignal:NO url:nil];
    
    //_isShowingLinkedIn = _isShowingTwitter = NO;
    
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

-(void)_callApiGetSnList
{
    [GGSharedAPI snGetList:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            NSArray *snTypes = [parser parseSnGetList];
            [_snTypes removeAllObjects];
            [_snTypes addObjectsFromArray:snTypes];
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
    
    [GGSharedDelegate makeNaviBarCustomed:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
