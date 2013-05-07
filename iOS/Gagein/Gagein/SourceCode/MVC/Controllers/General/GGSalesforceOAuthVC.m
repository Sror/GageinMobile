//
//  GGSalesforceOAuthVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSalesforceOAuthVC.h"

#import "SFOAuthCredentials.h"
#import "SFOAuthInfo.h"
#import "SFOAuthInfo+Internal.h"

NSString * const kIdentifier    = @"com.salesforce.ios.oauth.test";
NSString * const kOAuthClientId = @"3MVG9Iu66FKeHhINkB1l7xt7kR8czFcCTUhgoA8Ol2Ltf1eYHOU4SqQRSEitYFDUpqRWcoQ2.dBv_a1Dyu5xa";

static NSString * const kOAuthCredentialsArchivePath = @"SFOAuthCredentials";
static NSString * const kOAuthLoginDomain =  @"login.salesforce.com";//@"test.salesforce.com";    // Sandbox: use login.salesforce.com if you're
// sure you want to test with Production
static NSString * const kOAuthRedirectUri = @"testsfdc:///mobilesdk/detect/oauth/done";


@interface GGSalesforceOAuthVC ()

@end

@implementation GGSalesforceOAuthVC

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
    self.navigationItem.hidesBackButton = YES;
    
    [super viewDidLoad];
    self.naviTitle = @"Salesforce OAuth";
	
    SFOAuthCredentials *credentials = [[self class] unarchiveCredentials];
    
    self.oauthCoordinator = [[SFOAuthCoordinator alloc] initWithCredentials:credentials];
    //set a default scope: API and Visualforce
    self.oauthCoordinator.scopes = [NSSet setWithObjects:@"api", @"visualforce", nil];
    self.oauthCoordinator.delegate = self;
    
    [self.oauthCoordinator authenticate];
    [self showLoadingHUD];
}

-(void)dealloc
{
    [[self class] archiveCredentials:self.oauthCoordinator.credentials];
}

#pragma mark -
+ (void)archiveCredentials:(SFOAuthCredentials *)creds {
    BOOL result = [NSKeyedArchiver archiveRootObject:creds toFile:[self archivePath]];
    NSLog(@"%@:archiveCredentials: credentials archived=%@", @"SalesforceOAuthTestAppDelegate", (result ? @"YES" : @"NO"));
}

+ (SFOAuthCredentials *)unarchiveCredentials {
    NSString *path = [self archivePath];
    SFOAuthCredentials *creds = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (nil == creds) {
        // no existing credentials, create a new one
        creds = [[SFOAuthCredentials alloc] initWithIdentifier:kIdentifier clientId:kOAuthClientId encrypted:YES];
        creds.redirectUri = kOAuthRedirectUri;
        creds.domain = kOAuthLoginDomain;
        // domain is set by the view from its UI field value
        
        NSLog(@"%@:unarchiveCredentials: no saved credentials, new credentials created: %@", @"SalesforceOAuthTestAppDelegate", creds);
    } else {
        NSLog(@"%@:unarchiveCredentials: using saved credentials: %@", @"SalesforceOAuthTestAppDelegate", creds);
    }
    return creds;
}

+ (NSString *)archivePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:kOAuthCredentialsArchivePath];
}

#pragma mark - SFOAuthCoordinatorDelegate

- (void)oauthCoordinator:(SFOAuthCoordinator *)manager willBeginAuthenticationWithView:(UIWebView *)webView {
}

- (void)oauthCoordinator:(SFOAuthCoordinator *)manager didBeginAuthenticationWithView:(UIWebView *)webView {
    
    [self.view addSubview:webView];
}

- (void)oauthCoordinatorDidAuthenticate:(SFOAuthCoordinator *)coordinator authInfo:(SFOAuthInfo *)info
{
    [self hideLoadingHUD];
    
    NSLog(@"SalesforceOAuthTestViewController:oauthCoordinatorDidAuthenticate:authInfo: info: %@ credentials: %@", info, coordinator.credentials);
    
    self.authInfo = info;
    [self.oauthCoordinator.view removeFromSuperview];
    
    
    NSMutableString *infoStr = [NSMutableString stringWithFormat:@"accessToken:%@\n", self.oauthCoordinator.credentials.accessToken];
    [infoStr appendFormat:@"refreshToken:%@\n", self.oauthCoordinator.credentials.refreshToken];
    [infoStr appendFormat:@"instanceURL:%@\n", self.oauthCoordinator.credentials.instanceUrl.description];
    [infoStr appendFormat:@"issued:%@\n", [self.oauthCoordinator.credentials.issuedAt descriptionWithLocale:[NSLocale currentLocale]]];
    [infoStr appendFormat:@"userID:%@\n", self.oauthCoordinator.credentials.userId];
    [infoStr appendFormat:@"orgID:%@\n", self.oauthCoordinator.credentials.organizationId];
    [infoStr appendFormat:@"authType:%@\n", [self.authInfo authTypeDescription]];
    
    NSLog(@"%@", infoStr);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)oauthCoordinator:(SFOAuthCoordinator *)coordinator didFailWithError:(NSError *)error authInfo:(SFOAuthInfo *)info
{
    [self hideLoadingHUD];
    
    NSLog(@"SalesforceOAuthTestViewController:oauthCoordinator:didFailWithError:authInfo: info: %@ error: %@", info, error);
    self.authInfo = info;
    [self.oauthCoordinator.view removeFromSuperview];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %d", error.code]
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        // reset access and refresh tokens
        [self.oauthCoordinator.credentials revoke];
    } else if (1 == buttonIndex) {
        // reset access token only
        [self.oauthCoordinator.credentials revokeAccessToken];
    } else {
        // invalid index
        NSLog(@"SalesforceOAuthTestViewController:actionSheet:clickedButtonAtIndex: invalid button index: %d", buttonIndex);
    }
    self.authInfo = nil;
}



@end
