//
//  GGTagetActionPair.h
//  Gagein
//
//  Created by Dong Yiming on 6/19/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGTagetActionPair : NSObject
@property (weak) id     target;
@property (assign) SEL  action;

+(GGTagetActionPair *)pairWithTaget:(id)aTarget action:(SEL)anAction;

@end
