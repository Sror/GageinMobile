//
//  GGSsgrfPanelPersonLeaveJoin.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfPanelTripleInfo.h"
#import "GGSsgrfInfoWidgetView.h"
#import "GGSsgrfDblTitleView.h"
#import "GGHappening.h"

@implementation GGSsgrfPanelTripleInfo
{
    GGHappening     *_happening;
}

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
    return 265.f;
}

-(void)awakeFromNib
{
    self.backgroundColor = PANEL_COLOR;
    _viewLeftInfo.backgroundColor = [UIColor clearColor];
    _viewCenterInfo.backgroundColor = [UIColor clearColor];
    _viewRightInfo.backgroundColor = [UIColor clearColor];
    
    _viewLeftText.backgroundColor = [UIColor clearColor];
    _viewRightText.backgroundColor = [UIColor clearColor];
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

    leftTextRc.origin.y = _ivLeftArrow.frame.origin.y
    - (leftTextRc.size.height - _ivLeftArrow.frame.size.height) / 2;
    
    _viewLeftText.frame = leftTextRc;
    
    CGRect rightTextRc = _viewRightText.frame;
    
    rightTextRc.origin.y = _ivLeftArrow.frame.origin.y
    - (rightTextRc.size.height - _ivLeftArrow.frame.size.height) / 2;
    
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
    if (aHappening)
    {
        switch (aHappening.type) {
            case kGGHappeningCompanyPersonJion:
            {
                // left - old company
                [_viewLeftInfo setTitle:@"old"];
                
                // center - person
                [_viewCenterInfo makeMeSimple];
                
                // right - new company
                [_viewRightInfo setTitle:@"new"];
            }
                break;
                
            case kGGHappeningCompanyEmloyeeSizeIncrease:
            case kGGHappeningCompanyEmloyeeSizeDecrease:
            {
                // left - old employee size
                [self setLeftText:@"old employee size"];
                
                // center - company
                [self.viewCenterInfo setTitle:@"company"];
                
                // right - new employee size
                [self setRightText:@"new employee size"];
            }
                break;
                
            case kGGHappeningPersonJoinOtherCompany:
            {
                // left - old company
                [self.viewLeftInfo setTitle:@"old"];
                
                // center - person
                [self.viewCenterInfo makeMeSimple];
                
                // right - new company
                [self.viewRightInfo setTitle:@"new"];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
