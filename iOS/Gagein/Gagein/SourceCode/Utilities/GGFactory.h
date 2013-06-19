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
@class GGCompanyUpdateIpadCell;

@interface GGFactory : NSObject

+(GGCompanyUpdateCell *)cellOfComUpdate:(id)aDequeuedCell
                                   data:(GGCompanyUpdate *)aData
                              dataIndex:(NSUInteger)aDataIndex
                             logoAction:(GGTagetActionPair *)anAction;

+(GGCompanyUpdateIpadCell *)cellOfComUpdateIpad:(id)aDequeuedCell
                                           data:(GGCompanyUpdate *)aData
                                      dataIndex:(NSUInteger)aDataIndex
                                    expandIndex:(NSUInteger)aExpandIndex
                                  isTvExpanding:(BOOL)aIsTvExpanding
                                     logoAction:(GGTagetActionPair *)aLogoAction
                                 headlineAction:(GGTagetActionPair *)aHeadlineAction;

@end