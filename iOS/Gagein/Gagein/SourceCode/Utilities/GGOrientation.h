//
//  GGOrientation.h
//  Gagein
//
//  Created by Dong Yiming on 7/4/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGOrientation : NSObject

+(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

+ (BOOL)shouldAutorotate;

+(NSUInteger)supportedInterfaceOrientations;

@end
