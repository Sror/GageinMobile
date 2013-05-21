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

#define DOMAIN_TEST     @"test.salesforce.com"
#define DOMAIN_LOGIN    @"login.salesforce.com"

@interface GGSalesForceParam : NSObject
@property (copy)   NSString     *identifier;
@property (copy)   NSString     *clientID;
@property (copy)   NSString     *redirectURL;
@property (copy)   NSString     *domain;
@end

@implementation GGSalesForceParam
- (id)init
{
    self = [super init];
    if (self) {
        _identifier = @"com.salesforce.ios.oauth.test";
        _clientID = @"3MVG9Iu66FKeHhINkB1l7xt7kR8czFcCTUhgoA8Ol2Ltf1eYHOU4SqQRSEitYFDUpqRWcoQ2.dBv_a1Dyu5xa";
        _redirectURL = @"testsfdc:///mobilesdk/detect/oauth/done";
        _domain = DOMAIN_LOGIN;
    }
    return self;
}
@end

//NSString * const kIdentifier    = @"com.salesforce.ios.oauth.test";
//NSString * const kOAuthClientId = @"3MVG9Iu66FKeHhINkB1l7xt7kR8czFcCTUhgoA8Ol2Ltf1eYHOU4SqQRSEitYFDUpqRWcoQ2.dBv_a1Dyu5xa";


//NSString * const kIdentifier    = @"GageIn.localhost";
//NSString * const kOAuthClientId = @"3MVG9QDx8IX8nP5Rg7yD2yhM0mZ1B5qRXXaIqmF3KCA.ycm5l7WI5cOzwLzyadnkqgfAzChHWRF6mvgDN4KCF";


static NSString * const kOAuthCredentialsArchivePath = @"SFOAuthCredentials";
//static NSString * const kOAuthLoginDomain =  @"login.salesforce.com";//@"test.salesforce.com";    // Sandbox: use login.salesforce.com if you're
// sure you want to test with Production
//static NSString * const kOAuthRedirectUri = @"testsfdc:///mobilesdk/detect/oauth/done";
//static NSString * const kOAuthRedirectUri = @"myapp:///mobilesdk/detect/oauth/done";//@"https://localhost:8443/dragon/ConnectWithSalesforceProxy";


@interface GGSalesforceOAuthVC ()

@end


@implementation GGSalesforceOAuthVC


//public static class SALESFORCE {

//    
//    private static SITE_KEYS qacnKeys = new SITE_KEYS(
//                                                      "GageInApp.qacn",
//                                                      "http://gageincn.dyndns.org:3031",
//                                                      "",
//                                                      "3MVG9QDx8IX8nP5Rg7yD2yhM0mTep67cL1i5rgZf680Zc30kzy9j6G_vyEvH9EZaUcsp3uMGMK_58ELiarVjc",
//                                                      "1169752873003592920"
//                                                      );
//    
//    
//    private static SITE_KEYS stagingKeys = new SITE_KEYS(
//                                                         "GageInApp.staging",
//                                                         "http://gageinstaging.dyndns.org",
//                                                         "",
//                                                         "3MVG9QDx8IX8nP5Rg7yD2yhM0mXzbRfDUkFTsEmylcNYdpLf3MpiegNCjNhLn4WoQ36aNg5a5muZtOtiBsGcs",
//                                                         "5228913310560653116"
//                                                         );
//    
//    private static SITE_KEYS demoKeys = new SITE_KEYS(
//                                                      "GageInApp.demo",
//                                                      "http://gageindemo.dyndns.org/",
//                                                      "",
//                                                      "3MVG9QDx8IX8nP5Rg7yD2yhM0mRvh1db.tHJhAvmBc4Tsze3dupGHqlChVxEiCFPLLV8qYtL.oX8Um8sZvg4p",
//                                                      "351992569387772761"
//                                                      );


