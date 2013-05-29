//
//  GGImageVC.m
//  Gagein
//
//  Created by Dong Yiming on 5/29/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGImageVC.h"

@interface GGImageVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *iv;

@end

@implementation GGImageVC
{
    UITapGestureRecognizer  *_tapGestToDone;
}

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
    
    _tapGestToDone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneAction:)];
    [self.view addGestureRecognizer:_tapGestToDone];
    
    [_iv setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil];
}


- (void)viewDidUnload {
    [self setBtnDone:nil];
    [self setIv:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(IBAction)doneAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return YES;
}

@end
