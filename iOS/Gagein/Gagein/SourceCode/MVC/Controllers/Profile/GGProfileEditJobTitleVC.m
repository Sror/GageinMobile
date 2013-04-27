//
//  GGProfileEditJobTitleVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileEditJobTitleVC.h"

@interface GGProfileEditJobTitleVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfJobTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end

@implementation GGProfileEditJobTitleVC

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
    self.naviTitle = @"Job Title";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTfJobTitle:nil];
    [self setBtnSave:nil];
    [super viewDidUnload];
}
@end
