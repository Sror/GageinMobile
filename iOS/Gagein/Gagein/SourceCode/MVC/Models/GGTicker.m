//
//  GGTickerSymbol.m
//  Gagein
//
//  Created by dong yiming on 13-4-21.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGTicker.h"

@implementation GGTicker

-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.name = [aData objectForKey:@"ticker_name"];
    self.url = [aData objectForKey:@"ticker_url"];
}

@end
