//
//  GGCompanyUpdate.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyUpdate.h"
#import "GGCompany.h"

@implementation GGCompanyUpdate

- (id)init
{
    self = [super init];
    if (self) {
        _company = [GGCompany model];
    }
    return self;
}

@end
