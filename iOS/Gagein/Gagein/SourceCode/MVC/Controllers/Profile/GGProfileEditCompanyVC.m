//
//  GGProfileEditCompanyVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileEditCompanyVC.h"

@interface GGProfileEditCompanyVC ()

@end

@implementation GGProfileEditCompanyVC

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
    self.view.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"Company";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
