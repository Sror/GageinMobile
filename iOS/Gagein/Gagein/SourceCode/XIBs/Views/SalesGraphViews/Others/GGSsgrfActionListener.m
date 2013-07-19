//
//  GGSsgrfActionListener.m
//  Gagein
//
//  Created by Dong Yiming on 6/16/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGSsgrfActionListener.h"
#import "GGAppDelegate.h"

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
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_CHART_IMAGE_URL];
        [self observeNotification:GG_NOTIFY_SSGRF_SHOW_MAP_IMAGE_URL];
        
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
        [self.delegate ssGraphShowPersonPanel:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_COMPANY_PANEL])
    {
        [self.delegate ssGraphShowCompanyPanel:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_PERSON_LANDING_PAGE])
    {
        [self.delegate ssGraphShowPersonLandingPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_COMPANY_LANDING_PAGE])
    {
        [self.delegate ssGraphShowCompanyLandingPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_EMPLOYEE_LIST_PAGE])
    {
        [self.delegate ssGraphShowEmployeeListPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_EMPLOYER_LIST_PAGE])
    {
        [self.delegate ssGraphShowEmployerListPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_WEBPAGE])
    {
        [self.delegate ssGraphShowWebPage:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_FOLLOW_PERSON])
    {
        [self.delegate ssGraphFollowPerson:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_UNFOLLOW_PERSON])
    {
        [self.delegate ssGraphUnfollowPerson:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_FOLLOW_COMPANY])
    {
        [self.delegate ssGraphFollowCompany:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_UNFOLLOW_COMPANY])
    {
        [self.delegate ssGraphUnfollowCompany:notiObj];
    }
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_IMAGE_URL])
    {
        [self.delegate ssGraphShowImageURL:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_MAP_IMAGE_URL])
    {
        [self.delegate ssGraphShowMapImageURL:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHOW_CHART_IMAGE_URL])
    {
        [self.delegate ssGraphShowChartImageURL:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SIGNAL])
    {
        [self.delegate ssGraphSignal:notiObj];
    }
    
    else if ([notiName isEqualToString:GG_NOTIFY_SSGRF_SHARE])
    {
        [self.delegate ssGraphShare:notiObj];
    }
}

-(id<GGSsgrfActionDelegate>)delegate
{
    id candidate = GGSharedDelegate.currentActionListener;
    if ([candidate conformsToProtocol:@protocol(GGSsgrfActionDelegate)])
    {
        return candidate;
    }
    
    return nil;
}

-(void)dealloc
{
    [self unobserveAllNotifications];
}

@end
