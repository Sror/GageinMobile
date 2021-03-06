//
//  GGHappeningDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGHappeningDetailVC.h"
#import "GGHappening.h"
#import "GGCustomBriefCell.h"
#import "GGHappeningDetailCell.h"
#import "GGCompanyDetailVC.h"
#import "GGPersonDetailVC.h"
#import "GGAppDelegate.h"
#import "GGImageVC.h"
#import "GGAutosizingLabel.h"
#import "CMActionSheet.h"
#import "GGSnShareVC.h"
#import "GGLinkedInOAuthVC.h"
#import "OAToken.h"

#import "GGFacebookOAuth.h"
#import "GGTwitterOAuthVC.h"
#import "GGSalesforceOAuthVC.h"


#define TAG_ALERT_SALESFORCE_OAUTH_FAILED   1000

@interface GGCellData : NSObject
@property (assign) long long    ID;
@property (copy) NSString       *name;
@property (copy) NSString       *title;
@property (copy) NSString       *address;
@property (copy) NSString       *picUrl;
@property (assign) EGGCustomBriefCellType   type;
@end

@implementation GGCellData
@end


//
@interface GGHappeningDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tvDetail;
@property (weak, nonatomic) IBOutlet UIView *viewBottomBar;
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;

@end

@implementation GGHappeningDetailVC
{
    GGHappening                 *_currentDetail;
    GGHappeningDetailCell       *_happeningDetailCell;
    
    UIButton *_btnPrevUpdate;
    UIButton *_btnNextUpdate;
    
    NSMutableArray              *_cellDatas;
    
    UITapGestureRecognizer *_tapGestOpenChart;
    UITapGestureRecognizer *_tapGestOpenMap;
    UITapGestureRecognizer *_tapGestEnterCompanyDetail;
    UITapGestureRecognizer *_tapGestEnterOldCompanyDetail;
    UITapGestureRecognizer *_tapGestEnterPersonDetail;
    
    //NSMutableArray          *_snTypes;
    BOOL                    _isTabbarHiddenWhenLoaded;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cellDatas = [NSMutableArray array];
        //_snTypes = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc
{
    _isTabbarHiddenWhenLoaded ? [GGUtils hideTabBarAnimated:YES] : [GGUtils showTabBarAnimated:YES];
}


#pragma mark -
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

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isTabbarHiddenWhenLoaded = GGSharedDelegate.tabBarController.isTabbarHidden;
    [GGUtils hideTabBarAnimated:YES];
    
    self.naviTitle = @"Happening";
    self.svContent.frame = [self viewportAdjsted];
    self.view.backgroundColor = GGSharedColor.silver;
    self.tvDetail.backgroundColor = GGSharedColor.silver;
    
    // init gesture recgnizers
    [self _initGestures];
    
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
    
    //
    
    [self _callApiGetHappeningDetail];
    _svContent.hidden = YES;
    
    [self _callApiGetSnList];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

- (void)viewDidUnload {
    [self setTvDetail:nil];
    [self setViewBottomBar:nil];
    [self setSvContent:nil];
    [super viewDidUnload];
}

#pragma mark -navi buttons
-(void)prevUpdateAction:(id)sender
{
    if (_happeningIndex > 0) {
        _happeningIndex--;
        [self _callApiGetHappeningDetail];
        
        [self _updateNaviBtnState];
    }
}

-(void)nextUpdateAction:(id)sender
{
    if (_happeningIndex < _happenings.count - 1) {
        _happeningIndex++;
        [self _callApiGetHappeningDetail];
        
        [self _updateNaviBtnState];
    }
}

-(void)_updateNaviBtnState
{
    _btnPrevUpdate.enabled = (_happeningIndex > 0);
    _btnNextUpdate.enabled = (_happeningIndex < _happenings.count - 1);
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
    [controller setSubject:[_currentDetail headLineText]];
    
    NSString *contentBody = [NSString stringWithFormat:@"<div><p>I want to share this update with you.</p> \
                             <p><strong>%@</strong></p> \
                             Shared from <a href=\"www.gagein.com\">GageIn</a>, %@ </div>"
                             
                             , [_currentDetail headLineText], GAGEIN_SLOGAN];
    
    
    [controller setMessageBody:contentBody isHTML:YES];
    
    [GGSharedDelegate makeNaviBarCustomed:NO];
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(IBAction)sendSMSAction:(id)sender
{
    NSString *body = [NSString stringWithFormat:@"%@\n\nvia Gagein at www.gagein.com", [_currentDetail headLineText]];
    [GGUtils sendSmsTo:nil body:body vcDelegate:self];
    [GGSharedDelegate makeNaviBarCustomed:NO];
}

-(IBAction)shareAction:(id)sender
{
    [self _showSheetToShare];
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
        
        [self _shareWithType:kGGSnTypeTwitter];
        
    }];
    
    bgImg = [UIImage imageNamed:@"lightGrayBtnBg"];//[UIImage imageNamed:@"facebookLongBtnBg"];
    [actionSheet addButtonWithTitle:@"Facebook" bgImage:bgImg block:^{
        
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



-(void)_shareWithType:(EGGSnType)aType
{
    GGSnShareVC *vc = [[GGSnShareVC alloc] init];
    vc.happening = _currentDetail;
    vc.snType = aType;
    vc.snTypesRef = GGSharedRuntimeData.snTypes;
    vc.shareType = _isPeopleHappening ? kGGSnShareTypeHappeningPerson : kGGSnShareTypeHappeningCompany;
    
    [self.navigationController pushViewController:vc animated:YES];
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

-(void)_initGestures
{
    _tapGestOpenChart = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openChartAction:)];
    _tapGestOpenMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMapAction:)];
    _tapGestEnterCompanyDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterCompanyDetailAction:)];
    _tapGestEnterOldCompanyDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterOldCompanyDetailAction:)];
    _tapGestEnterPersonDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPersonDetailAction:)];
}

