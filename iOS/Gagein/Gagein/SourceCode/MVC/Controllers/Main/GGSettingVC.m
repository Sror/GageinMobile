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
        
        float btnW = 250.f, btnH = 45.f;
        UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnLogout.frame = CGRectMake((_viewFooter.frame.size.width - btnW) / 2, (_viewFooter.frame.size.height - btnH) / 2, btnW, btnH);
        [btnLogout setTitle:@"Logout" forState:UIControlStateNormal];
        [btnLogout addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        [_viewFooter addSubview:btnLogout];
    }
    
    return _viewFooter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"Settings";
    self.tvSettings.backgroundColor = GGSharedColor.silver;
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

-(IBAction)setupAgentsAction:(id)sender
{
    GGSelectAgentsVC *vc = [[GGSelectAgentsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)setupAreasAction:(id)sender
{
    //GGSelectFuncAreasVC *vc = [[GGSelectFuncAreasVC alloc] init];
    
    GGFollowCompanyVC *vc = [[GGFollowCompanyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 3;
    }
    
    else if (section == 3) {
        return 1;
    }
    
    return 0;
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
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == 0) {
        
        cell.textLabel.text = @"My Profile";
        cell.detailTextLabel.text = @"";
        
    } else if (section == 1) {
        
        if (row == 0) {
            cell.textLabel.text = @"People Updates";
        } else {
            cell.textLabel.text = @"Company Updates";
        }
        cell.detailTextLabel.text = @"";
        
    } else if (section == 2) {
        
        if (row == 0) {
            cell.textLabel.text = @"Version";
            cell.detailTextLabel.text = @"1.0";
        } else if (row == 1) {
            cell.textLabel.text = @"Privacy";
            cell.detailTextLabel.text = @"";
        } else if (row == 2) {
            cell.textLabel.text = @"Terms";
            cell.detailTextLabel.text = @"";
        }
        
    }
    
    else if (section == 3) {
        cell.textLabel.text = @"API Test";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 3;
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [GGUtils envString];
    } else if (section == 1) {
        return @"NOTIFICATIONS";
    } else if (section == 2) {
        return @"ABOUT";
    }
    
    else if (section == 3) {
        return @"TEST";
    }
    
    return nil;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == 0) {
        
        GGProfileVC *vc = [[GGProfileVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (section == 1) {
        
        if (row == 0) {
            //@"People Updates";
        } else {
            //@"Company Updates";
        }
        
    } else if (section == 2) {
        
        if (row == 0) {
            //@"Version";
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
    
    else if (section == 3) {
        [self apiTestAction:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return [self _footerView];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return [self _footerView].frame.size.height;
    }
    
    return 0;
}

@end
