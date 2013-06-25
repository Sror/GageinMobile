//
//  GGLeftDrawerVC.m
//  Gagein
//
//  Created by Dong Yiming on 6/23/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGLeftDrawerVC.h"


@interface GGLeftDrawerVC ()

@end

@implementation GGLeftDrawerVC

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
    _viewContent = [[UIView alloc] initWithFrame:self.view.bounds];
    _viewContent.backgroundColor = GGSharedColor.darkRed;
    [self.view addSubview:_viewContent];
	
    //_viewMenu = [[GGSlideSettingView alloc] initWithFrame:self.view.bounds];
}


@end
