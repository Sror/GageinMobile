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
#import "GGComDetailEmployeeCell.h"
#import "GGCompany.h"
#import "GGCompanyDetailVC.h"



@interface GGCompanyUpdateDetailVC () <MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIWebView *webviewSignal;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (weak, nonatomic) IBOutlet UIButton *btnSwitchBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnSignal;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;


@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnSms;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;

@end



@implementation GGCompanyUpdateDetailVC
{
    GGCompanyUpdate         *_companyUpdateDetail;
    UIButton                *_btnPrevUpdate;
    UIButton                *_btnNextUpdate;
    CGRect                  _originalTextViewFrame;
    
    GGComUpdateDetailView   *_comUpdateDetailCell;
    UIActivityIndicatorView *_activityIndicator;
    
    
    UITableView             *_tvMentionedCompanies;
    
    BOOL                    _isTabbarHiddenWhenLoaded;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //_snTypes = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc
{
    _isTabbarHiddenWhenLoaded ? [GGUtils hideTabBarAnimated:YES] : [GGUtils showTabBarAnimated:YES];
}

-(void)_setPrevBtnRect
{
    CGRect naviRc = self.navigationController.navigationBar.frame;
    CGRect prevBtnRc = CGRectMake(naviRc.size.width - _btnPrevUpdate.frame.size.width * 2 - 10
                                  , (naviRc.size.height - _btnPrevUpdate.frame.size.height) / 2 + 5
                                  , _btnPrevUpdate.frame.size.width
                                  , _btnPrevUpdate.frame.size.height);
    _btnPrevUpdate.frame = prevBtnRc;
}

-(void)_setNextBtnRect
{
    CGRect naviRc = self.navigationController.navigationBar.frame;
    CGRect nextBtnRc = CGRectMake(naviRc.size.width - _btnNextUpdate.frame.size.width - 10
                                  , (naviRc.size.height - _btnNextUpdate.frame.size.height) / 2 + 5
                                  , _btnNextUpdate.frame.size.width
                                  , _btnNextUpdate.frame.size.height);
    _btnNextUpdate.frame = nextBtnRc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isTabbarHiddenWhenLoaded = GGSharedDelegate.tabBarController.isTabbarHidden;
    [GGUtils hideTabBarAnimated:YES];
    
    self.naviTitle = _naviTitleString;
    self.view.backgroundColor = GGSharedColor.silver;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.backgroundColor = GGSharedColor.silver;

    _webviewSignal.hidden = YES;
    
    //
    _comUpdateDetailCell = [GGComUpdateDetailView viewFromNibWithOwner:self];
    
    // previous update button
    UIImage *upArrowEnabledImg = [UIImage imageNamed:@"upArrowEnabled"];
    UIImage *upArrowDisabledImg = [UIImage imageNamed:@"upArrowDisabled"];
    //CGRect naviRc = self.navigationController.navigationBar.frame;
    CGRect prevBtnRc = CGRectMake(0
                                  , 0
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
    CGRect nextBtnRc = CGRectMake(0
                                  , 0
                                  , downArrowEnabledImg.size.width
                                  , downArrowEnabledImg.size.height);
    _btnNextUpdate.frame = nextBtnRc;
    [_btnNextUpdate setImage:downArrowEnabledImg forState:UIControlStateNormal];
    [_btnNextUpdate setImage:downArrowDisabledImg forState:UIControlStateDisabled];
    [_btnNextUpdate addTarget:self action:@selector(nextUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self _setNextBtnRect];
    [self _setPrevBtnRect];
    
    // mentioned companies table view
    _tvMentionedCompanies = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tvMentionedCompanies.delegate = self;
    _tvMentionedCompanies.dataSource = self;
    _tvMentionedCompanies.rowHeight = [GGComDetailEmployeeCell HEIGHT];
    
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

-(void)_updateMentionedCompanyTV
{
    if (ISIPADDEVICE)
    {
        CGRect detailRc = _comUpdateDetailCell.frame;
        detailRc.size.width = IPAD_CONTENT_WIDTH;
        detailRc.origin.x = (_comUpdateDetailCell.superview.frame.size.width - IPAD_CONTENT_WIDTH) / 2;
        _comUpdateDetailCell.frame = detailRc;
    }
    
    _tvMentionedCompanies.hidden = (_companyUpdateDetail.mentionedCompanies.count <= 0);
    if (!_tvMentionedCompanies.hidden)
    {
        [_scrollView addSubview:_tvMentionedCompanies];
        
        CGRect mentionedComRc = _tvMentionedCompanies.frame;
        
        if (ISIPADDEVICE)
        {
            mentionedComRc.size.width = IPAD_CONTENT_WIDTH;
            mentionedComRc.origin.x = (_tvMentionedCompanies.superview.frame.size.width - IPAD_CONTENT_WIDTH) / 2 - 5;
        }
        
        mentionedComRc.size.height = _companyUpdateDetail.mentionedCompanies.count * _tvMentionedCompanies.rowHeight;
        mentionedComRc.origin.y = CGRectGetMaxY(_comUpdateDetailCell.frame) + 5;
        _tvMentionedCompanies.frame = mentionedComRc;
        
    }
    else
    {
        [_tvMentionedCompanies removeFromSuperview];
    }
}

-(void)_adjustScrollviewContentSize
{
    [self _updateMentionedCompanyTV];
    
    float tvMentionedComHeight = _tvMentionedCompanies.hidden ? 0 : _tvMentionedCompanies.frame.size.height;
    if (_scrollView.frame.size.height - tvMentionedComHeight > _comUpdateDetailCell.height)
    {
        _comUpdateDetailCell.height = _scrollView.frame.size.height - tvMentionedComHeight;
    }
    
    float realContentHeight = _comUpdateDetailCell.height + tvMentionedComHeight;
    
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = realContentHeight + 10;
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
    [self setBtnSignal:nil];
    [self setBtnLike:nil];
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_btnPrevUpdate goTop];
    [_btnNextUpdate goTop];
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
    [_btnSave setImage:(aSaved ? [UIImage imageNamed:@"btnSaved"] : [UIImage imageNamed:@"btnSave"]) forState:UIControlStateNormal];
}

-(void)_updateLikedButton
{
    [_btnLike setImage:(_companyUpdateDetail.liked ? [UIImage imageNamed:@"btnLiked"] : [UIImage imageNamed:@"btnLike"]) forState:UIControlStateNormal];
}

-(void)_showWebSignal:(BOOL)aShow url:(NSString *)aURL
{
    BOOL needAnimation = (_webviewSignal.hidden == aShow);
    _webviewSignal.hidden = !aShow;
    self.navigationController.navigationBarHidden = aShow;
    
    [self _showSwitchButton:aShow];
    
    if (aShow)
    {
        if (needAnimation)
        {
            [self.viewContent.layer addAnimation:[GGAnimation animationFlipFromRight] forKey:nil];
        }
        
        [_webviewSignal loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aURL]]];
        //[_webviewSignal showLoadingHUD];
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
    //_btnSms.hidden =
    //_btnTwitter.hidden =
    //_btnLinkedIn.hidden =
    _btnSignal.hidden =
    _btnLike.hidden =
    //_btnEmail.hidden =
    aShow;
}

#pragma mark - notification

#pragma mark - Actions
-(IBAction)signalAction:(id)sender
{
//#warning TODO: implementation needed
    [self _showSheetToSignal];
}

-(IBAction)likeAction:(id)sender
{
    if (_companyUpdateDetail.liked)
    {
        [GGSharedAPI unlikeUpdateWithID:_companyUpdateDetail.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _companyUpdateDetail.liked = NO;
                [self _updateLikedButton];
            }
        }];
    }
    else
    {
        [GGSharedAPI likeUpdateWithID:_companyUpdateDetail.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _companyUpdateDetail.liked = YES;
                [self _updateLikedButton];
            }
        }];
    }
    
}

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
    
    NSString *contentBody = [NSString stringWithFormat:@"<div><p>I want to share this update with you.</p> \
                             <p><a href=\"%@\">%@</a></p> \
                             <p><strong>%@</strong></p> \
                             <p><em>%@</em></p> \
                             Shared from <a href=\"www.gagein.com\">GageIn</a>, %@ </div>"
                             , _companyUpdateDetail.url, _companyUpdateDetail.url
                             , _companyUpdateDetail.headline
                             , _companyUpdateDetail.contentInDetail, GAGEIN_SLOGAN];

    
    [controller setMessageBody:contentBody isHTML:YES];
    
    [GGSharedDelegate makeNaviBarCustomed:NO];
    [self presentViewController:controller animated:YES completion:nil];

}

