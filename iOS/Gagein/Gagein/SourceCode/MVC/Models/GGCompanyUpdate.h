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

//date = 1365293580000;
//"employee_size" = "";
//"fortune_rank" = "Non-Fortune 1000";
//"from_source" = "News & Observer";
//"news_content" = "";
//"news_headline" = "Dome: Gov. McCrory appoints fundraisers to board after candidate McCrory vowed not to";
//"news_url" = "http://www.newsobserver.com/2013/04/06/2806512/dome-gov-mccrory-appoints-fundraisers.html#storylink=rss";
//newsid = 13367393;
//"org_logo_path" = "http://gageindemo.dyndns.org/profilepic/buz/20110219/07/1043485/1043485_60X60.jpg";
//"org_name" = "Apple Inc.";
//"org_website" = "www.apple.com";
//orgid = 1043485;
//ownership = "";
//"revenue_size" = "";
//saved = 0;
//type = "Private Company";

@interface GGCompanyUpdate : GGDataModel
@property (copy)    NSString *headline;
@property (copy)    NSString *content;
@property (copy)    NSString *url;
@property (copy)    NSString *note;
@property (strong)  GGCompany *company;
@property (assign)  BOOL     saved;
@property (strong)  NSMutableArray  *tags;  // each tag is a GGTag
@property (copy)    NSString *fromSource;
@property (assign)  long long date;
@end
