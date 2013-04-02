//
//  GGLoginVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGLoginVC.h"

@interface GGLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;

@end

@implementation GGLoginVC

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
    
    self.title = @"Login with Email";
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTfEmail:nil];
    [self setTfPassword:nil];
    [self setBtnLogin:nil];
    [self setScrolView:nil];
    [super viewDidUnload];
}

#pragma mark - internal

#pragma mark - actions
-(IBAction)loginAction:(id)sender
{
    [self.tfEmail resignFirstResponder];
    [self.tfPassword resignFirstResponder];
    [self.scrolView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.tfEmail) {
        [self.scrolView setContentOffset:CGPointMake(0, 40) animated:YES];
    }else if (textField == self.tfPassword) {
        [self.scrolView setContentOffset:CGPointMake(0, 80) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tfEmail resignFirstResponder];
    [self.tfPassword resignFirstResponder];
}

@end
