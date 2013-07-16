//
//  GGLayout.h
//  Gagein
//
//  Created by Dong Yiming on 6/6/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, EMSLayoutElement) {
    kLayoutElementNone          = 0,
    kLayoutElementStatusBar     = 1 << 0,
    kLayoutElementNaviBar       = 1 << 1,
    kLayoutElementTabBar        = 1 << 2,
    kLayoutElementAll           = kLayoutElementStatusBar | kLayoutElementNaviBar | kLayoutElementTabBar
};

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

+(CGRect)pageRectWithLayoutElement:(EMSLayoutElement)aLayoutElement;

@end
