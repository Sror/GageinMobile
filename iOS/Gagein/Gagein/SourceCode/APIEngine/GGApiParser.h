//
//  GGApiParser.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGMember;

@interface GGApiParser : NSObject
@property (strong)  NSDictionary    *apiData;

#pragma mark - init
+(id)parserWithApiData:(NSDictionary *)anApiData;
-(id)initWithApiData:(NSDictionary *)anApiData;

#pragma mark - basic data
-(int)status;
-(NSString *)message;
-(id)data;

#pragma mark - signup
-(GGMember*)parseLogin;
@end
