//
//  OTSAlert.m
//  OneStore
//
//  Created by Yim Daniel on 13-1-16.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import "GGAlert.h"
#import "YRDropdownView.h"

@implementation GGAlert

+(void)alertWithApiParser:(GGApiParser *)aParser
{
    if (aParser)
    {
        if (aParser.messageCode == kGGMsgCodeCompanyFollowedGradC)
        {
            NSString *messageFormat = [GGStringPool stringWithMessageCode:aParser.messageCode];
            NSString *message = [NSString stringWithFormat:messageFormat, [aParser.messageExtraInfo intValue]];
            [self alertWithApiMessage:message];
        }
        else if (aParser.status == kGGApiStatusUserOperationError)
        {
            NSString *message = [GGStringPool stringWithMessageCode:aParser.messageCode];
            [self alertWithApiMessage:message];
        }
        else
        {
            [self alertWithApiMessage:aParser.message];
        }
    }
}

+(void)alertWithApiMessage:(NSString *)aMessage
{
    if (aMessage.length <= 0)
    {
        //[self alertWithMessage:@"Ops, No data retrieved, may due to network problem."];
    }
    else if ([aMessage isEqualToString:@"error"])
    {
        
    }
    else
    {
        [self alertWithMessage:aMessage];
    }
}

+(void)alertWithMessage:(NSString *)aMessage
{
    [self alert:aMessage delegate:nil];
}

+(void)alertWithMessage:(NSString *)aMessage title:(NSString *)aTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aTitle
                                                    message:aMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

+(void)alertNetError
{
    [self alertWithApiMessage:@"Sorry, the network is not available currently."];
}

+(void)alertErrorForParser:(GGApiParser *)aParser
{
    if (aParser && !aParser.isOK)
    {
        NSString *message = [NSString stringWithFormat:@"Ops, Server status problem.\n status: %d\n message: %@", aParser.status, aParser.message];
        [self alertWithApiMessage:message];
    }
}

+(void)alert:(NSString *)aMessage delegate:(id/*<UIAlertViewDelegate>*/)aDelegate
{
    //aMessage = [aMessage stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:aMessage
                                                   delegate:aDelegate
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

+(void)alertCancelOK:(NSString *)aMessage delegate:(id)aDelegate
{
    [self alertCancelOK:aMessage title:nil delegate:aDelegate];
}

+(void)alertCancelOK:(NSString *)aMessage  title:(NSString *)aTitle  delegate:(id)aDelegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aTitle
                                                    message:aMessage
                                                   delegate:aDelegate
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}



#pragma mark -
+(void)showWarning:(NSString *)aTitle message:(NSString *)aMessage
{
    if (ISIPADDEVICE)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.lastObject animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = aTitle;
        hud.dimBackground = YES;
        [hud hide:YES afterDelay:3.f];
    }
    else
    {
        [YRDropdownView showDropdownInView:[UIApplication sharedApplication].windows.lastObject
                                     title:aTitle
                                    detail:aMessage
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:YES
                                 hideAfter:0.f];
    }
}


#pragma mark - Progress HUD
+(MBProgressHUD *)showCheckMarkHUDWithText:(NSString *)aText inView:(UIView *)aView
{
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    return [self showHUDWithCustomView:iv text:aText inView:aView];
}

+ (MBProgressHUD *)showHUDWithCustomView:(UIView*)aCustomView text:(NSString *)aText inView:(UIView *)aView
{
	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:aView];
	[aView addSubview:HUD];
    HUD.customView = aCustomView;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = aText;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    
    return HUD;
}

+(MBProgressHUD *)showLoadingHUDInView:(UIView *)aView
{
    return [self showLoadingHUDWithOffsetY:0 inView:aView];
}

+(MBProgressHUD *)showLoadingHUDWithOffsetY:(float)aOffsetY inView:(UIView *)aView
{
    return [self showLoadingHUDWithOffset:CGSizeMake(0, aOffsetY) inView:aView];
}

+(MBProgressHUD *)showLoadingHUDWithOffset:(CGSize)aOffset inView:(UIView *)aView
{
    return [self showLoadingHUDWithOffset:aOffset title:@"Loading" message:nil inView:aView];
}

+(MBProgressHUD *)showLoadingHUDWithOffset:(CGSize)aOffset
                                     title:(NSString *)aTitle
                                   message:(NSString *)aMessage
                                    inView:(UIView *)aView
{
    if (aView)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.xOffset = aOffset.width;
        hud.yOffset = aOffset.height;
        hud.labelText = aTitle;
        hud.detailsLabelText = aMessage;
        
        return hud;
    }
    
    return nil;
}


+(MBProgressHUD *)showLoadingHUDWithTitle:(NSString *)aTitle inView:(UIView *)aView
{
    return [self showLoadingHUDWithOffset:CGSizeZero title:aTitle message:nil inView:aView];
}

+(MBProgressHUD *)showLoadingHUDWithMessage:(NSString *)aMessage inView:(UIView *)aView
{
    return [self showLoadingHUDWithOffset:CGSizeZero title:nil message:aMessage inView:aView];
}

+(MBProgressHUD *)showToast:(NSString *)aMessage inView:(UIView *)aView
{
    if (aView)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = aMessage;
        [hud hide:YES afterDelay:1];
        
        return hud;
    }
    
    return nil;
}

@end
