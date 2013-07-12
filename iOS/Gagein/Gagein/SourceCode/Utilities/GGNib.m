//
//  GGNib.m
//  Gagein
//
//  Created by Dong Yiming on 7/12/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGNib.h"

@implementation GGNib
DEF_SINGLETON(GGNib)

-(GGCompanyUpdateCell *)companyUpdateCell
{
    static UINib *nib = nil;
    if (nib == nil)
    {
        nib = [UINib nibWithNibName:@"GGCompanyUpdateCell" bundle:nil];
    }
    
    return [nib instantiateWithOwner:nil options:nil].lastObject;
}

@end
