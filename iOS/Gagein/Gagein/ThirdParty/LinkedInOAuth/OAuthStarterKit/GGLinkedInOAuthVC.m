//
//  iPhone OAuth Starter Kit
//
//  Supported providers: LinkedIn (OAuth 1.0a)
//
//  Lee Whitney
//  http://whitneyland.com
//
#import <Foundation/NSNotificationQueue.h>
#import "GGLinkedInOAuthVC.h"
#import "OALnRequestParameter.h"

#define API_KEY_LENGTH 12
#define SECRET_KEY_LENGTH 16

//
// OAuth steps for version 1.0a:
//
//  1. Request a "request token"
//  2. Show the user a browser with the LinkedIn login page
//  3. LinkedIn redirects the browser to our callback URL
//  4  Request an "access token"
//
@implementation GGLinkedInOAuthVC

@synthesize requestToken, accessToken, profile, consumer;

//
// OAuth step 1a:
//
// The first step in the the OAuth process to make a request for a "request token".
// Yes it's confusing that the work request is mentioned twice like that, but it is whats happening.
//
- (void)requestTokenFromProvider
{
    OALnMutableURLRequest *request = 
            [[[OALnMutableURLRequest alloc] initWithURL:requestTokenURL
                                             consumer:self.consumer
                                                token:nil   
                                             callback:linkedInCallbackURL
                                    signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];   
    
    OALnRequestParameter *nameParam = [[OALnRequestParameter alloc] initWithName:@"scope"
                                                                       value:@"r_basicprofile+rw_nus"];
    NSArray *params = [NSArray arrayWithObjects:nameParam, nil];
    [request setParameters:params];
    OALnRequestParameter * scopeParameter=[OALnRequestParameter requestParameter:@"scope" value:@"r_fullprofile rw_nus"];
    
    [request setParameters:[NSArray arrayWithObject:scopeParameter]];
    
    OALnDataFetcher *fetcher = [[[OALnDataFetcher alloc] init] autorelease];
    
    [self showLoadingHUD];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenResult:didFinish:)
                  didFailSelector:@selector(requestTokenResult:didFail:)];    
}

//
// OAuth step 1b:
//
// When this method is called it means we have successfully received a request token.
// We then show a webView that sends the user to the LinkedIn login page.
// The request token is added as a parameter to the url of the login page.
// LinkedIn reads the token on their end to know which app the user is granting access to.
//
- (void)requestTokenResult:(OALnServiceTicket *)ticket didFinish:(NSData *)data 
{
    [self hideLoadingHUD];
    if (ticket.didSucceed == NO) 
        return;
        
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    self.requestToken = [[OALnToken alloc] initWithHTTPResponseBody:responseBody];
    [responseBody release];
    [self allowUserToLogin];
}

- (void)requestTokenResult:(OALnServiceTicket *)ticket didFail:(NSData *)error 
{
    [self hideLoadingHUD];
    NSLog(@"%@",[error description]);
}

//
// OAuth step 2:
//
// Show the user a browser displaying the LinkedIn login page.
// They type username/password and this is how they permit us to access their data
// We use a UIWebView for this.
//
// Sending the token information is required, but in this one case OAuth requires us
// to send URL query parameters instead of putting the token in the HTTP Authorization
// header as we do in all other cases.
//
- (void)allowUserToLogin
{
    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@", 
        userLoginURLString, self.requestToken.key];
    
    userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL: userLoginURL];
    [webView loadRequest:request];     
}


//
// OAuth step 3:
//
// This method is called when our webView browser loads a URL, this happens 3 times:
//
//      a) Our own [webView loadRequest] message sends the user to the LinkedIn login page.
//
//      b) The user types in their username/password and presses 'OK', this will submit
//         their credentials to LinkedIn
//
//      c) LinkedIn responds to the submit request by redirecting the browser to our callback URL
//         If the user approves they also add two parameters to the callback URL: oauth_token and oauth_verifier.
//         If the user does not allow access the parameter user_refused is returned.
//
//      Example URLs for these three load events:
//          a) https://www.linkedin.com/uas/oauth/authorize?oauth_token=<token value>
//
//          b) https://www.linkedin.com/uas/oauth/authorize/submit   OR
//             https://www.linkedin.com/uas/oauth/authenticate?oauth_token=<token value>&trk=uas-continue
//
//          c) hdlinked://linkedin/oauth?oauth_token=<token value>&oauth_verifier=63600     OR
//             hdlinked://linkedin/oauth?user_refused
//             
//
//  We only need to handle case (c) to extract the oauth_verifier value
//
- (BOOL)webView:(UIWebView*)aWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
    
    addressBar.text = urlString;
    //[activityIndicator startAnimating];
    
    BOOL requestForCallbackURL = ([urlString rangeOfString:linkedInCallbackURL].location != NSNotFound);
    if ( requestForCallbackURL )
    {
        BOOL userAllowedAccess = ([urlString rangeOfString:@"user_refused"].location == NSNotFound);
        if ( userAllowedAccess )
        {            
            [self.requestToken setVerifierWithUrl:url];
            [self accessTokenFromProvider];
        }
        else
        {
            // User refused to allow our app access
            // Notify parent and close this view
            [self _notifyAndQuit];
        }
    }
    else
    {
        // Case (a) or (b), so ignore it
    }
	return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)aWebView
{
    //self.view.frame = self.view.superview.bounds;
    DLog("%@", webView.frameString);
    webView.frame = webView.superview.bounds;
    
    [self showLoadingHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingHUD];
    //[activityIndicator stopAnimating];
}

