//
//  GGEmptyActionView.m
//  Gagein
//
//  Created by dong yiming on 13-5-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGEmptyActionView.h"

@implementation GGEmptyActionView
{
    GGBaseViewController    *_vc;
    
    BOOL                    _personFollowed;
    BOOL                    _companyFollowed;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.backgroundColor = GGSharedColor.silver;
    [_btnAction setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
    [_btnAction setBackgroundImage:GGSharedImagePool.bgBtnGray forState:UIControlStateSelected];
    //self.hidden = YES;
    
    [_lblMessage applyEffectEmboss];
    [_lblSimpleMessage applyEffectEmboss];
}

#pragma mark - btn action
-(void)goAddingCompanies:(id)sender
{
    [_vc presentPageFollowCompanies];
}

-(void)goSelectingAgents:(id)sender
{
    [_vc presentPageSelectAgents];
}

-(void)goFollowPeople:(id)sender
{
    [_vc presentPageFollowPeople];
}

-(void)goSelectingFunctionAreas:(id)sender
{
    [_vc presentPageFollowCompanies];
}

-(void)goChekingCompanyProfile:(id)sender
{
    [_vc enterCompanyDetailWithID:_companyID];
}

-(void)goFollowThePerson:(id)sender
{
    if (_personFollowed)
    {
        [GGSharedAPI unfollowPersonWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [self postNotification:GG_NOTIFY_PERSON_FOLLOW_CHANGED];
            }
        }];
    }
    else
    {
        [GGSharedAPI followPersonWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [self postNotification:GG_NOTIFY_PERSON_FOLLOW_CHANGED];
            }
        }];
    }
    
    _personFollowed = !_personFollowed;
    [_btnAction setTitle:(_personFollowed ? @"Unfollow" : @"Follow") forState:UIControlStateNormal];
    _btnAction.selected = _personFollowed;
}

-(void)goUnfollowTheCompany:(id)sender
{
    [GGSharedAPI unfollowCompanyWithID:_companyID callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            [GGAlert alertWithMessage:@"You have unfollowed it successfully."];
            [self postNotification:GG_NOTIFY_PERSON_FOLLOW_CHANGED];
        }
        _btnAction.hidden = YES;
    }];
}

-(void)goFollowTheCompany:(id)sender
{
    if (_companyFollowed)
    {
        [GGSharedAPI unfollowCompanyWithID:_companyID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [self postNotification:GG_NOTIFY_COMPANY_FOLLOW_CHANGED];
            }
        }];
    }
    else
    {
        [GGSharedAPI followCompanyWithID:_companyID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [self postNotification:GG_NOTIFY_COMPANY_FOLLOW_CHANGED];
            }
        }];
    }
    
    _companyFollowed = !_companyFollowed;
    [_btnAction setTitle:(_companyFollowed ? @"Unfollow" : @"Follow") forState:UIControlStateNormal];
    _btnAction.selected = _companyFollowed;
}

#pragma mark -

