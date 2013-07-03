//
//  UILabel+AddOn.h
//  Gagein
//
//  Created by Dong Yiming on 5/23/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (AddOn)
- (void)calculateSize;
-(void)calculateSizeConstaintToHeight:(float)aMaxHeight;

-(CGSize)calculatedSize;
-(CGSize)calculatedSize:(float)aMaxHeight;

-(void)sizeToFitFixWidth;

-(void)applyEffectEmboss;
@end
