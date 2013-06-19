//
//  GGFactory.h
//  Gagein
//
//  Created by Dong Yiming on 6/19/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGCompanyUpdateCell;
@class GGCompanyUpdate;
@class GGTagetActionPair;

@interface GGFactory : NSObject

+(GGCompanyUpdateCell *)cellOfComUpdate:(id)aDequeuedCell
                                   data:(GGCompanyUpdate *)aData
                              dataIndex:(NSUInteger)aDataIndex
                             logoAction:(GGTagetActionPair *)anAction;

@end
