//
//  GGApi+Member.h
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGApi(Config)


#pragma mark - Agent
//3. get agent list (New API)
-(AFHTTPRequestOperation *)getAgents:(GGApiBlock)aCallback;

//4.Select/unselect agents     (New API)
-(AFHTTPRequestOperation *)selectAgents:(NSArray *)aAgentIDs callback:(GGApiBlock)aCallback;

//5. add custom agent (New API)
-(AFHTTPRequestOperation *)addCustomAgentWithName:(NSString *)aName
                     keywords:(NSString *)aKeyword
                     callback:(GGApiBlock)aCallback;

//6.update custom agent (New API)
-(AFHTTPRequestOperation *)updateCustomAgentWithID:(long long)aAgentID
                          name:(NSString *)aName
                      keywords:(NSString *)aKeyword
                      callback:(GGApiBlock)aCallback;

//7.delete custom agent (New API)
-(AFHTTPRequestOperation *)deleteCustomAgentWithID:(long long)aAgentID
                      callback:(GGApiBlock)aCallback;

#pragma mark - Functional Area
//8.get functional areas list     (New API)
-(AFHTTPRequestOperation *)getFunctionalAreas:(GGApiBlock)aCallback;

//9. select/unselect functional areas (New API)
-(AFHTTPRequestOperation *)selectFunctionalAreas:(NSArray *)aAreaIDs callback:(GGApiBlock)aCallback;


#pragma mark -
//  doRequest("GET", "config/filters/agent/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)getAgentFiltersList:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/agent/enable/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)setAgentFilterEnabled:(BOOL)anEnabled callback:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/agent/2/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)selectAgentFilterWithID:(long long)aFilterID selected:(BOOL)aSelected callback:(GGApiBlock)aCallback;

//  doRequest("GET", "config/filters/category/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)getCategoryFiltersList:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/category/enable/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)setCategoryFilterEnabled:(BOOL)anEnabled callback:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/category/1/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)selectCategoryFilterWithID:(long long)aFilterID selected:(BOOL)aSelected callback:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/media/enable/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)setMediaFilterEnabled:(BOOL)anEnabled callback:(GGApiBlock)aCallback;

//  doRequest("GET", "config/filters/media/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)getMediaFiltersList:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/media/131/delete","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)deleteMediaFilterWithID:(long long)aFilterID callback:(GGApiBlock)aCallback;

// add media filter with ID
-(AFHTTPRequestOperation *)addMediaFilterWithID:(long long)aMediaID callback:(GGApiBlock)aCallback;

// add media filters with IDs
-(AFHTTPRequestOperation *)addMediaFilterWithIDs:(NSArray *)aMediaIDs callback:(GGApiBlock)aCallback;

//  doRequest("GET", "config/filters/media/suggested/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(AFHTTPRequestOperation *)getMediaSuggestedList:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/media/search","access_token=b4790223c67f68b744d6ac3bb9b830e6&q=ga");
-(AFHTTPRequestOperation *)searchMediaWithKeyword:(NSString *)aKeyword callback:(GGApiBlock)aCallback;


#pragma mark - update profile API
-(AFHTTPRequestOperation *)changeProfileWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)changeProfileWithEmail:(NSString *)aEmail callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)changeProfileWithTitle:(NSString *)aTitle callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)changeProfileWithTimezone:(NSString *)aTimezone callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)changeProfileWithOrgID:(long long)anOrgID callback:(GGApiBlock)aCallback;

-(AFHTTPRequestOperation *)changeProfileWithOrgName:(NSString *)anOrgName callback:(GGApiBlock)aCallback;

@end
