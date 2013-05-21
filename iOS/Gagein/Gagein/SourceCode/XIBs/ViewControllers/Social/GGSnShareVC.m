//
//  GGSnShareVC.m
//  Gagein
//
//  Created by Dong Yiming on 5/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSnShareVC.h"
#import "GGCompanyUpdate.h"

#define MAX_MESSAGE_LEN     250

@interface GGSnShareVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation GGSnShareVC

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
    //self.view.backgroundColor = GGSharedColor.silver;
    self.textView.text = [self _messageToShare];
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
    NSString *summary = _comUpdateDetail.content.length ? _comUpdateDetail.content : _comUpdateDetail.textview;
    summary = (summary.length > MAX_MESSAGE_LEN) ? [summary substringToIndex:MAX_MESSAGE_LEN] : summary;
    NSString *picURL = _comUpdateDetail.pictures.count ? _comUpdateDetail.pictures[0] : nil;
    
    [self showLoadingHUD];
    [GGSharedAPI snShareNewsWithID:_comUpdateDetail.ID snType:_snType message:_textView.text headLine:_comUpdateDetail.headline summary:summary pictureURL:picURL callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            [self showCheckMarkHUDWithText:@"Shared!"];
            [self naviBackAction:nil];
        }
    }];
}

-(NSString *)_messageToShare
{
    NSString *message = [NSString stringWithFormat:@"%@\n\n - shared from GageIn, a visual sales intelligence company.", _comUpdateDetail.headline];
    ;
    
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
@end
