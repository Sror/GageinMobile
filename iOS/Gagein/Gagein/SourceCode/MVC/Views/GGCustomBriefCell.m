//
//  GGPersonCell.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCustomBriefCell.h"

@implementation GGCustomBriefCell
{
    UIActivityIndicatorView         *_viewLoading;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    self.ivCellBg.image = GGSharedImagePool.stretchShadowBgWite;
    _viewLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _viewLoading.hidesWhenStopped = YES;
    //_viewLoading.backgroundColor = GGSharedColor.random;
    
    [_ivPhoto addSubview:_viewLoading];
    _viewLoading.frame = CGRectMake((_ivPhoto.frame.size.width - _viewLoading.frame.size.width) / 2
                                    , (_ivPhoto.frame.size.height - _viewLoading.frame.size.height) / 2
                                    , _viewLoading.frame.size.width, _viewLoading.frame.size.height);
}

+(float)HEIGHT
{
    return 70;
}

-(void)grayoutTitle:(BOOL)aGrayout
{
    _lblTitle.textColor = aGrayout ? GGSharedColor.lightGray : GGSharedColor.black;
}

-(void)loadLogoWithImageUrl:(NSString *)aImageUrl placeholder:(UIImage *)aPlaceHolder
{
    NSURL *url = [NSURL URLWithString:aImageUrl];
    
    if (url)
    {
        [_ivPhoto addSubview:_viewLoading];
        [_viewLoading startAnimating];
        
        [_ivPhoto setImageWithURL:url placeholderImage:aPlaceHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            //_viewLoading.hidden = YES;
            [_viewLoading removeFromSuperview];
            
        }];
    }
    else
    {
        _ivPhoto.image = aPlaceHolder;
    }
    
}

@end
