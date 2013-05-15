//
//  GGCompanyUpdate.m
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyUpdate.h"
#import "GGCompany.h"

@implementation GGCompanyUpdate

- (id)init
{
    self = [super init];
    if (self) {
        _company = [GGCompany model];
    }
    return self;
}


-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.date = [[aData objectForKey:@"date"] longLongValue];
    self.fromSource = [aData objectForKey:@"from_source"];
    self.content = [aData objectForKey:@"news_content"];
    self.content = [aData objectForKey:@"content"]; // when parsing update detail
    self.headline = [aData objectForKey:@"news_headline"];
    self.url = [aData objectForKey:@"news_url"];
    self.ID = [[aData objectForKey:@"newsid"] longLongValue];
    self.saved = [[aData objectForKey:@"saved"] boolValue];
    self.type = [[aData objectForKey:@"news_type"] intValue];
    self.textview = [aData objectForKey:@"textview"];
    self.pictures = [((NSArray *)[aData objectForKey:@"pictures"]) mutableCopy];
    
    [self.company parseWithData:aData];
}

-(NSString *)doubleReturnedText
{
    return [_textview stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
}

-(NSString *)headlineMaxCharCount:(NSUInteger)aMaxCharCount
{
    if (_headline.length < aMaxCharCount)
    {
        return _headline;
    }
    
    return [[_headline substringToIndex:aMaxCharCount] stringByAppendingString:@"..."];
}

@end