-(void)setMessageCode:(GGApiParser *)anApiParser vc:(GGBaseViewController *)aVc
{
    _vc = aVc;
    
    if (anApiParser && aVc)
    {
        [self setMessageCode:anApiParser];
        
        [_btnAction removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        
        long long code = anApiParser.messageCode;
        switch (code)
        {
            case kGGMsgCodeNoUpdateForLessFollowedCompanies:
            {
                [_btnAction addTarget:self action:@selector(goAddingCompanies:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodeNoUpdateForAllSalesTriggers:
            {
                [_btnAction addTarget:self action:@selector(goSelectingAgents:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodeNoEventForLessFollowedContacts:
            {
                [_btnAction addTarget:self action:@selector(goFollowPeople:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodeNoEventForTheAllSelectedFunctionals:
            {
                [_btnAction addTarget:self action:@selector(goSelectingFunctionAreas:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodeNoUpdateForTheCompany:
            {
                [_btnAction addTarget:self action:@selector(goChekingCompanyProfile:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodePeopleNotFollowed:
            {
                [_btnAction addTarget:self action:@selector(goFollowThePerson:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodeCompanyNotFollowed:
            case kGGMsgCodeNoUpdateTheUnfollowedCompany:
            {
                [_btnAction addTarget:self action:@selector(goFollowTheCompany:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodeCompanyGradeBNoUpdate:
            {
                [_btnAction addTarget:self action:@selector(goUnfollowTheCompany:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)setMessageCode:(GGApiParser *)anApiParser
{
    _viewSimple.hidden = NO;
    
    switch (anApiParser.messageCode)
    {
        case kGGMsgCodeNoUpdateForLessFollowedCompanies:
        {
            [self _showTitle:GGString(@"Have trouble seeing updates?")
                     message:GGString(@"Add companies to watch for important updates.")
                 actionTitle:GGString(@"Add Companies to Follow")];
        }
            break;
            
        case kGGMsgCodeNoUpdateForMoreFollowedCompanies:
        {
            NSString *dayCountStr = anApiParser.messageExtraInfo;
            dayCountStr = dayCountStr.length ? dayCountStr : @"7";
            _lblSimpleMessage.text = [NSString stringWithFormat:GGString(@"In the last %@ days, there were no triggers found for your followed companies."), dayCountStr];
        }
            break;
            
        case kGGMsgCodeNoUpdateForAllSalesTriggers:
        {
            [self _showTitle:GGString(@"Have trouble seeing updates?")
                     message:GGString(@"Select sales triggers to explore new opportunities.")
                 actionTitle:GGString(@"Select Sales Triggers")];
        }
            break;
            
        case kGGMsgCodeNoUpdateForTheCompany:
        {
            [self _showTitle:nil
                     message:GGString(@"In the last 7 days, there were no triggers found for this company.")
                 actionTitle:GGString(@"Check out profile")];

            //_lblSimpleMessage.text = GGString(@"In the last 7 days, there were no triggers found for this company.");
//            _viewSimple.hidden = YES;
//            _lblTitle.text = nil;
//            _lblMessage.text = ;
//            [_btnAction setTitle:GGString(@"Check out profile") forState:UIControlStateNormal];
        }
            break;
            
        case kGGMsgCodeNoUpdateTheSaleTrigger:
        {
            _lblSimpleMessage.text = GGString(@"No available updates at this time.");
        }
            break;
            
        case kGGMsgCodeNoUpdateTheUnfollowedCompany:
        {
            [self _showTitle:nil
                     message:GGString(@"Follow this company to activate\n its update feed.")
                 actionTitle:GGString(@"Follow")];
            //_lblSimpleMessage.text = GGString(@"Follow this company to\n activate its update feed.");
        }
            break;
            
        case kGGMsgCodeCompanyGradeCNoUpdate:
        case kGGMsgCodeNoUpdateTheUnavailableCompany:
        {
            _lblSimpleMessage.text = GGString(@"Please give us 5 business days to respond to your request to follow this company. We will notify you as soon as updates are available.");
        }
            break;
            
        case kGGMsgCodeNoEventForLessFollowedCompanies:
        case kGGMsgCodeNoEventForMoreFollowedCompanies:
        {
            _lblSimpleMessage.text = GGString(@"No happenings found for your followed companies as of this new feature launch in July 2013.");
        }
            break;
            
        case kGGMsgCodeNoEventForTheCompany:
        {
            _lblSimpleMessage.text = GGString(@"No happenings found for this company as of this new feature launch in July 2013.");
        }
            break;
            
        case kGGMsgCodeNoEventForLessFollowedContacts:
        {
            [self _showTitle:GGString(@"Have trouble seeing updates?")
                     message:GGString(@"Add people to watch for job, location, and other changes.")
                 actionTitle:GGString(@"Add People to Follow")];
        }
            break;
            
        case kGGMsgCodeNoEventForMoreFollowedContacts:
        {
            _lblSimpleMessage.text = GGString(@"No updates found for your followed people as of this new feature launch in July 2013.");
        }
            break;
            
        case kGGMsgCodeNoEventForTheContact:
        {
            _lblSimpleMessage.text = GGString(@"No updates found for this person as of this new feature launch in July 2013.");
        }
            break;
            
        case kGGMsgCodeNoEventForTheAllSelectedFunctionals:
        {
            [self _showTitle:GGString(@"Have trouble seeing updates?")
                     message:GGString(@"Select functional roles to keep up with leadership changes.")
                 actionTitle:GGString(@"Select Functional Roles")];
        }
            break;
            
        case kGGMsgCodeNoEventForTheFunctional:
        {
            _lblSimpleMessage.text = GGString(@"No available updates at this time.");
        }
            break;
            
        case kGGMsgCodePeopleNotFollowed:
        {
            [self _showTitle:nil
                     message:GGString(@"No longer a followed person.")
                 actionTitle:GGString(@"Follow")];
            
            //_lblSimpleMessage.text = GGString(@"No longer a followed person.");
        }
            break;
            
        case kGGMsgCodeCompanyNotFollowed:
        {
            [self _showTitle:nil
                     message:GGString(@"No longer a followed company.")
                 actionTitle:GGString(@"Follow")];
            
            //_lblSimpleMessage.text = GGString(@"No longer a followed company.");
        }
            break;
            
        case kGGMsgCodeCompanyGradeBNoUpdate:
        {
            [self _showTitle:nil
                     message:[GGStringPool stringWithMessageCode:kGGMsgCodeCompanyGradeBNoUpdate]
                 actionTitle:GGString(@"Unfollow")];
        }
            break;
            
        default:
        {
            _lblSimpleMessage.text = GGString(@"No available data at this time.");
        }
            break;
    }
}

-(void)_showTitle:(NSString *)aTitle message:(NSString *)aMessage actionTitle:(NSString *)anActionTitle
{
    _viewSimple.hidden = YES;
    _lblTitle.text = aTitle;
    _lblMessage.text = aMessage;
    [_btnAction setTitle:anActionTitle forState:UIControlStateNormal];
}

@end
