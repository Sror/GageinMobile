//
//  GGApi+People.h
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGApi (People)
-(void)searchPeopleWithKeyword:(NSString *)aKeyword
                          page:(int)aPage
                      callback:(GGApiBlock)aCallback;
@end
