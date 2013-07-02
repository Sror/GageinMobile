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
@class GGHappeningIpadCell;
@class GGHappening;
@class GGCompanyHappeningCell;

@interface GGFactory : NSObject


//// update cell
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
                                 headlineAction:(GGTagetActionPair *)aHeadlineAction
                                     needDetail:(BOOL)aNeedDetail;


/// happening cell
+(GGCompanyHappeningCell *)cellOfHappening:(id)aDequeuedCell
                                      data:(GGHappening *)aData
                                 dataIndex:(NSUInteger)aDataIndex
                                logoAction:(GGTagetActionPair *)aLogoAction
                        isCompanyHappening:(BOOL)aIsComHappening;

+(GGHappeningIpadCell *)cellOfHappeningIpad:(id)aDequeuedCell
                                       data:(GGHappening *)aData
                                  dataIndex:(NSUInteger)aDataIndex
                                expandIndex:(NSUInteger)aExpandIndex
                              isTvExpanding:(BOOL)aIsTvExpanding
                                 logoAction:(GGTagetActionPair *)aLogoAction
                         isCompanyHappening:(BOOL)aIsComHappening
                                 needDetail:(BOOL)aNeedDetail;

@end
