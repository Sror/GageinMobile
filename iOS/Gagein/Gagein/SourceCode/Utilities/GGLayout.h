//
//  GGLayout.h
//  Gagein
//
//  Created by Dong Yiming on 6/6/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGLayout : NSObject

+(CGRect)appFrame;
+(CGRect)screenFrame;
+(CGRect)statusFrame;
+(float)statusHeight;
+(CGRect)tabbarFrame;
+(CGRect)navibarFrame;

+(UIInterfaceOrientation)currentOrient;


+(CGRect)frameWithOrientation:(UIInterfaceOrientation)anOrientation rect:(CGRect)aRect;
+(CGRect)contentRectWithOrient:(UIInterfaceOrientation)anOrient;
@end
