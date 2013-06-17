//
//  GGSsgrfPanelDoubleInfoPlus.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPanelDoubleInfoPlus.h"

#import "GGSsgrfInfoWidgetView.h"
#import "GGSsgrfDblTitleView.h"

#import "GGHappening.h"

@implementation GGSsgrfPanelDoubleInfoPlus

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(float)HEIGHT
{
    return 425.f;
}

-(void)awakeFromNib
{
    self.backgroundColor = PANEL_COLOR;
    _viewLeftInfo.backgroundColor = [UIColor clearColor];
    _viewRightInfo.backgroundColor = [UIColor clearColor];
    
    _viewLeftText.backgroundColor = [UIColor clearColor];
    _viewRightText.backgroundColor = [UIColor clearColor];
    
    _viewBottomInfo.backgroundColor = [UIColor clearColor];
}


-(void)setLeftText:(NSString *)aText
{
    _viewLeftInfo.hidden = YES;
    _viewLeftText.hidden = NO;
    
    [_viewLeftText setTitle:aText];
    [self _adjustTextPos];
}

-(void)setLeftSubText:(NSString *)aText
{
    _viewLeftInfo.hidden = YES;
    _viewLeftText.hidden = NO;
    
    [_viewLeftText setSubTitle:aText];
    [self _adjustTextPos];
}

-(void)setRightText:(NSString *)aText
{
    _viewRightInfo.hidden = YES;
    _viewRightText.hidden = NO;
    
    [_viewRightText setTitle:aText];
    [self _adjustTextPos];
}

-(void)setRightSubText:(NSString *)aText
{
    _viewRightInfo.hidden = YES;
    _viewRightText.hidden = NO;
    
    [_viewRightText setSubTitle:aText];
    [self _adjustTextPos];
}

-(void)_adjustTextPos
{
    CGRect leftTextRc = _viewLeftText.frame;
    
    leftTextRc.origin.y = _ivArrow.frame.origin.y
    - (leftTextRc.size.height - _ivArrow.frame.size.height) / 2;
    
    _viewLeftText.frame = leftTextRc;
    
    CGRect rightTextRc = _viewRightText.frame;
    
    rightTextRc.origin.y = _ivArrow.frame.origin.y
    - (rightTextRc.size.height - _ivArrow.frame.size.height) / 2;
    
    _viewRightText.frame = rightTextRc;
}

-(void)setLeftBigTitle
{
    [_viewLeftText useBigTitle];
    [self _adjustTextPos];
}

-(void)setRightBigTitle
{
    [_viewRightText useBigTitle];
    [self _adjustTextPos];
}

-(void)updateWithHappening:(GGHappening *)aHappening
{
    _happening = aHappening;
    if (_happening)
    {
        switch (aHappening.type)
        {
            case kGGHappeningPersonUpdateProfilePic:
            {
                // left - old pic
                [self.viewLeftInfo updateWithPerson:_happening.person showOldPhoto:YES];
                
                // right - new pic
                [self.viewRightInfo updateWithPerson:_happening.person showOldPhoto:NO];
                
                // bottom - company
                [self.viewBottomInfo updateWithCompany:_happening.company];
            }
                break;
                
                
            default:
                break;
        }
    }
}

@end
