//
//  GGSignupVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSignupVC.h"

@interface GGSignupVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;
@property (weak, nonatomic) IBOutlet UIView *signupPanel;
@property (weak, nonatomic) IBOutlet UIView *linkedOkPanel;
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnJoinNow;

@end

@implementation GGSignupVC

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
    
    self.title = @"Join Gagein";
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrolView:nil];
    [self setSignupPanel:nil];
    [self setLinkedOkPanel:nil];
    [self setTfFirstName:nil];
    [self setTfLastName:nil];
    [self setTfEmail:nil];
    [self setTfPassword:nil];
    [self setBtnJoinNow:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(IBAction)joinNowAction:(id)sender
{
    [self.tfFirstName resignFirstResponder];
    [self.tfLastName resignFirstResponder];
    [self.tfEmail resignFirstResponder];
    [self.tfPassword resignFirstResponder];
    [self.scrolView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.tfFirstName) {
        [self.scrolView setContentOffset:CGPointMake(0, 40) animated:YES];
    }else if (textField == self.tfLastName) {
        [self.scrolView setContentOffset:CGPointMake(0, 80) animated:YES];
    }else if (textField == self.tfEmail) {
        [self.scrolView setContentOffset:CGPointMake(0, 120) animated:YES];
    }else if (textField == self.tfPassword) {
        [self.scrolView setContentOffset:CGPointMake(0, 160) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tfFirstName resignFirstResponder];
    [self.tfLastName resignFirstResponder];
    [self.tfEmail resignFirstResponder];
    [self.tfPassword resignFirstResponder];
}
@end
