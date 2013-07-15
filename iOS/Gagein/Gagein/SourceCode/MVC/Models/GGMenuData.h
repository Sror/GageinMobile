//
//  GGMenuData.h
//  Gagein
//
//  Created by dong yiming on 13-4-12.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

typedef enum {
    kGGMenuTypeCompany = 0
    , kGGMenuTypeAgent
    , kGGMenuTypePerson
    , kGGMenuTypeFunctionalArea
}EGGMenuType;

@interface GGMenuData : GGDataModel
@property (copy)    NSString *name;
@property (copy)    NSString *timeInterval;
@property (copy)    NSString *grade;

@property (assign)  BOOL        checked;
@property (assign)  EGGMenuType   type;

-(EGGCompanyGrade)getGrade;

@end