-(void)openChartAction:(id)sender
{
    //DLog(@"Open the chart");
    CGSize chartSize = [UIScreen mainScreen].applicationFrame.size;
    float width = MAX(chartSize.width, chartSize.height);
    float height = MIN(chartSize.width, chartSize.height);
    NSString *chartUrl = [_currentDetail chartUrlWithSize:CGSizeMake(width, height)];
    
    [self presentImageWithURL:chartUrl];
}

-(void)openMapAction:(id)sender
{
    //DLog(@"Open the map");
    CGSize chartSize = [UIScreen mainScreen].applicationFrame.size;
    float width = MAX(chartSize.width, chartSize.height);
    float height = MIN(chartSize.width, chartSize.height);
    NSString *chartUrl = [GGUtils stringWithMapUrl:_currentDetail.addressMap width:width height:height];
    
    [self presentImageWithURL:chartUrl];
}

-(void)enterCompanyDetailAction:(id)sender
{
   // DLog(@"enter company detail");
    
    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
    vc.companyID = _currentDetail.company.ID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)enterOldCompanyDetailAction:(id)sender
{
   // DLog(@"enter old company's detail");
    
    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
    vc.companyID = _currentDetail.oldCompany.ID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)enterPersonDetailAction:(id)sender
{
    //DLog(@"enter person's detail");
    
    GGPersonDetailVC *vc = [[GGPersonDetailVC alloc] init];
    vc.personID = _currentDetail.person.ID;
    
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - UITableViewDataSource

-(GGHappeningDetailCell *)detailCell
{
    if (_happeningDetailCell == nil)
    {
        _happeningDetailCell = [GGHappeningDetailCell viewFromNibWithOwner:self];
    }
    
    [_happeningDetailCell reset];
    
    _happeningDetailCell.lblSource.text = _currentDetail.sourceText;
    _happeningDetailCell.lblHeadline.text = _currentDetail.headLineText;
    _happeningDetailCell.lblInterval.text = [_currentDetail intervalStringWithDate:_currentDetail.timestamp];
    
    switch (_currentDetail.type)
    {
        case kGGHappeningCompanyPersonJion:
        {
            [_happeningDetailCell showChangeView:YES];
            [_happeningDetailCell showChangeLeftImage:YES];
            [_happeningDetailCell showChangeRightImage:YES];
            
            NSString *leftPhotoPath = [_currentDetail isJoin] ? _currentDetail.person.photoPath : _currentDetail.oldCompany.logoPath;
            NSString *rightPhotoPath = [_currentDetail isJoin] ? _currentDetail.company.logoPath : _currentDetail.person.photoPath;
            
            [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:leftPhotoPath] placeholderImage:GGSharedImagePool.logoDefaultPerson];
            [_happeningDetailCell.ivChangeLeft addGestureRecognizer:_tapGestEnterPersonDetail];
            
            [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:rightPhotoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
            [_happeningDetailCell.ivChangeRight addGestureRecognizer:_tapGestEnterCompanyDetail];
            
        }
            break;
            
        case kGGHappeningCompanyPersonJionDetail:
        {
            [_happeningDetailCell showChangeView:YES];
            [_happeningDetailCell showChangeLeftImage:YES];
            [_happeningDetailCell showChangeRightImage:YES];
            
            [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.person.photoPath] placeholderImage:GGSharedImagePool.logoDefaultPerson];
            [_happeningDetailCell.ivChangeLeft addGestureRecognizer:_tapGestEnterPersonDetail];
            
            [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:_currentDetail.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
            [_happeningDetailCell.ivChangeRight addGestureRecognizer:_tapGestEnterCompanyDetail];
        }
            break;
            
        case kGGHappeningCompanyRevenueChange:
        {
            [_happeningDetailCell showChart:YES];
            [_happeningDetailCell showChangeLeftImage:YES];
            [_happeningDetailCell showChangeRightImage:YES];
            //#warning TODO: show chart image
            CGSize chartSize = _happeningDetailCell.ivChart.frame.size;
            NSString *chartUrl = [_currentDetail chartUrlWithSize:chartSize];
            [_happeningDetailCell.ivChart setImageWithURL:[NSURL URLWithString:chartUrl] placeholderImage:GGSharedImagePool.placeholder];
            [_happeningDetailCell.ivChart addGestureRecognizer:_tapGestOpenChart];
        }
            break;
            
        case kGGHappeningCompanyNewFunding:
        {
            [_happeningDetailCell showChangeView:YES];
            [_happeningDetailCell showChangeLeftText:YES];
            [_happeningDetailCell showChangeRightImage:YES];
            
            _happeningDetailCell.lblChangeLeftTitle.text = [NSString stringWithFormat:@"$ %@ Million", _currentDetail.funding];
            _happeningDetailCell.lblChangeLeftSubTitle.text = [NSString stringWithFormat:@"%@-round", _currentDetail.round];
            
            [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:_currentDetail.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
            [_happeningDetailCell.ivChangeRight addGestureRecognizer:_tapGestEnterCompanyDetail];
        }
            break;
            
        case kGGHappeningCompanyNewLocation:
        {
            [_happeningDetailCell showChangeView:YES];
            [_happeningDetailCell showChangeLeftImage:YES];
            [_happeningDetailCell showChangeRightImage:YES];
            
            [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
            [_happeningDetailCell.ivChangeLeft addGestureRecognizer:_tapGestEnterCompanyDetail];
            
            NSString *mapUrl = [GGUtils stringWithMapUrl:_currentDetail.addressMap width:70 height:70];
            [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:mapUrl] placeholderImage:GGSharedImagePool.placeholder];
            [_happeningDetailCell.ivChangeRight addGestureRecognizer:_tapGestOpenMap];
        }
            break;
            
        case kGGHappeningCompanyEmloyeeSizeIncrease:
        case kGGHappeningCompanyEmloyeeSizeDecrease:
        {
            [_happeningDetailCell showChangeView:YES];
            [_happeningDetailCell showChangeLeftText:YES];
            [_happeningDetailCell showChangeRightText:YES];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
            formatter.groupingSize = 3;
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            
            NSString *oldEmployeeSizeStr = [formatter stringFromNumber:__LONGLONG(_currentDetail.oldEmployNum.longLongValue)];
            NSString *newEmployeeSizeStr = [formatter stringFromNumber:__LONGLONG(_currentDetail.employNum.longLongValue)];
            
            _happeningDetailCell.lblChangeLeftTitle.text = oldEmployeeSizeStr;
            _happeningDetailCell.lblChangeRightTitle.text = newEmployeeSizeStr;
            
            //
            NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970: (_currentDetail.oldTimestamp / 1000)];
            NSDate *newDate = [NSDate dateWithTimeIntervalSince1970: (_currentDetail.timestamp / 1000)];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //dd MMM yyyy
            //[dateFormatter setDateFormat:@"emplorees on\nMM/dd/yyyy"];
            dateFormatter.dateFormat = @"MMM d, yyyy";
            NSString *oldDateStr = [dateFormatter stringFromDate:oldDate];
            NSString *newDateStr = [dateFormatter stringFromDate:newDate];
            
            _happeningDetailCell.lblChangeLeftSubTitle.text = [NSString stringWithFormat:@"employees on\n%@", oldDateStr];
            _happeningDetailCell.lblChangeRightSubTitle.text = [NSString stringWithFormat:@"employees on\n%@", newDateStr];
        }
            break;
            
            
            // ------------ person cases ------------------
        case kGGHappeningPersonUpdateProfilePic:
        {
            [_happeningDetailCell showChangeView:YES];
            [_happeningDetailCell showChangeLeftImage:YES];
            [_happeningDetailCell showChangeRightImage:YES];
            
            [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.oldProfilePic] placeholderImage:GGSharedImagePool.logoDefaultPerson];
            [_happeningDetailCell.ivChangeLeft addGestureRecognizer:_tapGestEnterPersonDetail];
            
            [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:_currentDetail.profilePic] placeholderImage:GGSharedImagePool.logoDefaultPerson];
            [_happeningDetailCell.ivChangeRight addGestureRecognizer:_tapGestEnterPersonDetail];
        }
            break;
            
        case kGGHappeningPersonJoinOtherCompany:
        {
            [_happeningDetailCell showChangeView:YES];
            [_happeningDetailCell showChangeLeftImage:YES];
            [_happeningDetailCell showChangeRightImage:YES];
            
            [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.person.photoPath] placeholderImage:GGSharedImagePool.logoDefaultPerson];
            [_happeningDetailCell.ivChangeLeft addGestureRecognizer:_tapGestEnterPersonDetail];
            
            [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:_currentDetail.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
            [_happeningDetailCell.ivChangeRight addGestureRecognizer:_tapGestEnterCompanyDetail];
            
        }
            break;
            
        case kGGHappeningPersonNewLocation:
        {
            [_happeningDetailCell showChangeView:YES];
            [_happeningDetailCell showChangeLeftImage:YES];
            [_happeningDetailCell showChangeRightImage:YES];
            
            [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.person.photoPath] placeholderImage:GGSharedImagePool.logoDefaultPerson];
            [_happeningDetailCell.ivChangeLeft addGestureRecognizer:_tapGestEnterPersonDetail];
            
            NSString *mapUrl = [GGUtils stringWithMapUrl:_currentDetail.addressMap width:70 height:70];
            
            
            [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:mapUrl] placeholderImage:GGSharedImagePool.placeholder];
            [_happeningDetailCell.ivChangeRight addGestureRecognizer:_tapGestOpenMap];
        }
            break;
            
        case kGGHappeningPersonNewJobTitle:
        {
            [_happeningDetailCell showChangeView:YES];
            [_happeningDetailCell showChangeLeftImage:YES];
            [_happeningDetailCell showChangeRightImage:YES];
            
            //
            [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.person.photoPath] placeholderImage:GGSharedImagePool.logoDefaultPerson];
            [_happeningDetailCell.ivChangeLeft addGestureRecognizer:_tapGestEnterPersonDetail];
            
            //
            [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:_currentDetail.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
            [_happeningDetailCell.ivChangeRight addGestureRecognizer:_tapGestEnterCompanyDetail];
        }
            break;
            
        default:
            break;
    }
    
    [_happeningDetailCell adjustLayout];
    
    return _happeningDetailCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 1 + _cellDatas.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0)
    {
        return [self detailCell];
        
    } else {
        
        static NSString *updateCellId = @"GGCustomBriefCell";
        GGCustomBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
        if (cell == nil) {
            cell = [GGCustomBriefCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGCellData *data = _cellDatas[row - 1];
        
        cell.lblName.text = data.name;
        cell.lblTitle.text = data.title;
        cell.lblAddress.text = data.address;
        cell.type = data.type;
        [cell loadLogoWithImageUrl:data.picUrl placeholder:(data.type == kGGCustomBriefCellCompany ? GGSharedImagePool.logoDefaultCompany : GGSharedImagePool.logoDefaultPerson)];
        
        return cell;
        
    }
    
    return nil;
}

#pragma mark - table view delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0)
    {
        return [self detailCell].height;
    }
    
    return [GGCustomBriefCell HEIGHT];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row > 0)
    {
        //GGCustomBriefCell *cell = (GGCustomBriefCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        GGCellData *data = _cellDatas[row - 1];
        if (data.type == kGGCustomBriefCellCompany)
        {
            GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
            vc.companyID = data.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            GGPersonDetailVC *vc = [[GGPersonDetailVC alloc] init];
            vc.personID = data.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - API calls
-(void)_callApiGetHappeningDetail
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        _svContent.hidden = NO;
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _currentDetail = [parser parseCompanyEventDetail];
            
            // cell datas
            [_cellDatas removeAllObjects];
            
            if (_currentDetail.person.ID)
            {
                GGCellData *data = [[GGCellData alloc] init];
                data.ID = _currentDetail.person.ID;
                data.name = _currentDetail.person.name;
                data.title = _currentDetail.person.orgTitle;
                data.address = _currentDetail.person.address;
                data.picUrl = _currentDetail.person.photoPath;
                data.type = kGGCustomBriefCellPerson;
                
                [_cellDatas addObject:data];
            }
            
            if (_currentDetail.company.ID)
            {
                GGCellData *data = [[GGCellData alloc] init];
                data.ID = _currentDetail.company.ID;
                data.name = _currentDetail.company.name;
                data.title = _currentDetail.company.website;
                data.address = [_currentDetail.company addressCityStateCountry];
                data.picUrl = _currentDetail.company.logoPath;
                data.type = kGGCustomBriefCellCompany;
                
                [_cellDatas addObject:data];
            }
            
            if (_currentDetail.oldCompany.ID)
            {
                GGCellData *data = [[GGCellData alloc] init];
                data.ID = _currentDetail.oldCompany.ID;
                data.name = _currentDetail.oldCompany.name;
                data.title = _currentDetail.oldCompany.website;
                data.address = [_currentDetail.oldCompany addressCityStateCountry];
                data.picUrl = _currentDetail.oldCompany.logoPath;
                data.type = kGGCustomBriefCellCompany;
                
                [_cellDatas addObject:data];
            }
        }
        
        [_tvDetail reloadData];
    };
    
    GGHappening *data = _happenings[_happeningIndex];
    
    [self showLoadingHUD];
    if (_isPeopleHappening)
    {
        id op = [GGSharedAPI getPeopleEventDetailWithID:data.ID callback:callback];
        [self registerOperation:op];
    }
    else
    {
        id op = [GGSharedAPI getCompanyEventDetailWithID:data.ID callback:callback];
        [self registerOperation:op];
    }
    
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

