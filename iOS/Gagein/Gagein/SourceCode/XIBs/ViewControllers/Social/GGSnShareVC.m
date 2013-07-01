//
//  GGSnShareVC.m
//  Gagein
//
//  Created by Dong Yiming on 5/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSnShareVC.h"
#import "GGCompanyUpdate.h"
#import "GGHappening.h"

#import "GGLinkedInOAuthVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SFOAuthCredentials.h"
#import "OAToken.h"

#define MAX_MESSAGE_LENGTH              (400)
#define MAX_MESSAGE_LENGTH_TWITTER      (140)
#define MAX_SUMMARY_LENGTH              (250)

#define TAG_ALERT_SALESFORCE_OAUTH_FAILED   1000


@interface GGSnShareVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation GGSnShareVC
{
    //BOOL        _isLinking;
}

-(NSUInteger)maxLenghForMessageType:(EGGSnType)aSnType
{
    switch (aSnType)
    {
        case kGGSnTypeFacebook:
        {
            return MAX_MESSAGE_LENGTH;
        }
            break;
            
        case kGGSnTypeSalesforce:
        {
            return MAX_MESSAGE_LENGTH;
        }
            break;
            
        case kGGSnTypeTwitter:
        {
            return MAX_MESSAGE_LENGTH_TWITTER;
        }
            break;
            
        case kGGSnTypeLinkedIn:
        {
            return 250;
        }
            break;
            
        case kGGSnTypeYammer:
        {
            return MAX_MESSAGE_LENGTH;
        }
            break;
            
        default:
            break;
    }
    
    return MAX_MESSAGE_LENGTH;
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
    [self observeNotification:OA_NOTIFY_FACEBOOK_AUTH_OK];
    [self observeNotification:OA_NOTIFY_SALESFORCE_AUTH_OK];
    [self observeNotification:OA_NOTIFY_TWITTER_OAUTH_OK];
    
    [super viewDidLoad];
    
    self.naviTitle = [self snNameFromType:_snType];
    self.view.backgroundColor = GGSharedColor.white;
    self.textView.text = [self _messageToShare];
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
    CGRect textRc = _textView.frame;
    textRc.size.height = [UIScreen mainScreen].applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT;
    _textView.frame = textRc;
    
    //
    self.navigationItem.leftBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Cancel" target:self selector:@selector(naviBackAction:)];
    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Share" target:self selector:@selector(shareAction:)];
    
    [self _checkIfHasLinked];
}

-(BOOL)_checkIfHasLinked
{
    BOOL hasLinked = [GGUtils hasLinkedSnType:_snType];
    if (!hasLinked)
    {
        [_textView resignFirstResponder];
        
        switch (_snType)
        {
            case kGGSnTypeFacebook:
                [self connectFacebookReadAndPublish];
                break;
                
            case kGGSnTypeSalesforce:
                [self connectSalesForce];
                break;
                
            case kGGSnTypeLinkedIn:
                [self connectLinkedIn];
                break;
                
            case kGGSnTypeTwitter:
                [self connectTwitter];
                break;
                
            default:
                break;
        }
        
        //_isLinking = YES;
    }
    else
    {
         [_textView becomeFirstResponder];
    }
    
    return hasLinked;
}

- (void)handleNotification:(NSNotification *)notification
{
    NSString *notiName = notification.name;
    if ([notiName isEqualToString:OA_NOTIFY_LINKEDIN_AUTH_OK])
    {
        [self unobserveNotification:OA_NOTIFY_LINKEDIN_AUTH_OK];
        
        [self showLoadingHUD];
        id op = [GGSharedAPI snSaveLinedInWithToken:self.linkedInAuthView.accessToken.key secret:self.linkedInAuthView.accessToken.secret callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [GGUtils addSnType:kGGSnTypeLinkedIn];
                //_isLinking = NO;
            }
        }];
        
        [self registerOperation:op];
        
    }
    else if ([notiName isEqualToString:OA_NOTIFY_FACEBOOK_AUTH_OK])
    {
        FBSession *session = notification.object;
        NSString *accessToken = session.accessTokenData.accessToken;//[GGFacebookOAuth sharedInstance].session.accessTokenData.accessToken;
        
        [self showLoadingHUD];
        id op = [GGSharedAPI snSaveFacebookWithToken:accessToken callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [GGUtils addSnType:kGGSnTypeFacebook];
                //_isLinking = NO;
            }
        }];
        
        [self registerOperation:op];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_SALESFORCE_AUTH_OK]) // salesforce ok
    {
        SFOAuthCredentials *credencial = notification.object;
        
        [self showLoadingHUD];
        id op = [GGSharedAPI snSaveSalesforceWithToken:credencial.accessToken accountID:credencial.userId refreshToken:credencial.refreshToken instanceURL:credencial.instanceUrl.absoluteString callback:^(id operation, id aResultObject, NSError *anError) {
            
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            
            if (parser.isOK)
            {
                [GGUtils addSnType:kGGSnTypeSalesforce];
                //_isLinking = NO;
            }
            else if (parser.messageCode == kGGMsgCodeSnSaleforceCantAuth)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[GGStringPool stringWithMessageCode:kGGMsgCodeSnSaleforceCantAuth] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Learn more", nil];
                alert.tag = TAG_ALERT_SALESFORCE_OAUTH_FAILED;
                [alert show];
            }
            
        }];
        
        [self registerOperation:op];
    }
    else if ([notiName isEqualToString:OA_NOTIFY_TWITTER_OAUTH_OK]) // twitter oauth ok
    {
        OAToken *token = notification.object;
        
        [self showLoadingHUD];
        id op = [GGSharedAPI snSaveTwitterWithToken:token.key secret:token.secret callback:^(id operation, id aResultObject, NSError *anError) {
            
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [GGUtils addSnType:kGGSnTypeTwitter];
                //_isLinking = NO;
            }
            
        }];
        
        [self registerOperation:op];
    }
}

