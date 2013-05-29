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
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cellDatas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"Happening";
    self.svContent.frame = [self viewportAdjsted];
    self.tvDetail.backgroundColor = GGSharedColor.silver;
    
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
    _happeningDetailCell = [GGHappeningDetailCell viewFromNibWithOwner:self];
    
    [self _callApiGetHappeningDetail];
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
                             Shared from <a href=\"www.gagein.com\">GageIn</a>, a visual sales intelligence company </div>"
                             , [_currentDetail headLineText]];
    
    
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
            }
                break;
                
            case kGGHappeningCompanyPersonJionDetail:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];
            }
                break;
                
            case kGGHappeningCompanyRevenueChange:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];
#warning TODO: show chart image
            }
                break;
                
            case kGGHappeningCompanyNewFunding:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftText:YES];
                [_happeningDetailCell showChangeRightImage:YES];
                
                _happeningDetailCell.lblChangeLeftTitle.text = [NSString stringWithFormat:@"$ %@ Million", _currentDetail.funding];
                _happeningDetailCell.lblChangeLeftSubTitle.text = [NSString stringWithFormat:@"%@-round", _currentDetail.round];
                
                [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:_currentDetail.company.orgLogoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
            }
                break;
                
            case kGGHappeningCompanyNewLocation:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];
            }
                break;
                
            case kGGHappeningCompanyEmloyeeSizeIncrease:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];
            }
                break;
                
            case kGGHappeningCompanyEmloyeeSizeDecrease:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];
            }
                break;
                
// ------------ person cases ------------------
            case kGGHappeningPersonUpdateProfilePic:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];
                
                [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.oldProfilePic] placeholderImage:GGSharedImagePool.logoDefaultPerson];
                [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:_currentDetail.profilePic] placeholderImage:GGSharedImagePool.logoDefaultPerson];
                
            }
                break;
                
            case kGGHappeningPersonJoinOtherCompany:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];

                [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.person.photoPath] placeholderImage:GGSharedImagePool.logoDefaultPerson];
                [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:_currentDetail.company.orgLogoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
                
            }
                break;
                
            case kGGHappeningPersonNewLocation:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];
                
                [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.person.photoPath] placeholderImage:GGSharedImagePool.logoDefaultPerson];
                
                NSString *mapUrl = [GGUtils stringWithMapUrl:_currentDetail.addressMap width:70 height:70];
                
                
                [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:mapUrl] placeholderImage:GGSharedImagePool.placeholder];
            }
                break;
                
            case kGGHappeningPersonNewJobTitle:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];
                
                [_happeningDetailCell.ivChangeLeft setImageWithURL:[NSURL URLWithString:_currentDetail.person.photoPath] placeholderImage:GGSharedImagePool.logoDefaultPerson];
                [_happeningDetailCell.ivChangeRight setImageWithURL:[NSURL URLWithString:_currentDetail.company.orgLogoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
            }
                break;
                
            default:
                break;
        }
        
        return _happeningDetailCell;
        
    } else {
        
        static NSString *updateCellId = @"GGPersonCell";
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
        [cell.ivPhoto setImageWithURL:[NSURL URLWithString:data.picUrl] placeholderImage:
         (data.type == kGGCustomBriefCellCompany ? GGSharedImagePool.logoDefaultCompany : GGSharedImagePool.logoDefaultPerson)];
        
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
        return _happeningDetailCell.height;
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
                data.title = _currentDetail.company.orgWebSite;
                data.address = [_currentDetail.company addressCityStateCountry];
                data.picUrl = _currentDetail.company.orgLogoPath;
                data.type = kGGCustomBriefCellCompany;
                
                [_cellDatas addObject:data];
            }
            
            if (_currentDetail.oldCompany.ID)
            {
                GGCellData *data = [[GGCellData alloc] init];
                data.ID = _currentDetail.oldCompany.ID;
                data.name = _currentDetail.oldCompany.name;
                data.title = _currentDetail.oldCompany.orgWebSite;
                data.address = [_currentDetail.oldCompany addressCityStateCountry];
                data.picUrl = _currentDetail.oldCompany.orgLogoPath;
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

@end