//#pragma mark - notification
//- (void)handleNotification:(NSNotification *)notification
//{
//    NSString *notiName = notification.name;
//    if ([notiName isEqualToString:OA_NOTIFY_LINKEDIN_AUTH_OK])
//    {
//        [self unobserveNotification:OA_NOTIFY_LINKEDIN_AUTH_OK];
//        
//        [self showLoadingHUD];
//        id op = [GGSharedAPI snSaveLinedInWithToken:self.linkedInAuthView.accessToken.key secret:self.linkedInAuthView.accessToken.secret callback:^(id operation, id aResultObject, NSError *anError) {
//            [self hideLoadingHUD];
//            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//            if (parser.isOK)
//            {
//                [GGUtils addSnType:kGGSnTypeLinkedIn];
//                [self _shareWithType:kGGSnTypeLinkedIn];
//                //#warning TODO: Enter a page to change message and share
//            }
//        }];
//        
//        [self registerOperation:op];
//        
//    }
//    else if ([notiName isEqualToString:OA_NOTIFY_FACEBOOK_AUTH_OK])
//    {
//        FBSession *session = notification.object;
//        NSString *accessToken = session.accessTokenData.accessToken;//[GGFacebookOAuth sharedInstance].session.accessTokenData.accessToken;
//        
//        [self showLoadingHUD];
//        id op = [GGSharedAPI snSaveFacebookWithToken:accessToken callback:^(id operation, id aResultObject, NSError *anError) {
//            [self hideLoadingHUD];
//            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//            if (parser.isOK)
//            {
//                [GGUtils addSnType:kGGSnTypeFacebook];
//                [self _shareWithType:kGGSnTypeFacebook];
//            }
//        }];
//        
//        [self registerOperation:op];
//    }
//    else if ([notiName isEqualToString:OA_NOTIFY_SALESFORCE_AUTH_OK]) // salesforce ok
//    {
//        SFOAuthCredentials *credencial = notification.object;
//        
//        [self showLoadingHUD];
//        id op = [GGSharedAPI snSaveSalesforceWithToken:credencial.accessToken accountID:credencial.userId refreshToken:credencial.refreshToken instanceURL:credencial.instanceUrl.absoluteString callback:^(id operation, id aResultObject, NSError *anError) {
//            
//            [self hideLoadingHUD];
//            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//            
//            if (parser.isOK)
//            {
//                [GGUtils addSnType:kGGSnTypeSalesforce];
//                [self _shareWithType:kGGSnTypeSalesforce];
//            }
//            else if (parser.messageCode == kGGMsgCodeSnSaleforceCantAuth)
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[GGStringPool stringWithMessageCode:kGGMsgCodeSnSaleforceCantAuth] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Learn more", nil];
//                alert.tag = TAG_ALERT_SALESFORCE_OAUTH_FAILED;
//                [alert show];
//            }
//            
//        }];
//        
//        [self registerOperation:op];
//    }
//    else if ([notiName isEqualToString:OA_NOTIFY_TWITTER_OAUTH_OK]) // twitter oauth ok
//    {
//        OAToken *token = notification.object;
//        
//        [self showLoadingHUD];
//        id op = [GGSharedAPI snSaveTwitterWithToken:token.key secret:token.secret callback:^(id operation, id aResultObject, NSError *anError) {
//            
//            [self hideLoadingHUD];
//            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//            if (parser.isOK)
//            {
//                [GGUtils addSnType:kGGSnTypeTwitter];
//                [self _shareWithType:kGGSnTypeTwitter];
//            }
//            
//        }];
//        
//        [self registerOperation:op];
//    }
//}

//#pragma mark - ui alertview delegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == TAG_ALERT_SALESFORCE_OAUTH_FAILED)
//    {
//        if (buttonIndex == 1)
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.salesforce.com/crm/editions-pricing.jsp"]];
//        }
//    }
//}

#pragma mark - 
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [self _setNextBtnRect];
    [self _setPrevBtnRect];
    
    [_tvDetail centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

@end
