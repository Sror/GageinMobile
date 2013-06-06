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
        if (aParser.status == kGGApiStatusUserOperationError)
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

@end
