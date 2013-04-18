//
//  GGSavedUpdatesVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-18.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSavedUpdatesVC.h"
#import "DCRoundSwitch.h"

#define SWITCH_WIDTH 70
#define SWITCH_HEIGHT 20

@interface GGSavedUpdatesVC ()

@end

@implementation GGSavedUpdatesVC
{
    DCRoundSwitch   *_roundSwitch;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Saved";
        self.tabBarItem.image = [UIImage imageNamed:@"Players"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.silver;
    self.navigationItem.title = @"Saved Updates";
    
    CGRect naviRc = self.navigationController.navigationBar.frame;

    CGRect switchRc = CGRectMake(naviRc.size.width - SWITCH_WIDTH - 10
                                 , (naviRc.size.height - SWITCH_HEIGHT) / 2 + 5
                                 , SWITCH_WIDTH
                                 , SWITCH_HEIGHT);
    _roundSwitch = [[DCRoundSwitch alloc] initWithFrame:switchRc];
    _roundSwitch.onTintColor = GGSharedColor.orange;
    _roundSwitch.onText = @"All";
    _roundSwitch.offText = @"Unread";
    [_roundSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    _roundSwitch.on = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_roundSwitch];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_roundSwitch removeFromSuperview];
}

#pragma mark - actions
-(void)switchAction:(DCRoundSwitch *)aSwitch
{
    
}

@end
