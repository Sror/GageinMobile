//
//  GGUtils.m
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGUtils.h"
#import "GGGroupedCell.h"
#import "JSONKit.h"
#import "GGTimeZone.h"

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

#define ENV_STRING_FORMAT @"'%@':(%@)"  
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
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    
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

+(void)sendSmsTo:(NSArray *)aRecipients
            body:(NSString *)aBody
      vcDelegate:(UIViewController<MFMessageComposeViewControllerDelegate> *)aVcDelegate
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = aBody;
        controller.recipients = aRecipients;
        controller.messageComposeDelegate = aVcDelegate;
        //[aVcDelegate presentModalViewController:controller animated:YES];
        [aVcDelegate presentViewController:controller animated:YES completion:nil];
    }
}

+(id)replaceFromNibForView:(UIView *)aView
{
    if (aView)
    {
        UIView *superview = [aView superview];
        CGRect frame = aView.frame;
        Class cls = [aView class];
        
        [aView removeFromSuperview];
        aView = [cls viewFromNibWithOwner:self];
        aView.frame = frame;
        [superview addSubview:aView];
        
        return aView;
    }
    
    return nil;
}

+(id)replaceView:(UIView *)aView inPlaceWithNewView:(UIView *)aNewView
{
    if (aView && aNewView)
    {
        UIView *superview = [aView superview];
        CGRect frame = aView.frame;
        
        aNewView.frame = frame;
        [superview addSubview:aNewView];
        
        return aNewView;
    }
    
    return nil;
}

+(void)applyTableStyle1ToView:(UIView *)aView
{
    CALayer *layer = aView.layer;
    if (layer)
    {
        layer.cornerRadius = 8;
        layer.shadowColor = GGSharedColor.darkGray.CGColor;
        layer.shadowOffset = CGSizeMake(2, 2);
        layer.shadowRadius = 4;
        layer.shadowOpacity = .1f;
        layer.masksToBounds = NO;
    }
}

+(void)applyLogoStyleToView:(UIView *)aView
{
    CALayer *layer = aView.layer;
    if (layer)
    {
        layer.borderColor = GGSharedColor.lightGray.CGColor;
        layer.borderWidth = 1;
        
        layer.shadowColor = GGSharedColor.lightGray.CGColor;
        layer.shadowOpacity = .5f;
        layer.shadowOffset = CGSizeMake(-1, 1);
        layer.shadowRadius = 1;
    }
}


+(EGGGroupedCellStyle)styleForArrayCount:(NSUInteger)aArrayCount atIndex:(NSUInteger)anIndex
{
    NSAssert(aArrayCount, @"suggested media filters count should be greater than 0");
    
    EGGGroupedCellStyle style = kGGGroupCellFirst;
    
    if (aArrayCount == 1)
    {
        style = kGGGroupCellRound;
    }
    else if (anIndex == aArrayCount - 1)
    {
        style = kGGGroupCellLast;
    }
    else if (anIndex > 0)
    {
        style = kGGGroupCellMiddle;
    }
    
    return style;
}

+(NSData *)dataFromBundleForFileName:(NSString *)aFileName type:(NSString *)aType
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:aFileName ofType:aType];
    return [NSData dataWithContentsOfFile:filePath];
}

+(NSArray *)timezones
{
    NSData *data = [self dataFromBundleForFileName:@"timezones" type:@"json"];
    NSArray *rawTimezones = [[data objectFromJSONData] objectForKey:@"timezones"];
    NSMutableArray *timezones = [NSMutableArray arrayWithCapacity:rawTimezones.count];
    for (id timezoneDic in rawTimezones)
    {
        GGTimeZone *timezone = [GGTimeZone model];
        [timezone parseWithData:timezoneDic];
        [timezones addObject:timezone];
    }
    
    return timezones;
}

+(NSString*)stringByTrimmingLeadingWhitespaceOfString:(NSString *)aStr
{
    NSInteger i = 0;
    
    while ((i < [aStr length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[aStr characterAtIndex:i]])
    {
        i++;
    }
    
    return [aStr substringFromIndex:i];
}

+(NSString *)stringForSnType:(EGGSnType)aSnType
{
    switch (aSnType)
    {
        case kGGSnTypeFacebook:
        {
            return @"Facebook";
        }
            break;
            
        case kGGSnTypeLinkedIn:
        {
            return @"LinkedIn";
        }
            break;
            
        case kGGSnTypeTwitter:
        {
            return @"Twitter";
        }
            break;
            
        case kGGSnTypeSalesforce:
        {
            return @"Salesforce";
        }
            break;
            
        case kGGSnTypeYammer:
        {
            return @"Yammer";
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

+(NSString *)stringWithMapUrl:(NSString *)aMapUrl width:(int)aWidth height:(int)aHeight
{
    if (aMapUrl)
    {
        NSString *finalUrlStr = [[aMapUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSRange range = [finalUrlStr rangeOfString:@"&size="];
        NSString *frontPart = [finalUrlStr substringToIndex:range.location];
        NSString *endPart = [finalUrlStr substringFromIndex:range.location + 1];
        range = [endPart rangeOfString:@"&"];
        endPart = [endPart substringFromIndex:range.location];
        
        return [NSString stringWithFormat:@"%@&size=%dx%d%@", frontPart, aWidth, aHeight, endPart];
    }
    
    return nil;
}

@end
