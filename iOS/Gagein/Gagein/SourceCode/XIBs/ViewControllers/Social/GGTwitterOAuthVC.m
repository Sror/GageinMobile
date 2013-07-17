//
//  OAuthTwitterDemoViewController.m
//  OAuthTwitterDemo
//
//  Created by Ben Gottlieb on 7/24/09.
//  Copyright Stand Alone, Inc. 2009. All rights reserved.
//

#import "GGTwitterOAuthVC.h"
#import "SA_OAuthTwitterEngine.h"
#import "OAToken.h"


//#define kOAuthConsumerKey				@"aL1IjfI8zuv0IyGX9sTlLQ"		//REPLACE ME
//#define kOAuthConsumerSecret			@"IH3ipqceMUgC6uilmPl4Qj61zkNu54pvyeL3N3FsM3s"		//REPLACE ME

@interface GGTwitterParam : NSObject
@property (copy) NSString *key;
@property (copy) NSString *secret;
@end

@implementation GGTwitterParam
- (id)init
{
    self = [super init];
    if (self) {
        _key = @"aL1IjfI8zuv0IyGX9sTlLQ";
        _secret = @"IH3ipqceMUgC6uilmPl4Qj61zkNu54pvyeL3N3FsM3s";
    }
    return self;
}
@end

////////////////////////
@implementation GGTwitterOAuthVC
{
    SA_OAuthTwitterController *_twitterOAuthVC;
}

-(GGTwitterParam *)_param
{
    GGTwitterParam *param = [[GGTwitterParam alloc] init];
    
    switch (CURRENT_ENV)
    {
        case kGGServerProduction:
        {
            param.key = @"uFZWraQfaDHFcQbKysJA";
            param.secret = @"qGMycU3ezTVblxZaf7Gc7JENOM8OokEmtKx1yCaAmcI";
        }
            break;
            
        case kGGServerStaging:
        {
            param.key = @"eFyXq7uhH1Lj6LPZ1fFqA";
            param.secret = @"UHgBLk7m0g8Wh0CU2ytAfRihMosx1j9lnXvL9qdsQA";
        }
            break;
            
        case kGGServerDemo:
        {
            param.key = @"wiibcHpMLjoKcxUCk1ou7A";
            param.secret = @"6C66cbObQRccG92ltqU1Eikkn2yfSASB7Wx3CsBUk";
        }
            break;
            
        case kGGServerCN:
        {
            param.key = @"jq33SP6aQ85huQTmStWOA";
            param.secret = @"ciSJujyyZGOeeMX7xSqyI8tnNBVc4hKdV1KejZJIiU";
        }
            break;
            
        case kGGServerRoshen:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    return param;
}

#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    
    DLog(@"token:%@ secret:%@", _engine.accessToken.key, _engine.accessToken.secret);
    
    [self postNotification:OA_NOTIFY_TWITTER_OAUTH_OK withObject:_engine.accessToken];
    [self naviBackAction:nil];
    //[self.navigationController popToViewController:self.parentViewController animated:YES];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    return nil;
	//return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}


#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	DLog(@"Authenicated for %@", username);
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	DLog(@"Authentication Failed!");
    [GGAlert alertWithMessage:@"Authentication Failed!"];
    [self naviBackAction:nil];
    //[self.navigationController popToViewController:self.parentViewController animated:YES];
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	DLog(@"Authentication Canceled.");
    [self naviBackAction:nil];
    //[self.navigationController popToViewController:self.parentViewController animated:YES];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	DLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	DLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}



//=============================================================================================================================
#pragma mark ViewController Stuff

-(void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    
    [super viewDidLoad];
    
    self.naviTitle = @"Twitter";
    self.view.backgroundColor = GGSharedColor.silver;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear: (BOOL)animated {
    
    [super viewDidAppear:animated];
    
	if (_engine) return;
    
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
    
    GGTwitterParam *param = [self _param];
	_engine.consumerKey = param.key;
	_engine.consumerSecret = param.secret;
	
	_twitterOAuthVC = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (_twitterOAuthVC)
    {
        //[self.view addSubview:_twitterOAuthVC.view];
        //controller.hidesBottomBarWhenPushed = YES;
        //[self presentViewController:controller animated:NO completion:nil];
        [self.view addSubview:_twitterOAuthVC.view];
		//[self.navigationController pushViewController:_twitterOAuthVC animated:NO];
    }
	else
    {
		[_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
	}

    [self showBackButton];
}


@end



//
//                                                      
