//
//  GGFacebookAuthVC.m
//  Gagein
//
//  Created by Dong Yiming on 6/5/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGFacebookAuthVC.h"


@interface GGFacebookAuthVC ()

@end

@implementation GGFacebookAuthVC
{
    FBLoginView         *_fbLoginView;
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
	
    _fbLoginView = [[FBLoginView alloc] init];
    
    //_fbLoginView.frame = CGRectOffset(loginview.frame, 5, 5);
    _fbLoginView.delegate = self;
    
    [self.view addSubview:_fbLoginView];
    
    [_fbLoginView sizeToFit];
}


#pragma mark - fb loginview delegate
/*!
 @abstract
 Tells the delegate that the view is now in logged in mode
 
 @param loginView   The login view that transitioned its view mode
 */
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    DLog(@"loginViewShowingLoggedInUser");
}

/*!
 @abstract
 Tells the delegate that the view is has now fetched user info
 
 @param loginView   The login view that transitioned its view mode
 
 @param user        The user info object describing the logged in user
 */
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    DLog(@"loginViewFetchedUserInfo");
    FBSession *session = [FBSession activeSession];
    DLog(@"^%@", session);
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self postNotification:OA_NOTIFY_FACEBOOK_AUTH_OK withObject:session];
    }];
}

/*!
 @abstract
 Tells the delegate that the view is now in logged out mode
 
 @param loginView   The login view that transitioned its view mode
 */
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    DLog(@"loginViewShowingLoggedOutUser");
    //[self.navigationController popViewControllerAnimated:YES];
}

/*!
 @abstract
 Tells the delegate that there is a communication or authorization error.
 
 @param loginView           The login view that transitioned its view mode
 @param error               An error object containing details of the error.
 @discussion See https://developers.facebook.com/docs/technical-guides/iossdk/errors/
 for error handling best practices.
 */
- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    DLog(@"handleError");
    [self.navigationController popViewControllerAnimated:NO];
}

@end
