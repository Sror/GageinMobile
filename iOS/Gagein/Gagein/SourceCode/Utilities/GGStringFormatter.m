//
//  GGStringFormatter.m
//  Gagein
//
//  Created by Dong Yiming on 7/10/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGStringFormatter.h"

@implementation GGStringFormatter

+(NSString *)stringForEmployeesWithDate:(long long)aTimeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:aTimeStamp / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy";
    NSString *dateStr = [formatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"employees on\n%@", dateStr];
}

@end
