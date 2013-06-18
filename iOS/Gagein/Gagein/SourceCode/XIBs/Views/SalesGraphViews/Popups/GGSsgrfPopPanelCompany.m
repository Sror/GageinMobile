//
//  GGSsgrfPopPanelCompany.m
//  TestPanel
//
//  Created by Dong Yiming on 6/17/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPopPanelCompany.h"

@implementation GGSsgrfPopPanelCompany

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _doInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _doInit];
    }
    
    return self;
}


-(void)_doInit
{
}

-(void)awakeFromNib
{
    self.layer.cornerRadius = 8.f;
    
    self.viewFooter.layer.cornerRadius = 8.f;
    self.layer.shadowColor = GGSharedColor.black.CGColor;
    self.layer.shadowOpacity = 1.f;
    self.layer.shadowOffset = CGSizeMake(3.f, 3.f);
    self.layer.shadowRadius = 4.f;
    
    _lblTitle.text = _lblSubTitle.text
    = _lblEmp1Title.text = _lblEmp1SubTitle.text
    = _lblEmp2Title.text = _lblEmp2SubTitle.text
    = _lblEmp3Title.text = _lblEmp3SubTitle.text
    = _lblOwnership.text = _lblEmployees.text
    = _lblRevenue.text = _lblFortuneRank.text
    = _lblFiscalYear.text = _lblEmail.text
    = _lblPhone.text = _lblFax.text = _lblAddress.text = @"";
}




@end
