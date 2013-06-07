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

#define MAX_MESSAGE_LENGTH              (400)
#define MAX_MESSAGE_LENGTH_TWITTER      (140)
#define MAX_SUMMARY_LENGTH              (250)

@interface GGSnShareVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation GGSnShareVC

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackButton];
}

#pragma mark - actions
-(void)shareAction:(id)sender
{
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
            [self showCheckMarkHUDWithText:@"Share sent"];
            
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