-(IBAction)sendSMSAction:(id)sender
{
    NSString *body = [NSString stringWithFormat:@"%@\n\n%@\n\nvia Gagein at www.gagein.com", _companyUpdateDetail.headline, _companyUpdateDetail.url];
    [GGUtils sendSmsTo:nil body:body vcDelegate:self];
    [GGSharedDelegate makeNaviBarCustomed:NO];
}



-(IBAction)switchBackAction:(id)sender
{
    [self _showWebSignal:NO url:nil];
    //_isShowingLinkedIn = _isShowingTwitter = NO;
}

-(IBAction)linkedInAction:(id)sender
{
    [self _showWebSignal:YES url:_companyUpdateDetail.linkedInSignal];
}

-(IBAction)twitterAction:(id)sender
{
    [self _showWebSignal:YES url:_companyUpdateDetail.twitterTweets];
}

-(IBAction)shareAction:(id)sender
{
//#warning TODO: Steps for sharing  -- Daniel Dong
    // 1. call API to check for linked account list
    
    
    // 2. if linked account is linked, go to step 4.
    // 3. if linked account not linked, go authentication, if auth OK, call API to report the token.
    // 4. Share the update.
    
    [self _showSheetToShare];
}


-(void)_shareWithType:(EGGSnType)aType
{
    GGSnShareVC *vc = [[GGSnShareVC alloc] init];
    vc.comUpdateDetail = _companyUpdateDetail;
    vc.shareType = kGGSnShareTypeUpdate;
    vc.snType = aType;
    vc.snTypesRef = GGSharedRuntimeData.snTypes;
    
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)_showSheetToShare
{
    CMActionSheet *actionSheet = [[CMActionSheet alloc] init];
    
    UIImage *bgImg = nil;
    
    //if ([self _hasLinkedSnType:kGGSnTypeSalesforce])
    {
        // lightGrayBtnBg
        bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"chatterLongBtnBg"];
        [actionSheet addButtonWithTitle:@"Chatter" bgImage:bgImg block:^{
            
            [self _shareWithType:kGGSnTypeSalesforce];            
        }];
    }
    
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"LinkedIn" bgImage:bgImg block:^{
       [self _shareWithType:kGGSnTypeLinkedIn];
    }];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"twitterLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Twitter" bgImage:bgImg block:^{
        DLog(@"Shared to Twitter.");
        [self _shareWithType:kGGSnTypeTwitter];
    }];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Facebook" bgImage:bgImg block:^{
        DLog(@"Shared to facebook.");
        
        [self _shareWithType:kGGSnTypeFacebook];
        
    }];
    
    
    if ([GGUtils hasLinkedSnType:kGGSnTypeYammer])
    {
        bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"chatterLongBtnBg"];
        [actionSheet addButtonWithTitle:@"Yammer" bgImage:bgImg block:^{
            DLog(@"Shared to Yammer.");
            [self _shareWithType:kGGSnTypeYammer];
        }];
    }
    
    [actionSheet addSeparator];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Email" bgImage:bgImg block:^{
        [self sendMailAction:nil];
    }];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"SMS" bgImage:bgImg block:^{
        [self sendSMSAction:nil];
    }];
    
    [actionSheet addSeparator];
    
    bgImg = [UIImage imageNamed:@"grayBtnBg"];
    UIButton *cancelBtn = [actionSheet addButtonWithTitle:@"Cancel" bgImage:bgImg block:^{
        
    }];
    [cancelBtn setTitleColor:GGSharedColor.white forState:UIControlStateNormal];
    [cancelBtn setTitleShadowColor:GGSharedColor.black forState:UIControlStateNormal];
    
    
