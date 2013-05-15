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
    _lblTitle.lineBreakMode = UILineBreakModeWordWrap;
}

-(float)height
{
    return self.frame.size.height;
}

-(void)adjustHeight
{
    int textviewHeight = _tvContent.contentSize.height;
    CGRect theRect = _tvContent.frame;
    theRect.size.height = textviewHeight;
    _tvContent.frame = theRect;
    
    [self setHeight:CGRectGetMaxY(_tvContent.frame)];
}

-(void)setHeight:(float)aHeight
{
    CGRect theRect = _viewContent.frame;
    theRect.size.height = aHeight;
    _viewContent.frame = theRect;
    
    theRect.size.height += 5;
    self.frame = theRect;
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
    // adjust photo position
    CGRect photoRc = _ivPhoto.frame;
    photoRc.origin.y = CGRectGetMaxY(_lblTitle.frame) + 20;
    _ivPhoto.frame = photoRc;
    
    // adjust textview positon
    float textviewY = [self _textviewPositionY];
    _tvContent.frame = CGRectMake(_tvContent.frame.origin.x
                                   , textviewY
                                   , _tvContent.frame.size.width
                                   , _tvContent.frame.size.height);
    
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
