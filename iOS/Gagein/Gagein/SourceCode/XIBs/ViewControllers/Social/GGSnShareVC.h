//
//  GGSnShareVC.h
//  Gagein
//
//  Created by Dong Yiming on 5/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGCompanyUpdate;

@interface GGSnShareVC : GGBaseViewController
@property (strong)  GGCompanyUpdate *comUpdateDetail;
@property (assign)  EGGSnType       snType;
@property (strong)  NSMutableArray  *snTypesRef;    // for modification when sn sharing failed
@end
