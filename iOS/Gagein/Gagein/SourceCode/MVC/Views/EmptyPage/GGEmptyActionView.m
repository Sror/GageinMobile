//
//  GGEmptyActionView.m
//  Gagein
//
//  Created by dong yiming on 13-5-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGEmptyActionView.h"

@implementation GGEmptyActionView

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
    //self.hidden = YES;
}

-(void)setMessageCode:(GGApiParser *)anApiParser vc:(GGBaseViewController *)aVc
{
    if (anApiParser && aVc)
    {
        [self setMessageCode:anApiParser];
        
        [_btnAction removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        switch (anApiParser.messageCode)
        {
            case kGGMsgCodeNoUpdateForLessFollowedCompanies:
            {
                [_btnAction addTarget:aVc action:@selector(presentPageFollowCompanies) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodeNoUpdateForAllSalesTriggers:
            {
                [_btnAction addTarget:aVc action:@selector(presentPageSelectAgents) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodeNoEventForLessFollowedContacts:
            {
                [_btnAction addTarget:aVc action:@selector(presentPageFollowPeople) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case kGGMsgCodeNoEventForTheAllSelectedFunctionals:
            {
                [_btnAction addTarget:aVc action:@selector(presentPageSelectFuncArea) forControlEvents:UIControlEventTouchUpInside];
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
            _viewSimple.hidden = YES;
            _lblTitle.text = @"Have trouble seeing updates?";
            _lblMessage.text = @"Add companies to watch for important updates.";
            [_btnAction setTitle:@"Add Companies to Follow" forState:UIControlStateNormal];
        }
            break;
            
        case kGGMsgCodeNoUpdateForMoreFollowedCompanies:
        {
            _lblSimpleMessage.text = [NSString stringWithFormat:@"In the last %@ days, there were no triggers found for your followed companies.", anApiParser.messageExtraInfo];
        }
            break;
            
        case kGGMsgCodeNoUpdateForAllSalesTriggers:
        {
            _viewSimple.hidden = YES;
            _lblTitle.text = @"Have trouble seeing updates?";
            _lblMessage.text = @"Select sales triggers to explore new opportunities.";
            [_btnAction setTitle:@"Select Sales Triggers" forState:UIControlStateNormal];
        }
            break;
            
        case kGGMsgCodeNoUpdateForTheCompany:
        {
            _lblSimpleMessage.text = @"In the last 7 days, there were no triggers found for this company.";
        }
            break;
            
        case kGGMsgCodeNoUpdateTheSaleTrigger:
        {
            _lblSimpleMessage.text = @"No available updates at this time.";
        }
            break;
            
        case kGGMsgCodeNoUpdateTheUnfollowedCompany:
        {
            _lblSimpleMessage.text = @"Follow this company to activate its update feed.";
        }
            break;
            
        case kGGMsgCodeNoUpdateTheUnavailableCompany:
        {
            _lblSimpleMessage.text = @"Please give us [1 business day/3 business days/5 business days] to respond to your request to follow this company. We will notify you as soon as updates are available.";
        }
            break;
            
        case kGGMsgCodeNoEventForLessFollowedCompanies:
        case kGGMsgCodeNoEventForMoreFollowedCompanies:
        {
            _lblSimpleMessage.text = @"No happenings found for your followed companies as of this new feature launch in May 2013.";
        }
            break;
            
        case kGGMsgCodeNoEventForTheCompany:
        {
            _lblSimpleMessage.text = @"No happenings found for this company as of this new feature launch in May 2013.";
        }
            break;
            
        case kGGMsgCodeNoEventForLessFollowedContacts:
        {
            _viewSimple.hidden = YES;
            _lblTitle.text = @"Have trouble seeing updates?";
            _lblMessage.text = @"Add people to watch for job, location, and other changes.";
            [_btnAction setTitle:@"Add People to Follow" forState:UIControlStateNormal];
        }
            break;
            
        case kGGMsgCodeNoEventForMoreFollowedContacts:
        {
            _lblSimpleMessage.text = @"No updates found for your followed people as of this new feature launch in May 2013.";
        }
            break;
            
        case kGGMsgCodeNoEventForTheContact:
        {
            _lblSimpleMessage.text = @"No updates found for this person as of this new feature launch in May 2013.";
        }
            break;
            
        case kGGMsgCodeNoEventForTheAllSelectedFunctionals:
        {
            _viewSimple.hidden = YES;
            _lblTitle.text = @"Have trouble seeing updates?";
            _lblMessage.text = @"Select functional roles to keep up with leadership changes.";
            [_btnAction setTitle:@"Select Functional Roles" forState:UIControlStateNormal];
        }
            break;
            
        case kGGMsgCodeNoEventForTheFunctional:
        {
            _lblSimpleMessage.text = @"No available updates at this time.";
        }
            break;
            
        default:
        {
            _lblSimpleMessage.text = @"No available data at this time.";
        }
            break;
    }
}

@end
