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
@property (copy)    NSString *contentInDetail;
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
@property (assign)  BOOL        hasBeenRead;    // if the user have read this update

@property (assign)  BOOL        liked;          // if the user liked this update
@property (assign)  long long   newsSimilarID;
@property (assign)  int         newsSimilarCount;

@property (copy)    NSString    *linkedInSignal;
@property (copy)    NSString    *twitterTweets;
@property (strong)  NSMutableArray  *mentionedCompanies;
@property (strong)  NSMutableArray   *agents;

@property (copy)    NSString        *newsPicURL;

-(NSString *)doubleReturnedText;
-(NSString *)headlineTruncated;
@end
