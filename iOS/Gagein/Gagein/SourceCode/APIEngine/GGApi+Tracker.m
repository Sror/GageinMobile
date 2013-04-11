//
//  GGApi+Tracker.m
//  Gagein
//
//  Created by dong yiming on 13-4-11.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGApi+Tracker.h"

@implementation GGApi(Tracker)


//1.Get Menu
//GET:/member/me/tracker/menu
//Parameters:type=companies or type=people
//
-(void)getMenuByType:(NSString *)aType callback:(GGApiBlock)aCallback
{
    //GET
    NSString *path = @"member/me/tracker/menu";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:APP_CODE_VALUE forKey:APP_CODE_KEY];
    [parameters setObject:GGSharedRuntimeData.accessToken forKey:ACCESS_TOKEN_KEY];
    [parameters setObject:aType forKey:@"type"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//2.tracker event
//GET: /member/me/event/tracker
//Parameters:
//Get company events:orgid=xxx&pageflag=0&pagetime=0&eventid=0
//Get people events:  contactid=xxx&pageflag=0&pagetime=0&eventid=0
//Get funcational area events: functional_areaid=xxx&pageflag=0&pagetime=0&eventid=0
//xxx is the id value, if the value is -10,return the all result.

//4.Get a company event detail
//GET:company/event/{eventid}/detail
//
//5.get a people event detail
//GET:contact/event/{eventid}/detail

@end
