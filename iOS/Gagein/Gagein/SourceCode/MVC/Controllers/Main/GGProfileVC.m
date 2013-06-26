//
//  GGProfileVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileVC.h"
#import "GGProfileHeaderView.h"
#import "GGProfileFooterView.h"

#import "GGProfileEditNameVC.h"
#import "GGProfileEditEmailVC.h"
#import "GGProfileEditCompanyVC.h"
#import "GGProfileEditJobTitleVC.h"
#import "GGProfileEditTimeZoneVC.h"

#import "GGUserProfile.h"
#import "GGGroupedCell.h"

@interface GGProfileVC ()
@property (weak, nonatomic) IBOutlet UITableView *tvProfile;

@end

@implementation GGProfileVC
{
    GGProfileHeaderView *_viewHeader;
    GGProfileFooterView *_viewFooter;
    GGUserProfile       *_userProfile;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Profile";
        self.tabBarItem.image = [UIImage imageNamed:@"Players"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"My Profile";
    self.view.backgroundColor = GGSharedColor.silver;
    self.tvProfile.backgroundColor = GGSharedColor.silver;
    //_tvProfile.backgroundColor = GGSharedColor.random;
    _tvProfile.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tvProfile.showsVerticalScrollIndicator = NO;
    //_tvProfile.rowHeight = [GGGroupedCell HEIGHT];
    
    _viewHeader = [GGProfileHeaderView viewFromNibWithOwner:self];
    _viewFooter = [GGProfileFooterView viewFromNibWithOwner:self];
    [_viewFooter.btnUpgrade addTarget:self action:@selector(upgradeMembershipAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self _callApiGetMyOverview];
}

-(void)viewWillAppearNotFirstTimeAction
{
    [_tvProfile reloadData];
}

- (void)viewDidUnload {
    [self setTvProfile:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(IBAction)upgradeMembershipAction:(id)sender
{
    [GGSharedAPI sendUpgradeLink:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            // give user a message
            [GGAlert alertWithMessage:@"Congratulations! We have sent the link to you via Email! Please check your Email and follow the instruction in it."];
        }
    }];
}

#pragma mark - table view datasource
-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 5;
    }
    
    return 1;
}

-(UITableViewCell *)_cellForHeader
{
    static UITableViewCell *cell = nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.contentView addSubview:_viewHeader];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(UITableViewCell *)_cellForFooter
{
    static UITableViewCell *cell = nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.contentView addSubview:_viewFooter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == 0) // header
    {
        return [self _cellForHeader];
    }
    else if (section == 2)  // foooter
    {
        _viewFooter.lblCurrentPlan.text = [NSString stringWithFormat:@"Current Plan: %@", _userProfile.planName];
        return [self _cellForFooter];
    }
    
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
        [cell showDisclosure];
        [cell showSubTitle:YES];
    }
    
    if (row == 0) {
        
        cell.lblTitle.text = @"Name";
        if (_userProfile.firstName && _userProfile.lastName)
        {
            cell.lblSubTitle.text = [NSString stringWithFormat:@"%@ %@", _userProfile.firstName, _userProfile.lastName];
        }
        
        cell.style = kGGGroupCellFirst;
        
    } else if (row == 1) {
        
        cell.lblTitle.text = @"Email";
        cell.lblSubTitle.text = _userProfile.email;
        cell.style = kGGGroupCellMiddle;
        
    } else if (row == 2) {
        
        cell.lblTitle.text = @"Company";
        cell.lblSubTitle.text = _userProfile.orgName;
        cell.style = kGGGroupCellMiddle;
        
    } else if (row == 3) {
        
        cell.lblTitle.text = @"Job Title";
        cell.lblSubTitle.text = _userProfile.orgTitle;
        cell.style = kGGGroupCellMiddle;
        
    } else if (row == 4) {
        
        cell.lblTitle.text = @"Time Zone";
        cell.lblSubTitle.text = _userProfile.timezoneGMT;
        cell.style = kGGGroupCellLast;
        
    }
    
    return cell;
}

#pragma mark - table view delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    if (section == 0)
    {
        return [GGProfileHeaderView HEIGHT];
    }
    else if (section == 1)
    {
        return [GGGroupedCell HEIGHT];
    }
    else if (section == 2)
    {
        return [GGProfileFooterView HEIGHT];
    }
    
    return 0.f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return [GGProfileHeaderView HEIGHT];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return [GGProfileFooterView HEIGHT];
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//    return _viewFooter;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 1)
    {
        return;
    }
    
    int row = indexPath.row;
    
    if (row == 0) {
        
        GGProfileEditNameVC *vc = [[GGProfileEditNameVC alloc] init];
        vc.userProfile = _userProfile;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 1) {
        
        GGProfileEditEmailVC *vc = [[GGProfileEditEmailVC alloc] init];
        vc.userProfile = _userProfile;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 2) {
        
        GGProfileEditCompanyVC *vc = [[GGProfileEditCompanyVC alloc] init];
        vc.userProfile = _userProfile;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 3) {
        
        GGProfileEditJobTitleVC *vc = [[GGProfileEditJobTitleVC alloc] init];
        vc.userProfile = _userProfile;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 4) {
        
        GGProfileEditTimeZoneVC *vc = [[GGProfileEditTimeZoneVC alloc] init];
        vc.userProfile = _userProfile;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - api
-(void)_callApiGetMyOverview
{
    [self showLoadingHUD];
    id op = [GGSharedAPI getMyOverview:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _userProfile = [parser parseGetMyOverview];
        [_tvProfile reloadData];
    }];
    
    [self registerOperation:op];
}

#pragma mark - orientation change
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_tvProfile centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

@end
