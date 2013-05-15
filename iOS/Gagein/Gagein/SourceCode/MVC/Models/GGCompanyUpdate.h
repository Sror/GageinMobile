//
//  GGCompanyUpdate.h
//  Gagein
//
//  Created by dong yiming on 13-4-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGDataModel.h"

@class GGCompany;



@interface GGCompanyUpdate : GGDataModel
@property (copy)    NSString *headline;
@property (copy)    NSString *content;
@property (copy)    NSString *textview;
@property (copy)    NSString *url;
@property (copy)    NSString *note;
@property (strong)  GGCompany *company;
@property (assign)  BOOL     saved;
@property (strong)  NSMutableArray  *tags;  // each tag is a GGTag
@property (copy)    NSString *fromSource;
@property (assign)  long long date;
@property (assign)  int         type;
@property (strong)  NSMutableArray  *pictures;  // when parsing update detail
@property (assign)  BOOL        hasBeenRead;

-(NSString *)doubleReturnedText;
-(NSString *)headlineMaxCharCount:(NSUInteger)aMaxCharCount;
@end
