//
//  GGEditCustomAgentFilterVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGEditCustomAgentFilterVC.h"

@interface GGEditCustomAgentFilterVC ()

@end

@implementation GGEditCustomAgentFilterVC

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
    self.naviTitle = @"Configure Filters";
    self.view.backgroundColor = GGSharedColor.silver;
}



@end
