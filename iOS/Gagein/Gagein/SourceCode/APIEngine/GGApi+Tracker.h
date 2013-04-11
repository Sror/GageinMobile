//
//  GGApi+Tracker.h
//  Gagein
//
//  Created by dong yiming on 13-4-11.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGGStrMenuTypeCompanies     @"companies"
#define kGGStrMenuTypePeople        @"people"

@interface GGApi(Tracker)

//1.Get Menu
//Parameters:type=companies or type=people
-(void)getMenuByType:(NSString *)aType callback:(GGApiBlock)aCallback;

@end