//
// OAuth step 4:
//
- (void)accessTokenFromProvider
{ 
    OALnMutableURLRequest *request = 
            [[[OALnMutableURLRequest alloc] initWithURL:accessTokenURL
                                             consumer:self.consumer
                                                token:self.requestToken   
                                             callback:nil
                                    signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];
    OALnDataFetcher *fetcher = [[[OALnDataFetcher alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenResult:didFinish:)
                  didFailSelector:@selector(accessTokenResult:didFail:)];    
}

- (void)accessTokenResult:(OALnServiceTicket *)ticket didFinish:(NSData *)data 
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    BOOL problem = ([responseBody rangeOfString:@"oauth_problem"].location != NSNotFound);
    if ( problem )
    {
        NSLog(@"Request access token failed.");
        NSLog(@"%@",responseBody);
    }
    else
    {
        self.accessToken = [[OALnToken alloc] initWithHTTPResponseBody:responseBody];
    }
    
    // Notify parent and close this view
    [self _notifyAndQuit];
    
    [responseBody release];
}

-(void)_notifyAndQuit
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self postNotification:OA_NOTIFY_LINKEDIN_AUTH_OK withObject:self];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSString *)_apiKey
{
    switch (CURRENT_ENV)
    {
        case kGGServerProduction:
        {
            return @"JG-8S3mdrOdAUT2tuZPadrAYX-Y7tWol-z3fashTf44aDRNLhqkmz6GD0XrKIhfx";
        }
            break;
            
        case kGGServerDemo:
        {
            return @"vkr4AkuIzlhxGSts3EKvPitIg9iOCTM-goRMfmizCT8U2x5wDCAB4MZSwOes1tW1";
        }
            break;
            
        case kGGServerCN:
        {
            return @"KrVuznl0-o-oEzgrZCuqMlVVxCIiIXidFYBOXI-fxZLRKMApOCQjL6tHbGBHSGGl";
        }
            break;
            
        case kGGServerStaging:
        {
            return @"KCFBq5BRcc5HnSfJ4e-9RAZEdbhoNyLLUx51kjRyBfwpJNk2eIDxICYQjNKjxRxV";
        }
            break;
            
        case kGGServerRoshen:
        {
            return @"MdAwAcLzK2jb3ii4xpYxhVvuqgNrnPSzYje74kQudJ96youSwf8aPVNBnEGwUSBB";
        }
            break;
            
        default:
            break;
    }
    
    return @"0ta2ufb55qm3";
}

-(NSString *)_secretKey
{
    switch (CURRENT_ENV)
    {
        case kGGServerProduction:
        {
            return @"4UUmZlEbsoMr3tk9FiDmNFmKOHWsvYgt0o0QrESsS1tVjQRRXKlvZWKnjUox9qnJ";
        }
            break;
            
        case kGGServerDemo:
        {
            return @"VYe-sLjl3Zs7vrs09QMUkSiRgK8jHusF0_ZZUVMueEsdlkjKCnZyvmZf6LqfgeYm";
        }
            break;
            
        case kGGServerCN:
        {
            return @"te2NTOMf7zoUCqV6fmqo-Z-ofCelDqJCJhFoNs47lIh6o4Xk_ZLR-ryHOtCjOjCg";
        }
            break;
            
        case kGGServerStaging:
        {
            return @"1N5XkcmzqbOlgxBGXnqTVxH6OUvwnrEXglFbByDY5w4DZav92nNSEy5Ex33zHZUB";
        }
            break;
            
        case kGGServerRoshen:
        {
            return @"9A_s8P1ya_sEtxyl0tgz7QZRQsKd8-yQFT--R5oImxxMa3Pg3Y_ZL8IYNBrB3VNQ";
        }
            break;
            
        default:
            break;
    }
    
    return @"P6AO2WQYnMH9q39n";
}

//
//  This api consumer data could move to a provider object
//  to allow easy switching between LinkedIn, Twitter, etc.
//
- (void)initLinkedInApi
{
    apikey = [self _apiKey];
    secretkey = [self _secretKey];

    self.consumer = [[OALnConsumer alloc] initWithKey:apikey
                                        secret:secretkey
                                         realm:@"http://api.linkedin.com/"];

    requestTokenURLString = @"https://api.linkedin.com/uas/oauth/requestToken";
    accessTokenURLString = @"https://api.linkedin.com/uas/oauth/accessToken";
    userLoginURLString = @"https://www.linkedin.com/uas/oauth/authorize";    
    linkedInCallbackURL = @"hdlinked://linkedin/oauth";
    
    requestTokenURL = [[NSURL URLWithString:requestTokenURLString] retain];
    accessTokenURL = [[NSURL URLWithString:accessTokenURLString] retain];
    userLoginURL = [[NSURL URLWithString:userLoginURLString] retain];
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    [super viewDidLoad];
    self.naviTitle = @"LinkedIn Auth";
    [self initLinkedInApi];
    [addressBar setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"%@", self.view.frameString);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([apikey length] < API_KEY_LENGTH || [secretkey length] < SECRET_KEY_LENGTH)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"OAuth Starter Kit"
                          message: @"You must add your apikey and secretkey.  See the project file readme.txt"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        // Notify parent and close this view
        [self _notifyAndQuit];
    }

    [self requestTokenFromProvider];
    [self showBackButton];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
    
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    webView.delegate = nil;
    [webView stopLoading];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
