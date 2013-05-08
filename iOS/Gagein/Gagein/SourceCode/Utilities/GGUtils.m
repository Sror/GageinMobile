//
//  GGUtils.m
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGUtils.h"

@implementation GGUtils

+(CGRect)setX:(float)aX rect:(CGRect)aRect
{
    aRect.origin.x = aX;
    return aRect;
}

+(CGRect)setY:(float)aY rect:(CGRect)aRect
{
    aRect.origin.y = aY;
    return aRect;
}

+(CGRect)setW:(float)aW rect:(CGRect)aRect
{
    aRect.size.width = aW;
    return aRect;
}

+(CGRect)setH:(float)aH rect:(CGRect)aRect
{
    aRect.size.height = aH;
    return aRect;
}

+(UIInterfaceOrientation)interfaceOrientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

+(UIDeviceOrientation)deviceOrientation
{
    return [[UIDevice currentDevice] orientation];
}

+(NSArray *)arrayWithArray:(NSArray *)anArray maxCount:(NSUInteger)aIndex
{
    NSMutableArray *returnedArray = nil;
    
    if (anArray.count && aIndex)
    {
        int count = 0;
        returnedArray = [NSMutableArray array];
        for (id item in anArray)
        {
            [returnedArray addObject:item];
            count++;
            if (count > aIndex - 1)
            {
                break;
            }
        }
    }
    
    return returnedArray;
}

+(UIImage *)imageFor:(UIImage *)anImage size:(CGSize)aNewSize
{
    if (anImage == nil) {
        return nil;
    }
    
	// create a new bitmap image context
	UIGraphicsBeginImageContext(aNewSize);
    
	// get context
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	// push context to make it current
	// (need to do this manually because we are not drawing in a UIView)
	UIGraphicsPushContext(context);
    
	// drawing code comes here- look at CGContext reference
	// for available operations
	//
	// this example draws the inputImage into the context
	//
	[anImage drawInRect:CGRectMake(0, 0, aNewSize.width, aNewSize.height)];
    
    
	// pop context
	//
	UIGraphicsPopContext();
    
	// get a UIImage from the image context- enjoy!!!
	//
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// clean up drawing environment
	//
	UIGraphicsEndImageContext();
    
    return outputImage;
}

#define ENV_STRING_FORMAT @"Currently using '%@' server: \n(%@)"  
+(NSString *)envString
{
    NSString *envAlertStr = nil;
    if (CURRENT_ENV == kGGServerProduction) {
        envAlertStr = [NSString stringWithFormat:ENV_STRING_FORMAT, @"Production", CURRENT_SERVER_URL];
    } else if (CURRENT_ENV == kGGServerDemo) {
        envAlertStr = [NSString stringWithFormat:ENV_STRING_FORMAT, @"Demo", CURRENT_SERVER_URL];
    } else if (CURRENT_ENV == kGGServerCN) {
        envAlertStr = [NSString stringWithFormat:ENV_STRING_FORMAT, @"CN", CURRENT_SERVER_URL];
    } else if (CURRENT_ENV == kGGServerStaging) {
        envAlertStr = [NSString stringWithFormat:ENV_STRING_FORMAT, @"Staging", CURRENT_SERVER_URL];
    }
    return envAlertStr;
}

+(UIButton *)imageButtonWithTitle:(NSString*)aTitle backgroundImage:(UIImage *)aBackGroundImage frame:(CGRect)aFrame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:aBackGroundImage forState:UIControlStateNormal];
    button.frame = aFrame;
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitleColor:GGSharedColor.white forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    
    return button;
}

+(UIButton *)darkGrayButtonWithTitle:(NSString *)aTitle frame:(CGRect)aFrame
{
    UIImage *backgroundImage = [[UIImage imageNamed:@"darkBtnBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 10, 20, 10)];
    return [self imageButtonWithTitle:aTitle backgroundImage:backgroundImage frame:aFrame];
}

+(UIBarButtonItem *)naviButtonItemWithTitle:(NSString *)aTitle target:(id)aTarget selector:(SEL)aSelector
{
    UIButton *doneBtn = [GGUtils darkGrayButtonWithTitle:aTitle frame:CGRectMake(0, 10, 80, 35)];
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    //btnView.backgroundColor = GGSharedColor.clear;
    [btnView addSubview:doneBtn];
    
    [doneBtn addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btnView];
}

@end
