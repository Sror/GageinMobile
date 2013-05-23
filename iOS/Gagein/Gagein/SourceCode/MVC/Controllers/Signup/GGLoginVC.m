//
//  GGLoginVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGLoginVC.h"
#import "GGAppDelegate.h"
#import "GGPredicate.h"
#import "GGMember.h"
#import "GGSelectAgentsVC.h"
#import "GGSelectFuncAreasVC.h"
#import "GGSignupVC.h"

@interface GGLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;
@property (weak, nonatomic) IBOutlet UIImageView *ivLoginFieldBg;

@end

@implementation GGLoginVC

+(id)createInstance
{
    if (ISIPADDEVICE)
    {
        return [[self alloc] initWithNibName:@"GGLoginVC_iPad" bundle:nil];
    }

    return [[self alloc] initWithNibName:@"GGLoginVC" bundle:nil];
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
    self.navigationController.navigationBarHidden = NO;
    
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.bgGray;
    self.naviTitle = @"Login with Email";
    
    [self installGageinLogoTo:self.scrolView];
    self.ivLoginFieldBg.image = [[UIImage imageNamed:@"bgLoginField"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.btnLogin setBackgroundImage:[[UIImage imageNamed:@"btnYellowBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10)] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showBackButton];
}


-(void)dealloc
{
    _scrolView.delegate = nil;
}

- (void)viewDidUnload {
    [self setTfEmail:nil];
    [self setTfPassword:nil];
    [self setBtnLogin:nil];
    [self setScrolView:nil];
    [self setIvLoginFieldBg:nil];
    [super viewDidUnload];
}

#pragma mark - overriding
-(void)naviBackAction:(id)aSender
{
    [self.view.window.layer addAnimation:[GGAnimation animationPushFromLeft] forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - internal
-(BOOL)_checkEmail
{
    if (self.tfEmail.text.length <= 0) {
        [GGAlert alertWithMessage:@"You must enter your Email."];
        [self.tfEmail becomeFirstResponder];
        return NO;
    }else if (![GGPredicate checkEmail:self.tfEmail.text]){
        [GGAlert alertWithMessage:@"Not a valid Email format."];
        [self.tfEmail becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)_checkPassword
{
    if (self.tfPassword.text.length <= 0) {
        [GGAlert alertWithMessage:@"You must enter your Password."];
        [self.tfPassword becomeFirstResponder];
        return NO;
    }else if (![GGPredicate checkPassword:self.tfPassword.text]){
        [GGAlert alertWithMessage:@"Password must be 6-12 characters."];
        [self.tfPassword becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - actions
-(IBAction)goSignupAction:(id)sender
{
    //[self.navigationController popViewControllerAnimated:NO];
    
    GGSignupVC *vc = [[GGSignupVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)loginAction:(id)sender
{
    if ([self _checkEmail] && [self _checkPassword]) {
        
        [self.tfEmail resignFirstResponder];
        [self.tfPassword resignFirstResponder];
        [self.scrolView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        DLog(@"email and pwd OK, call login API.")
        
        [self showLoadingHUD];
        id op = [GGSharedAPI loginWithEmail:self.tfEmail.text password:self.tfPassword.text callback:^(id operation, id aResultObject, NSError *anError) {
            //DLog(@"%@", aResultObject);
            [self hideLoadingHUD];
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.status == 1)
            {
                DLog(@"Login OK");
                //id data = parser.data;
                //DLog(@"%@", data);
                GGMember *currentUser = [parser parseLogin];
                currentUser.accountEmail = self.tfEmail.text;
                currentUser.accountPassword = self.tfPassword.text;
                GGSharedRuntimeData.currentUser = currentUser;
                [GGSharedRuntimeData saveCurrentUser];
                
                if (currentUser.isSignupOK)
                {
                    // go home
                    [self dismissViewControllerAnimated:NO completion:nil];
                    [GGSharedDelegate popNaviToRoot];
                    [GGSharedDelegate showTabIndex:0];
                    [self postNotification:GG_NOTIFY_LOG_IN];
                }
                else if (currentUser.signupProcessStatus == kGGSignupProcessAgentsSelect)
                {
                    // go to Agents select
                    GGSelectAgentsVC *vc = [[GGSelectAgentsVC alloc] init];
                    vc.isFromRegistration = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if (currentUser.signupProcessStatus == kGGSignupProcessAreasSelect)
                {
                    // go to areas select
                    GGSelectFuncAreasVC *vc = [[GGSelectFuncAreasVC alloc] init];
                    vc.isFromRegistration = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            else
            {
                DLog(@"Login Failed");
                [GGAlert alertWithApiMessage:parser.message];
            }
        }];
        
        [self registerOperation:op];
    }
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
