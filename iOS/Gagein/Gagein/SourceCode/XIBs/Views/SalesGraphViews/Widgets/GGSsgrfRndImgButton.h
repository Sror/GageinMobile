//
//  GGSsgrfRndImgButton.h
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSsgrfRndImgButton : UIView
@property (strong, nonatomic) UIImageView                 *imageView;

-(void)setImageUrl:(NSString *)aImageURL placeholder:(UIImage *)aPlaceHolder;

-(void)addTarget:(id)target action:(SEL)action;
-(void)clearActions;

@end
