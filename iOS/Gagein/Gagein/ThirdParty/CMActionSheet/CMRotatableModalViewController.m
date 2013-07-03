//
//  CMRotatableModalViewController
//
//  Created by Constantine Mureev on 09.08.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMRotatableModalViewController.h"

@implementation CMRotatableModalViewController

@synthesize rootViewController;

- (void)dealloc {
    self.rootViewController = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == self.rootViewController.interfaceOrientation && ISIPADDEVICE) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)shouldAutorotate {
    
    if (ISIPADDEVICE)
    {
        return YES;
    }
    
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    if (ISIPADDEVICE)
    {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait; // etc
}

@end
