//
//  GGCompanyUpdateDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyUpdateDetailVC.h"
#import "GGCompanyUpdate.h"
//#import "GGComUpdateDetailCell.h"
#import "GGComUpdateDetailView.h"

@interface GGCompanyUpdateDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (weak, nonatomic) IBOutlet UIView *viewUpdate;
//@property (weak, nonatomic) IBOutlet UIImageView *ivUpdateBg;
//@property (weak, nonatomic) IBOutlet UILabel *lblSource;
//@property (weak, nonatomic) IBOutlet UILabel *lblDate;
//@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//@property (weak, nonatomic) IBOutlet UILabel *lblContent;
//@property (weak, nonatomic) IBOutlet UITextView *textView;
//@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
//@property (weak, nonatomic) IBOutlet UIWebView *wvTextView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property (weak, nonatomic) IBOutlet UITableView *tvContent;

@end

@implementation GGCompanyUpdateDetailVC
{
    GGCompanyUpdate *_companyUpdateDetail;
    UIButton *_btnPrevUpdate;
    UIButton *_btnNextUpdate;
    CGRect  _originalTextViewFrame;
    
    GGComUpdateDetailView   *_comUpdateDetailCell;
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
    self.naviTitle = _naviTitleString;
    self.view.backgroundColor = GGSharedColor.silver;
    
    //
    _comUpdateDetailCell = [GGComUpdateDetailView viewFromNibWithOwner:self];
    //_tvContent.backgroundColor = GGSharedColor.silver;
    
    //
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
    
    
    //
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
    
    
    
    [self _callApiGetCompanyUpdateDetail];
}

-(void)_adjustScrollviewContentSize
{
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = _comUpdateDetailCell.height;
    self.scrollView.contentSize = contentSize;
    self.scrollView.contentOffset = CGPointZero;
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    //[self setLblTitle:nil];
    //[self setIvPhoto:nil];
    //[self setLblContent:nil];
    [self setWebView:nil];
    //[self setLblSource:nil];
    //[self setLblDate:nil];
    //[self setViewUpdate:nil];
    //[self setIvUpdateBg:nil];
    //[self setTextView:nil];
    //[self setWvTextView:nil];
    //[self setTvContent:nil];
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
        _comUpdateDetailCell.lblTitle.text = _companyUpdateDetail.headline;

        _comUpdateDetailCell.textviewHidden.text = _companyUpdateDetail.textview;
        
        _comUpdateDetailCell.lblSource.text = ((GGCompanyUpdate *)(_updates[_updateIndex])).fromSource;
        
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
                activityIndicator.center = CGPointMake(_comUpdateDetailCell.ivPhoto.frame.size.width / 2, _comUpdateDetailCell.ivPhoto.frame.size.height / 2);
                [_comUpdateDetailCell.ivPhoto addSubview:activityIndicator];
                
                UIImage *placeholderImage = GGSharedImagePool.placeholder;
                //[self.ivPhoto setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholderImage];
                [_comUpdateDetailCell.ivPhoto setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    [activityIndicator stopAnimating];
                    [activityIndicator removeFromSuperview];
                }];
            }
        }
        
        [_comUpdateDetailCell adjustLayoutHasImage:(urlStr.length)];
        
        [self _adjustScrollviewContentSize];
        
        [_comUpdateDetailCell.wvTextview loadHTMLString:_companyUpdateDetail.textview baseURL:nil];
        
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
            //[_tvContent reloadData];
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

#pragma mark - tableview datasource


@end
