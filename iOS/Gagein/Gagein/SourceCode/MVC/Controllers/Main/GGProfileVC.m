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
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.detailTextLabel.text = @"";
    
    int row = indexPath.row;
    //int section = indexPath.section;
    
    if (row == 0) {
        
        cell.textLabel.text = @"Name";
        cell.detailTextLabel.text = _userProfile.fullName;
        
    } else if (row == 1) {
        
        cell.textLabel.text = @"Email";
        cell.detailTextLabel.text = _userProfile.email;
        
    } else if (row == 2) {
        
        cell.textLabel.text = @"Company";
        cell.detailTextLabel.text = _userProfile.orgName;
        
    } else if (row == 3) {
        
        cell.textLabel.text = @"Job Title";
        cell.detailTextLabel.text = _userProfile.orgTitle;
        
    } else if (row == 4) {
        
        cell.textLabel.text = @"Time Zone";
        cell.detailTextLabel.text = @"UTC-12";
        
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