+(GGSalesForceParam *)_param
{
    GGSalesForceParam * _param = [[GGSalesForceParam alloc] init];
    
    switch (CURRENT_ENV)
    {
        case kGGServerProduction:
        {
            _param.identifier = @"GageIn";
            _param.clientID = @"3MVG9QDx8IX8nP5Rg7yD2yhM0mSIoG5JhtwAfaXVxWdWvLQ2c9dbC5IdPIt8bV9wAgE4sLNdWDWrvrHs7izVe";
        }
            break;
            
        case kGGServerStaging:
        {
#warning TODO: need to change to staging setting
//            _param.identifier = @"GageIn.localhost";
//            _param.clientID = @"3MVG9QDx8IX8nP5Rg7yD2yhM0mZ1B5qRXXaIqmF3KCA.ycm5l7WI5cOzwLzyadnkqgfAzChHWRF6mvgDN4KCF";
//            _param.redirectURL = @"http://localhost:8443/dragon/ConnectWithSalesforceProxy";
        }
            break;
            
        case kGGServerCN:
        {
            
        }
            break;
            
        case kGGServerDemo:
        {
            _param.identifier = @"GageInApp.demo";
            _param.clientID = @"3MVG9QDx8IX8nP5Rg7yD2yhM0mRvh1db.tHJhAvmBc4Tsze3dupGHqlChVxEiCFPLLV8qYtL.oX8Um8sZvg4p";
            _param.redirectURL = @"https://gageindemo.dyndns.org/dragon/ConnectWithSalesforceProxy";
        }
            break;
            
        case kGGServerRoshen:
        {
#if 1
            _param.identifier = @"GageIn.localhost";
            _param.clientID = @"3MVG9QDx8IX8nP5Rg7yD2yhM0mZ1B5qRXXaIqmF3KCA.ycm5l7WI5cOzwLzyadnkqgfAzChHWRF6mvgDN4KCF";
            _param.redirectURL = @"http://localhost:8443/dragon/ConnectWithSalesforceProxy";//@"http://www.gagein.com/dragon/ConnectWithSalesforceProxy";//@"http://localhost:8443/dragon/ConnectWithSalesforceProxy";
#endif

        }
            break;
            
        default:
            break;
    }
    
    return _param;
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
    //self.navigationItem.hidesBackButton = YES;
    
    [super viewDidLoad];
    self.naviTitle = @"Salesforce OAuth";
    self.view.backgroundColor = GGSharedColor.silver;
	
    SFOAuthCredentials *credentials = [[self class] unarchiveCredentials];
    
    self.oauthCoordinator = [[SFOAuthCoordinator alloc] initWithCredentials:credentials];
    //set a default scope: API and Visualforce
    self.oauthCoordinator.scopes = [NSSet setWithObjects:@"api", nil];
    self.oauthCoordinator.delegate = self;
    
    [self.oauthCoordinator authenticate];
    [self showLoadingHUD];
}

-(void)dealloc
{
    self.oauthCoordinator.delegate = nil;
    //[[self class] archiveCredentials:self.oauthCoordinator.credentials];
}

#pragma mark -
+ (void)archiveCredentials:(SFOAuthCredentials *)creds {
//    BOOL result = [NSKeyedArchiver archiveRootObject:creds toFile:[self archivePath]];
//    NSLog(@"%@:archiveCredentials: credentials archived=%@", @"SalesforceOAuthTestAppDelegate", (result ? @"YES" : @"NO"));
}

+ (SFOAuthCredentials *)unarchiveCredentials {
    //NSString *path = [self archivePath];
    SFOAuthCredentials *creds = nil; //[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (nil == creds) {
        // no existing credentials, create a new one
        GGSalesForceParam *param = [self _param];
        creds = [[SFOAuthCredentials alloc] initWithIdentifier:param.identifier clientId:param.clientID encrypted:YES];
        creds.redirectUri = param.redirectURL;
        creds.domain = param.domain;
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
    
    [self postNotification:OA_NOTIFY_SALESFORCE_AUTH_OK withObject:self.oauthCoordinator.credentials];
    
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