#pragma mark - ui alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAG_ALERT_SALESFORCE_OAUTH_FAILED)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.salesforce.com/crm/editions-pricing.jsp"]];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackButton];
    
}

#pragma mark - actions
-(void)shareAction:(id)sender
{
    if (![self _checkIfHasLinked])
    {
        return;
    }
    
    NSString *summary, *message, *picURL;
    
    //
    int maxLength = [self maxLenghForMessageType:_snType];
    maxLength -= 20;
    
//    if (_textView.text.length > maxLength)
//    {
//        [GGAlert alertWithMessage:@""];
//        return;
//    }
    
    message = (_textView.text.length > maxLength) ? [NSString stringWithFormat:@"%@...", [_textView.text substringToIndex:maxLength - 3]] : _textView.text;
    
    //
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            [_textView resignFirstResponder];
            [self showCheckMarkHUDWithText:GGString(@"Share sent")];
            
            [self performSelector:@selector(naviBackAction:) withObject:nil afterDelay:1.f];
            //[self naviBackAction:nil];
        }
        else
        {
            //It looks like your account has been disconnected from Facebook
            
            NSString *message = [NSString stringWithFormat:@"It looks like your account has been disconnected from %@.", [GGUtils stringForSnType:_snType]];
            [GGAlert alertWithMessage:message title:@"Share failed"];
            [self _removeSnType:_snType];
            [self naviBackAction:nil];
        }
    };
    
    //
    switch (_shareType)
    {
        case kGGSnShareTypeUpdate:
        {
            summary = _comUpdateDetail.content.length ? _comUpdateDetail.content : _comUpdateDetail.textview;
            summary = (summary.length > MAX_SUMMARY_LENGTH) ? [summary substringToIndex:MAX_SUMMARY_LENGTH] : summary;
            
            picURL = _comUpdateDetail.pictures.count ? _comUpdateDetail.pictures[0] : nil;
            
            [self showLoadingHUD];
            id op = [GGSharedAPI snShareNewsWithID:_comUpdateDetail.ID
                                            snType:_snType
                                           message:message
                                          headLine:_comUpdateDetail.headline
                                           summary:summary
                                        pictureURL:picURL
                                          callback:callback];
            
            [self registerOperation:op];
        }
            break;
            
        case kGGSnShareTypeHappeningCompany:
        {
            [self showLoadingHUD];
            id op = [GGSharedAPI snShareComanyEventWithID:_happening.ID
                                                   snType:_snType
                                                  message:message callback:callback];
            [self registerOperation:op];
        }
            break;
            
        case kGGSnShareTypeHappeningPerson:
        {
            [self showLoadingHUD];
            id op = [GGSharedAPI snSharePersonEventWithID:_happening.ID
                                                   snType:_snType
                                                  message:message callback:callback];
            [self registerOperation:op];
        }
            break;
            
        default:
            break;
    }
}

-(void)_removeSnType:(EGGSnType)aSnType
{
    for (NSString *type in _snTypesRef)
    {
        if (type.longLongValue == aSnType)
        {
            [_snTypesRef removeObject:type];
            break;
        }
    }
}


-(NSString *)_messageToShare
{
    NSString *message = nil;
    if (_comUpdateDetail)
    {
//        message = [NSString stringWithFormat:@"%@\n\n - shared from GageIn, a visual sales intelligence company.", _comUpdateDetail.headline];
//        ;
        message = _comUpdateDetail.headline;
    }
    else if (_happening)
    {
//        message = [NSString stringWithFormat:@"%@\n\n - shared from GageIn, a visual sales intelligence company.", _happening.headLineText];
        message = _happening.headLineText;
    }
    
    return message;
}

-(NSString *)snNameFromType:(EGGSnType)aSnType
{
    switch (aSnType)
    {
        case kGGSnTypeFacebook:
        {
            return @"Facebook";
        }
            break;
            
        case kGGSnTypeLinkedIn:
        {
            return @"LinkedIn";
        }
            break;
            
        case kGGSnTypeSalesforce:
        {
            return @"Salesforce";
        }
            break;
            
        case kGGSnTypeTwitter:
        {
            return @"Twitter";
        }
            break;
            
        case kGGSnTypeYammer:
        {
            return @"Yammer";
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}


- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}

#pragma mark - textview delegate
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    return YES;
//}

@end
