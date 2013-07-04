//
//  GGDummyDrawerVC.m
//  Gagein
//
//  Created by Dong Yiming on 7/3/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGDummyDrawerVC.h"

@interface GGDummyDrawerVC ()

@end

@implementation GGDummyDrawerVC

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
	self.view.backgroundColor = GGSharedColor.random;
    
    _viewContent = [[UIView alloc] initWithFrame:self.view.bounds];
    _viewContent.backgroundColor = GGSharedColor.black;
    _viewContent.backgroundColor = GGSharedColor.random;
    [self.view addSubview:_viewContent];
	
    _viewMenu = [[GGSlideSettingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_viewMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
