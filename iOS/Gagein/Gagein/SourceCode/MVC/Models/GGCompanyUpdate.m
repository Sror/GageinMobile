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
        _mentionedCompanies = [NSMutableArray array];
    }
    return self;
}


-(void)parseWithData:(NSDictionary *)aData
{
    [super parseWithData:aData];
    
    self.date = [[aData objectForKey:@"date"] longLongValue];
    self.fromSource = [aData objectForKey:@"from_source"];
    self.content = [aData objectForKey:@"news_content"];
    self.contentInDetail = [aData objectForKey:@"content"]; // when parsing update detail
    self.headline = [aData objectForKey:@"news_headline"];
    self.url = [aData objectForKey:@"news_url"];
    self.ID = [[aData objectForKey:@"newsid"] longLongValue];
    self.saved = [[aData objectForKey:@"saved"] boolValue];
    self.type = [[aData objectForKey:@"news_type"] intValue];
    self.textview = [aData objectForKey:@"textview"];
    self.pictures = [((NSArray *)[aData objectForKey:@"pictures"]) mutableCopy];
    
    self.linkedInSignal = [aData objectForKey:@"linkedin_signal"];
    self.twitterTweets = [aData objectForKey:@"tweet_tweets"];
    
    NSArray *mentionedCompanies = [aData objectForKey:@"mentioned_companies"];
    
    for (id companyDic in mentionedCompanies)
    {
        GGCompany *company = [GGCompany model];
        [company parseWithData:companyDic];
        [_mentionedCompanies addObject:company];
    }
    
    [self.company parseWithData:aData];
    
    self.hasBeenRead = [[aData objectForKey:@"readed"] boolValue];
}

-(NSString *)doubleReturnedText
{
    return [_textview stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
}

-(NSString *)headlineMaxCharCount:(NSUInteger)aMaxCharCount
{
    return [_headline stringLimitedToLength:aMaxCharCount];
}

@end
