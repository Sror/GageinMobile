//
//  GGSettingVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSettingVC.h"
#import "GGAppDelegate.h"
#import "GGAPITest.h"
#import "GGSelectAgentsVC.h"
#import "GGSelectFuncAreasVC.h"
#import "GGFollowCompanyVC.h"
#import "GGWebVC.h"
#import "GGProfileVC.h"
#import "GGGroupedCell.h"
#import "GGConfigLabel.h"

#define FOOTER_HEIGHT   80

@interface GGSettingVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;
@property (weak, nonatomic) IBOutlet UITableView *tvSettings;


@end

@implementation GGSettingVC
{
    UIView *_viewFooter;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.tabBarItem.title = @"Settings";
        //self.tabBarItem.image = [UIImage imageNamed:@"Gestures"];
    }
    return self;
}

-(UIView *)_footerView
{
    if (_viewFooter == nil) {
        _viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tvSettings.frame.size.width, FOOTER_HEIGHT)];
        
        float btnW = 260.f, btnH = 35.f;
        UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnLogout.frame = CGRectMake((_viewFooter.frame.size.width - btnW) / 2, (_viewFooter.frame.size.height - btnH) / 2, btnW, btnH);
        [btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
        [btnLogout setTitleColor:GGSharedColor.white forState:UIControlStateNormal];
        [btnLogout setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
        [btnLogout addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        [_viewFooter addSubview:btnLogout];
    }
    
    return _viewFooter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"Settings";
    self.svContent.backgroundColor = GGSharedColor.silver;
    self.tvSettings.backgroundColor = GGSharedColor.silver;
    _tvSettings.rowHeight = [GGGroupedCell HEIGHT];
    _tvSettings.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidUnload {
    [self setSvContent:nil];
    [self setTvSettings:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(IBAction)logoutAction:(id)sender
{
    [GGSharedRuntimeData resetCurrentUser];
    [GGSharedDelegate enterLoginIfNeeded];
    
    [self postNotification:GG_NOTIFY_LOG_OUT];
}

-(IBAction)apiTestAction:(id)sender
{
    [[GGAPITest sharedInstance] run];
}

//-(IBAction)setupAgentsAction:(id)sender
//{
//    [self presentPageSelectAgents];
//}
//
//-(IBAction)setupAreasAction:(id)sender
//{
//    [self presentPageSelectFuncArea];
//}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    
//    else if (section == 1)
//    {
//        return 2;
//    }
    
    else if (section == 1)
    {
        return 3;
    }
    
    else if (section == 2)
    {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //GGGroupedCell
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
    }
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    [cell showSubTitle:NO];
    [cell showDisclosure];
    
    if (section == 0) {
        
        cell.lblTitle.text = @"My Profile";
        cell.style = kGGGroupCellRound;
    }
    
//    else if (section == 1)
//    {
//        
//        if (row == 0) {
//            cell.textLabel.text = @"People Updates";
//        } else {
//            cell.textLabel.text = @"Company Updates";
//        }
//        cell.detailTextLabel.text = @"";
//        
//    }
    
    else if (section == 1) {
        
        if (row == 0) {
            
            [cell showSubTitle:YES];
            cell.lblTitle.text = @"Version";
            cell.lblSubTitle.text = [GGUtils appVersion];
            cell.style = kGGGroupCellFirst;
            [cell hideAllAccessory];
            
        } else if (row == 1) {
            cell.lblTitle.text = @"Privacy";
            cell.style = kGGGroupCellMiddle;
        } else if (row == 2) {
            cell.lblTitle.text = @"Terms";
            cell.style = kGGGroupCellLast;
        }
        
    }
    
    else if (section == 2) {
        cell.lblTitle.text = @"API Test";
        cell.style = kGGGroupCellRound;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 3;
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [GGUtils envString];
    }
    
//    else if (section == 1) {
//        return @"NOTIFICATIONS";
//    }
    
    else if (section == 1) {
        return @"ABOUT";
    }
    
    else if (section == 2) {
        return @"TEST";
    }
    
    return nil;
}

#pragma mark - table view delegate
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [GGConfigLabel HEIGHT];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GGConfigLabel *configLabel = [GGConfigLabel viewFromNibWithOwner:self];
    
    if (section == 0) {
        configLabel.lblText.text = [GGUtils envString];
    }
    
    //    else if (section == 1) {
    //        return @"NOTIFICATIONS";
    //    }
    
    else if (section == 1) {
        configLabel.lblText.text = @"ABOUT";
    }
    
    else if (section == 2) {
        configLabel.lblText.text = @"TEST";
    }
    
    return configLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == 0) {
        
        GGProfileVC *vc = [[GGProfileVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
//    else if (section == 1) {
//        
//        if (row == 0) {
//            //@"People Updates";
//        } else {
//            //@"Company Updates";
//        }
//        
//    }
    
    else if (section == 1) {
        
        if (row == 0) {
            //@"Version";
//#warning TODO: Need a way to get app version
            [GGSharedDelegate checkForUpgrade];
            
        } else if (row == 1) {

            GGWebVC *vc = [[GGWebVC alloc] init];
            vc.urlStr = [NSString stringWithFormat:@"%@/privacy", CURRENT_SERVER_URL];
            vc.naviTitleString = @"Privacy";
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (row == 2) {

            GGWebVC *vc = [[GGWebVC alloc] init];
            vc.urlStr = [NSString stringWithFormat:@"%@/tou", CURRENT_SERVER_URL];
            vc.naviTitleString = @"Terms";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
    
    else if (section == 2) {
        [self apiTestAction:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return [self _footerView];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return [self _footerView].frame.size.height;
    }
    
    return 0;
}

#pragma mark - orientation handling
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_tvSettings centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

@end
