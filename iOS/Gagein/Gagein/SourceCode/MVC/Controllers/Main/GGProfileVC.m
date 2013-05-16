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
    self.tvProfile.backgroundColor = GGSharedColor.silver;
    _tvProfile.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tvProfile.rowHeight = [GGGroupedCell HEIGHT];
    
    _viewHeader = [GGProfileHeaderView viewFromNibWithOwner:self];
    _viewFooter = [GGProfileFooterView viewFromNibWithOwner:self];
    
    [self _callApiGetMyOverview];
}

- (void)viewDidUnload {
    [self setTvProfile:nil];
    [super viewDidUnload];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
        [cell showDisclosure];
        [cell showSubTitle:YES];
    }

    
    int row = indexPath.row;
    //int section = indexPath.section;
    
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
        cell.lblSubTitle.text = @"UTC-12";
        cell.style = kGGGroupCellLast;
        
    }
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [GGProfileHeaderView HEIGHT];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [GGProfileFooterView HEIGHT];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _viewHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _viewFooter;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = indexPath.row;
    
    if (row == 0) {
        
        GGProfileEditNameVC *vc = [[GGProfileEditNameVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 1) {
        
        GGProfileEditEmailVC *vc = [[GGProfileEditEmailVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 2) {
        
        GGProfileEditCompanyVC *vc = [[GGProfileEditCompanyVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 3) {
        
        GGProfileEditJobTitleVC *vc = [[GGProfileEditJobTitleVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 4) {
        
        GGProfileEditTimeZoneVC *vc = [[GGProfileEditTimeZoneVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - api
-(void)_callApiGetMyOverview
{
    [self showLoadingHUD];
    [GGSharedAPI getMyOverview:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _userProfile = [parser parseGetMyOverview];
        [_tvProfile reloadData];
    }];
}

@end
