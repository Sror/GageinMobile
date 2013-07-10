//
//  GGSgrfTitleView.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfDblTitleView.h"
#import "GGAutosizingLabel.h"

@interface GGSsgrfDblTitleView ()
@property (strong, nonatomic) GGAutosizingLabel   *lblTitle;
@property (strong, nonatomic) GGAutosizingLabel   *lblSubTitle;

@end

@implementation GGSsgrfDblTitleView


-(void)_doInit
{
    //self.backgroundColor = [UIColor redColor];
    CGRect thisRc = self.bounds;
    thisRc.size.height /= 2;
    
    _lblTitle = [[GGAutosizingLabel alloc] initWithFrame:thisRc];
    _lblTitle.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE size:16.f];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.textColor = [UIColor whiteColor];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    _lblTitle.lineBreakMode = UILineBreakModeTailTruncation;
    _lblTitle.numberOfLines = 0;
    //_lblTitle.backgroundColor = GGSharedColor.darkRed;
    
    [self addSubview:_lblTitle];
    
    thisRc = CGRectOffset(thisRc, 0, thisRc.size.height);
    _lblSubTitle = [[GGAutosizingLabel alloc] initWithFrame:thisRc];
    _lblSubTitle.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_LIGHT size:14.f];
    _lblSubTitle.textColor = [UIColor lightGrayColor];
    _lblSubTitle.backgroundColor = [UIColor clearColor];
    _lblSubTitle.textAlignment = NSTextAlignmentCenter;
    _lblTitle.lineBreakMode = UILineBreakModeTailTruncation;
    _lblSubTitle.numberOfLines = 0;
    
    [self addSubview:_lblSubTitle];
}

-(void)setTitle:(NSString *)aString
{
    _lblTitle.text = aString;
    
    [self _adjustLayout];
}

-(void)setTitleNumOfLines:(NSUInteger)aNumber
{
    _lblTitle.numberOfLines = aNumber;
}

-(void)setSubTitle:(NSString *)aString
{
    _lblSubTitle.text = aString;
    
    CGRect thisRc = self.frame;
    thisRc.size.height = CGRectGetMaxY(_lblSubTitle.frame);
    self.frame = thisRc;
}

-(void)_adjustLayout
{
    _lblSubTitle.frame = [self _rectSetFrom:_lblSubTitle.frame y:CGRectGetMaxY(_lblTitle.frame)];
    
    CGRect thisRc = self.frame;
    thisRc.size.height = _lblSubTitle.text.length ? CGRectGetMaxY(_lblSubTitle.frame) : CGRectGetMaxY(_lblTitle.frame);
    self.frame = thisRc;
}

-(CGRect)_rectSetFrom:(CGRect)aSrcRect y:(float)aY
{
    aSrcRect.origin.y = aY;
    return aSrcRect;
}

-(void)useBigTitle
{
    _lblTitle.font = [UIFont boldSystemFontOfSize:18.f];
    [self _adjustLayout];
}

@end
