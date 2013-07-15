//
//  GGMenuData.m
//  Gagein
//
//  Created by dong yiming on 13-4-12.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGMenuData.h"

@implementation GGMenuData

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"menuid"] longLongValue];
    self.name = [aData objectForKey:@"menu_name"];
    self.timeInterval = [aData objectForKey:@"time_interval"];
    _grade = [aData objectForKey:@"grade"];
}

-(EGGCompanyGrade)getGrade
{
    if (_type == kGGMenuTypeCompany || _type == kGGMenuTypePerson)
    {
        if ([self.grade.lowercaseString isEqualToString:@"a"])
        {
            return kGGComGradeA;
        }
        else if ([self.grade.lowercaseString isEqualToString:@"b"])
        {
            return kGGComGradeB;
        }
        
        return kGGComGradeC;
    }
    
    return kGGComGradeA;
}

@end
