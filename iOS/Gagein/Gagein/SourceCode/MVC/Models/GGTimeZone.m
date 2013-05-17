//
//  GGTimeZone.m
//  Gagein
//
//  Created by Dong Yiming on 5/16/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGTimeZone.h"

@implementation GGTimeZone
-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    _idStr = [aData objectForKey:@"id"];
    _gmt = [aData objectForKey:@"gmtnum"];
    _name = [aData objectForKey:@"name"];
    //_name = [GGUtils stringByTrimmingLeadingWhitespaceOfString:_name];
}
@end
