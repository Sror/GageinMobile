//
//  GGComUpdateDetailView.m
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComUpdateDetailView.h"

@implementation GGComUpdateDetailView
{
    //CGPoint     _textviewPos;
    //float       _distanceFromPhoto;
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
    self.ivUpdateBg.image = GGSharedImagePool.stretchShadowBgWite;
    //_textviewPos = _wvTextview.frame.origin;
    //_distanceFromPhoto = _textviewPos.y - _ivPhoto.frame.origin.y;
}

-(float)height
{
    return self.frame.size.height;
}

-(void)adjustHeight
{
    
    int textviewHeight = _textviewHidden.contentSize.height * 1.2;
    CGRect theRect = _wvTextview.frame;
    //_wvTextview.backgroundColor = [UIColor blueColor];
    theRect.size.height = textviewHeight;
    _wvTextview.frame = theRect;
    //_wvTextview.frame = [GGUtils setH:textviewHeight rect:_wvTextview.frame];
    
    float contentHeight = CGRectGetMaxY(_wvTextview.frame) + 20;
    theRect = _viewContent.frame;
    theRect.size.height = contentHeight;
    _viewContent.frame = theRect;
    //_viewContent.backgroundColor = GGSharedColor.orangeGagein;
    //_viewContent.frame = [GGUtils setH:contentHeight rect:_viewContent.frame];
    
    float selfHeight = CGRectGetMaxY(_viewContent.frame) + 20;
    theRect = self.frame;
    theRect.size.height = selfHeight;
    self.frame = theRect;
    //self.frame = [GGUtils setH:selfHeight rect:self.frame];
}

-(float)_textviewPositionY
{
    if (self.ivPhoto.hidden)
    {
        return self.ivPhoto.frame.origin.y;
    }

    return CGRectGetMaxY(_ivPhoto.frame) + 20;
}

-(void)adjustLayout
{
    float textviewY = [self _textviewPositionY];
    _wvTextview.frame = CGRectMake(_wvTextview.frame.origin.x
                                   , textviewY
                                   , _wvTextview.frame.size.width
                                   , _wvTextview.frame.size.height);
    
    [self adjustHeight];
}

-(void)adjustLayoutHasImage:(BOOL)aHasImage
{
    self.ivPhoto.hidden = !aHasImage;
    [self adjustLayout];
}

-(float)contentWidth
{
    return _viewContent.frame.size.width;
}


@end