//    [actionSheet addSeparator];
//    [actionSheet addButtonWithTitle:@"Cancel" type:CMActionSheetButtonTypeGray block:^{
//        NSLog(@"Dismiss action sheet with \"Close Button\"");
//    }];
    
    // Present
    [actionSheet present];
}


-(void)_showSheetToSignal
{
    CMActionSheet *actionSheet = [[CMActionSheet alloc] init];
    
    UIImage *bgImg = nil;
 
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];
    [actionSheet addButtonWithTitle:@"Twitter" bgImage:bgImg block:^{
        //DLog(@"Signal to Twitter.");
        [self twitterAction:nil];
    }];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];
    [actionSheet addButtonWithTitle:@"LinkedIn" bgImage:bgImg block:^{
        //DLog(@"Signal to LinkedIn.");
        [self linkedInAction:nil];
    }];
    
    bgImg = [UIImage imageNamed:@"grayBtnBg"];
    UIButton *cancelBtn = [actionSheet addButtonWithTitle:@"Cancel" bgImage:bgImg block:^{
        
    }];
    [cancelBtn setTitleColor:GGSharedColor.white forState:UIControlStateNormal];
    [cancelBtn setTitleShadowColor:GGSharedColor.black forState:UIControlStateNormal];
    
    
//    [actionSheet addSeparator];
//    [actionSheet addButtonWithTitle:@"Cancel" type:CMActionSheetButtonTypeGray block:^{
//        NSLog(@"Dismiss action sheet with \"Close Button\"");
//    }];
    
    // Present
    [actionSheet present];
}



