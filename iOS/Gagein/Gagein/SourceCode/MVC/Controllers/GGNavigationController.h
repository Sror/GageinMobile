//
//  GGNavigationController.h
//  Gagein
//
//  Created by Dong Yiming on 6/11/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SINavigationMenuView;

@interface GGNavigationController : UINavigationController
@property (strong, nonatomic) SINavigationMenuView      *dropMenu;
@end
