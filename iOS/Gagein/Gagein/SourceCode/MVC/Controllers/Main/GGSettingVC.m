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

@interface GGSettingVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnAPITest;

@end

@implementation GGSettingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"Gestures"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidUnload {
    [self setBtnLogout:nil];
    [self setBtnAPITest:nil];
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

@end
