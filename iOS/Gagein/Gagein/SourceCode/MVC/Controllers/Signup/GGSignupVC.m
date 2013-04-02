//
//  GGSignupVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSignupVC.h"
#import "GGPredicate.h"

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

#pragma mark - internal
-(BOOL)_checkEmail
{
    if (self.tfEmail.text.length <= 0) {
        [GGAlert alert:@"You must enter your Email."];
        [self.tfEmail becomeFirstResponder];
        return NO;
    }else if (![GGPredicate checkEmail:self.tfEmail.text]){
        [GGAlert alert:@"Not a valid Email format."];
        [self.tfEmail becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)_checkPassword
{
    if (self.tfPassword.text.length <= 0) {
        [GGAlert alert:@"You must enter your Password."];
        [self.tfPassword becomeFirstResponder];
        return NO;
    }else if (![GGPredicate checkPassword:self.tfPassword.text]){
        [GGAlert alert:@"Password must be 6-12 characters."];
        [self.tfPassword becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)_checkFirstName
{
    if (self.tfFirstName.text.length <= 0) {
        [GGAlert alert:@"You must enter your first name."];
        [self.tfFirstName becomeFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)_checkLastName
{
    if (self.tfLastName.text.length <= 0) {
        [GGAlert alert:@"You must enter your last name."];
        [self.tfLastName becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - actions
-(IBAction)joinNowAction:(id)sender
{
    if ([self _checkFirstName] && [self _checkLastName]
        && [self _checkEmail] && [self _checkPassword]) {
        
        [self.tfFirstName resignFirstResponder];
        [self.tfLastName resignFirstResponder];
        [self.tfEmail resignFirstResponder];
        [self.tfPassword resignFirstResponder];
        [self.scrolView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        DLog(@"check OK, call signup API.")
    }
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
