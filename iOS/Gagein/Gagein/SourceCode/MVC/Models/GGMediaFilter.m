//
//  GGMediaFilter.m
//  Gagein
//
//  Created by dong yiming on 13-5-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGMediaFilter.h"


@implementation GGMediaFilter

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.ID = [[aData objectForKey:@"media_id"] longLongValue];
    self.name = [aData objectForKey:@"media_name"];
}

@end
