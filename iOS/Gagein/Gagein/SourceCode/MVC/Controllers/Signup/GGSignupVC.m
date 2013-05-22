//
//  GGSignupVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSignupVC.h"
#import "GGPredicate.h"
#import "GGSelectAgentsVC.h"
#import "GGMember.h"
#import "GGLoginVC.h"
#import "GGSnUserInfo.h"

@interface GGSignupVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;
@property (weak, nonatomic) IBOutlet UIView *signupPanel;
@property (weak, nonatomic) IBOutlet UIView *linkedOkPanel;
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnJoinNow;
@property (weak, nonatomic) IBOutlet UILabel *lblSuccessTip;

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

-(NSString *)_successMessage
{
    if (_userInfo)
    {
        NSString *formatStr = @"Success!\nYou are now connected to your %@ accounts.";
        
        switch (_userInfo.snType)
        {
            case kGGSnTypeFacebook:
            {
                return [NSString stringWithFormat:formatStr, @"Facebook"];
            }
                break;
                
            case kGGSnTypeLinkedIn:
            {
                return [NSString stringWithFormat:formatStr, @"LinkedIn"];
            }
                break;
                
            case kGGSnTypeTwitter:
            {
                return [NSString stringWithFormat:formatStr, @"Twitter"];
            }
                break;
                
            case kGGSnTypeSalesforce:
            {
                return [NSString stringWithFormat:formatStr, @"Falesforce"];
            }
                break;
                
            case kGGSnTypeYammer:
            {
                return [NSString stringWithFormat:formatStr, @"Yammer"];
            }
                break;
                
            default:
                break;
        }
    }
    
    return nil;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.bgGray;
    self.naviTitle = @"Join Gagein";
    [self installGageinLogoTo:self.scrolView];
    
    if (_userInfo)
    {
        _linkedOkPanel.hidden = NO;
        _lblSuccessTip.text = [self _successMessage];
        
        CGRect signUpRc = _signupPanel.frame;
        signUpRc.origin.y = CGRectGetMaxY(_linkedOkPanel.frame);
        _signupPanel.frame = signUpRc;
        
        self.tfFirstName.text = _userInfo.firstName;
        self.tfLastName.text = _userInfo.lastName;
        self.tfEmail.text = _userInfo.email;
    }
    else
    {
#warning TEST register data
        self.tfFirstName.text = @"Mcdonald";
        self.tfLastName.text = @"Kentucky";
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showBackButton];
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
    [self setLblSuccessTip:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    _scrolView.delegate = nil;
}

#pragma mark - overriding
-(IBAction)goLoginAction:(id)sender
{
    GGLoginVC *vc = [GGLoginVC createInstance];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)naviBackAction:(id)aSender
{
    [self.view.window.layer addAnimation:[GGAnimation animationPushFromLeft] forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
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
        
        
        GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
            
            DLog(@"%@", aResultObject);
            [self hideLoadingHUD];
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.status == 1)
            {
                DLog(@"Register OK, auto login..");
                
                [GGSharedAPI loginWithEmail:self.tfEmail.text password:self.tfPassword.text callback:^(id operation, id aResultObject, NSError *anError) {
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        // record login info
                        GGSharedRuntimeData.currentUser = [parser parseLogin];
                        GGSharedRuntimeData.currentUser.accountEmail = self.tfEmail.text;
                        GGSharedRuntimeData.currentUser.accountPassword = self.tfPassword.text;
                        [GGSharedRuntimeData saveCurrentUser];
                        
                        // go to setup wizzard
                        GGSelectAgentsVC *vc = [[GGSelectAgentsVC alloc] init];
                        vc.isFromRegistration = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        [GGAlert alert:parser.message];
                    }
                }];
            }
            else
            {
                DLog(@"register Failed");
                [GGAlert alert:parser.message];
            }
            
        };
        
        DLog(@"check OK, call signup API.")
        [self showLoadingHUD];
        if (_userInfo)
        {
            [GGSharedAPI snRegisterWithEmail:self.tfEmail.text password:self.tfPassword.text firstName:self.tfFirstName.text lastName:self.tfLastName.text snType:_userInfo.snType token:_userInfo.token secret:_userInfo.secret snAccountID:_userInfo.accountID snFirstName:_userInfo.firstName snLastName:_userInfo.lastName snEmail:_userInfo.email snAccountName:_userInfo.accountName snProfileURL:_userInfo.profileURL sfRefreshToken:_userInfo.refreshToken sfInstanceURL:_userInfo.instanceUrl callback:callback];
        }
        else
        {
            [GGSharedAPI retisterWithEmail:self.tfEmail.text password:self.tfPassword.text firstName:self.tfFirstName.text lastName:self.tfLastName.text callback:callback];
        }
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