-(IBAction)saveAction:(id)sender
{
    GGCompanyUpdate *data = _updates[_updateIndex];
    if (data.saved)
    {
        id op = [GGSharedAPI unsaveUpdateWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                data.saved = NO;
                [self _updateSaveBtnSaved:NO];
            }
            else
            {
                [GGAlert alertWithApiParser:parser];
            }
        }];
        
        [self registerOperation:op];
    }
    else
    {
        id op = [GGSharedAPI saveUpdateWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
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
                [GGAlert alertWithApiParser:parser];
            }
        }];
        
        [self registerOperation:op];
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
        
        GGCompanyUpdate *data = _updates[_updateIndex];
        _comUpdateDetailCell.lblDate.text = [_companyUpdateDetail monthDayWithDate:data.date];
        
        [self _updateSaveBtnSaved:_companyUpdateDetail.saved];
        [self _updateLikedButton];
        
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
                    float maxImageSize = _comUpdateDetailCell.contentWidth;
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
    id op = [GGSharedAPI getCompanyUpdateDetailWithNewsID:updateData.ID callback:^(id operation, id aResultObject, NSError *anError) {
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
    
    [self registerOperation:op];
}

-(void)_callApiGetSnList
{
    id op = [GGSharedAPI snGetList:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            NSArray *snTypes = [parser parseSnGetList];
            [GGSharedRuntimeData.snTypes removeAllObjects];
            [GGSharedRuntimeData.snTypes addObjectsFromArray:snTypes];
        }
    }];
    
    [self registerOperation:op];
}



#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[webView hideLoadingHUD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //[webView hideLoadingHUD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _companyUpdateDetail.mentionedCompanies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString *cellID = @"GGComDetailEmployeeCell";
    GGComDetailEmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [GGComDetailEmployeeCell viewFromNibWithOwner:self];
    }
    
    GGCompany *data = _companyUpdateDetail.mentionedCompanies[row];
    cell.lblTitle.text = data.name;
    cell.lblSubTitle.text = data.website;
    cell.lblThirdLine.text = [NSString stringWithFormat:@"%@,%@,%@", data.city, data.state, data.country];
    [cell.ivPhoto setImageWithURL:[NSURL URLWithString:data.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
    
    cell.tag = row;
    
    return cell;
}

#pragma mark - tableview delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GGComDetailEmployeeCell HEIGHT];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGCompany *data = _companyUpdateDetail.mentionedCompanies[indexPath.row];
    if (data.ID)
    {
        GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
        vc.companyID = data.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

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



#pragma mark - layout
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [self _setNextBtnRect];
    [self _setPrevBtnRect];
    
    [self _adjustScrollviewContentSize];
}

@end
