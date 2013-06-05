//
//  GGSnShareVC.h
//  Gagein
//
//  Created by Dong Yiming on 5/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGCompanyUpdate;
@class GGHappening;

typedef enum
{
    kGGSnShareTypeUpdate = 0
    , kGGSnShareTypeHappeningCompany
    , kGGSnShareTypeHappeningPerson
}EGGSnShareType;

@interface GGSnShareVC : GGBaseViewController
@property (strong)  GGCompanyUpdate *comUpdateDetail;
@property (strong)  GGHappening *happening;

@property (assign) EGGSnShareType   shareType;
@property (assign)  EGGSnType       snType;
@property (strong)  NSMutableArray  *snTypesRef;    // for modification when sn sharing failed
@end
