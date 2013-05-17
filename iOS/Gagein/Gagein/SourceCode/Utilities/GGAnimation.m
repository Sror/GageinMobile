//
//  OTSNaviAnimation.m
//  TheStoreApp
//
//  Created by yiming dong on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GGAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation GGAnimation

+(CAAnimation*)animationWithType:(NSString*)aType 
                         subType:(NSString*)aSubType 
{
    return [self animationWithType:aType subType:aSubType duration:.3f timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
}

+(CAAnimation*)animationWithType:(NSString*)aType
                         subType:(NSString*)aSubType
                        duration:(float)aDuration
{
    return [self animationWithType:aType subType:aSubType duration:aDuration timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
}

+(CAAnimation*)animationWithType:(NSString*)aType
                         subType:(NSString*)aSubType
                        duration:(float)aDuration
                  timingFunction:(CAMediaTimingFunction *)aTimingFunction
{
    CATransition *animation = [CATransition animation];
	animation.duration = aDuration;
	animation.timingFunction = aTimingFunction;
	[animation setType:aType];
	[animation setSubtype: aSubType];
	
    return animation;
}

+(CAAnimation*)animationFade
{
    return [self animationWithType:kCATransitionFade subType:kCATransitionFromLeft];
}

+(CAAnimation*)animationPushFromLeft
{
    return [self animationWithType:kCATransitionPush subType:kCATransitionFromLeft];
}

+(CAAnimation*)animationPushFromRight
{
    return [self animationWithType:kCATransitionPush subType:kCATransitionFromRight];
}

+(CAAnimation*)animationPushFromTop
{
    return [self animationWithType:kCATransitionPush subType:kCATransitionFromTop];
}

+(CAAnimation*)animationPushFromBottom
{
    return [self animationWithType:kCATransitionPush subType:kCATransitionFromBottom];
}

+(CAAnimation*)animationMoveInFromTop
{
    return [self animationWithType:kCATransitionMoveIn subType:kCATransitionFromTop];
}

+(CAAnimation*)animationMoveInFromBottom
{
    return [self animationWithType:kCATransitionMoveIn subType:kCATransitionFromBottom];
}

+(CAAnimation *)animationFlipFromTop
{
    return [self animationWithType:@"flip" subType:@"fromTop" duration:1.f];
}

+(CAAnimation *)animationFlipFromBottom
{
    return [self animationWithType:@"flip" subType:@"fromBottom" duration:1.f];
}

+(CAAnimation *)animationFlipFromLeft
{
    return [self animationWithType:@"flip" subType:@"fromLeft" duration:1.f];
}

+(CAAnimation *)animationFlipFromRight
{
    return [self animationWithType:@"flip" subType:@"fromRight" duration:1.f];
}

//+(CAAnimation *)aaa
//{
//    CATransition* transition = [CATransition animation];
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    transition.duration = 1.0f;
//    transition.type =  @"flip";
//    transition.subtype = @"fromTop";
//    [self.navigationController.view.layer removeAllAnimations];
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    
//    UIViewController *ctrl = [[UIViewController alloc] init];
//    [self.navigationController pushViewController:ctrl animated:NO];
//}

//+(CATransition*)transactionFade
//{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type =kCATransitionFade; //@"cube";
//    transition.subtype = kCATransitionFromRight;
//    return transition;
//}

//    [UIView  beginAnimations: @"Showinfo"context: nil];
//    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [self.navigationController pushViewController: vc animated:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];

@end
