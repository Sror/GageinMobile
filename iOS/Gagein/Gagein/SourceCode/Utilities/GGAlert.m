//
//  OTSAlert.m
//  OneStore
//
//  Created by Yim Daniel on 13-1-16.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import "GGAlert.h"

@implementation GGAlert

+(void)alertWithApiMessage:(NSString *)aMessage
{
    if (aMessage.length <= 0)
    {
        [self alertWithMessage:@"Ops, No data retrieved, may due to network problem."];
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

@end
