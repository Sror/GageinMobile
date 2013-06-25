//
//  GGSsgrfActionListener.m
//  Gagein
//
//  Created by Dong Yiming on 6/16/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSsgrfActionListener.h"

@implementation GGSsgrfActionListener
DEF_SINGLETON(GGSsgrfActionListener)

- (id)init
{
    self = [super init];
    if (self)
    {
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_PERSON_PANEL];
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_COMPANY_PANEL];
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_PERSON_LANDING_PAGE];
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_COMPANY_LANDING_PAGE];
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_EMPLOYEE_LIST_PAGE];
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_EMPLOYER_LIST_PAGE];
        //[self observeNotification:GG_NOTIFY_SSGRF_SHOW_COMPANY_LIST_PAGE];
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_WEBPAGE];
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_IMAGE_URL];
        [self observeNotification:GG_NOTIFY_SSGRF_SHARE];
        [self observeNotification:GG_NOTIFY_SSGRF_SIGNAL];
        
        [self observeNotification:GG_NOTIFY_SSGRF_FOLLOW_PERSON];
        [self observeNotification:GG_NOTIFY_SSGRF_UNFOLLOW_PERSON];
        [self observeNotification:GG_NOTIFY_SSGRF_FOLLOW_COMPANY];
        [self observeNotification:GG_NOTIFY_SSGRF_UNFOLLOW_COMPANY];
        
    }
    return self;
}

-(void)handleNotification:(NSNotification *)notification
{
    NSString *notiName = notification.name;
    id notiObj = notification.object;
    
    if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_PERSON_PANEL])
    {
        [_delegate ssGraphShowPersonPanel:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_COMPANY_PANEL])
    {
        [_delegate ssGraphShowCompanyPanel:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_PERSON_LANDING_PAGE])
    {
        [_delegate ssGraphShowPersonLandingPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_COMPANY_LANDING_PAGE])
    {
        [_delegate ssGraphShowCompanyLandingPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_EMPLOYEE_LIST_PAGE])
    {
        [_delegate ssGraphShowEmployeeListPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_EMPLOYER_LIST_PAGE])
    {
        [_delegate ssGraphShowEmployerListPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_WEBPAGE])
    {
        [_delegate ssGraphShowWebPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_FOLLOW_PERSON])
    {
        [_delegate ssGraphFollowPerson:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_UNFOLLOW_PERSON])
    {
        [_delegate ssGraphUnfollowPerson:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_FOLLOW_COMPANY])
    {
        [_delegate ssGraphFollowCompany:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_UNFOLLOW_COMPANY])
    {
        [_delegate ssGraphUnfollowCompany:notiObj];
    }
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_IMAGE_URL])
    {
        [_delegate ssGraphShowImageURL:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SIGNAL])
    {
        [_delegate ssGraphSignal:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHARE])
    {
        [_delegate ssGraphShare:notiObj];
    }
}

-(void)dealloc
{
    [self unobserveAllNotifications];
}

@end
