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

#import "GGStringFormatter.h"

@implementation GGSsgrfPanelTripleInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
    
    [_viewLeftText setTitleNumOfLines:3];
    [_viewRightText setTitleNumOfLines:3];
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

-(void)_doUpdate
{
    if (_happening)
    {
        switch (_happening.type) {
            case kGGHappeningCompanyPersonJion:
            case kGGHappeningPersonJoinOtherCompany:
            {
                // left - old company
                [_viewLeftInfo updateWithCompany:_happening.oldCompany];
                
                // center - person
                [_viewCenterInfo updateWithPerson:_happening.person];
                
                // right - new company
                [_viewRightInfo updateWithCompany:_happening.company];
            }
                break;
                
            case kGGHappeningCompanyEmloyeeSizeIncrease:
            case kGGHappeningCompanyEmloyeeSizeDecrease:
            {
                // left - old employee size
                [self setLeftText:_happening.oldEmployNum];
                [self setLeftSubText:[GGStringFormatter stringForEmployeesWithDate:_happening.oldTimestamp]];
                
                
                // center - company
                [self.viewCenterInfo updateWithCompany:_happening.company];
                
                // right - new employee size
                [self setRightText:_happening.employNum];
                [self setRightSubText:[GGStringFormatter stringForEmployeesWithDate:_happening.timestamp]];
            }
                break;
                
            default:
                break;
        }
        
        self.blackCurtainView.hidden = YES;
    }
}

@end
