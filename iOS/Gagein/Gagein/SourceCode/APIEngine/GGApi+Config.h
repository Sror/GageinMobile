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
-(void)getAgents:(GGApiBlock)aCallback;

//4.Select/unselect agents     (New API)
-(void)selectAgents:(NSArray *)aAgentIDs callback:(GGApiBlock)aCallback;

//5. add custom agent (New API)
-(void)addCustomAgentWithName:(NSString *)aName
                     keywords:(NSString *)aKeyword
                     callback:(GGApiBlock)aCallback;

//6.update custom agent (New API)
-(void)updateCustomAgentWithID:(long long)aAgentID
                          name:(NSString *)aName
                      keywords:(NSString *)aKeyword
                      callback:(GGApiBlock)aCallback;

//7.delete custom agent (New API)
-(void)deleteCustomAgentWithID:(long long)aAgentID
                      callback:(GGApiBlock)aCallback;

#pragma mark - Functional Area
//8.get functional areas list     (New API)
-(void)getFunctionalAreas:(GGApiBlock)aCallback;

//9. select/unselect functional areas (New API)
-(void)selectFunctionalAreas:(NSArray *)aAreaIDs callback:(GGApiBlock)aCallback;


#pragma mark -
//  doRequest("GET", "config/filters/agent/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)getAgentFiltersList:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/agent/enable/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)setAgentFilterEnabled:(BOOL)anEnabled callback:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/agent/2/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)selectAgentFilterWithID:(long long)aFilterID selected:(BOOL)aSelected callback:(GGApiBlock)aCallback;

//  doRequest("GET", "config/filters/category/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)getCategoryFiltersList:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/category/enable/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)setCategoryFilterEnabled:(BOOL)anEnabled callback:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/category/1/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)selectCategoryFilterWithID:(long long)aFilterID selected:(BOOL)aSelected callback:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/media/enable/true","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)setMediaFilterEnabled:(BOOL)anEnabled callback:(GGApiBlock)aCallback;

//  doRequest("GET", "config/filters/media/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)getMediaFiltersList:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/media/131/delete","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)deleteMediaFilterWithID:(long long)aFilterID callback:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/media/add","access_token=b4790223c67f68b744d6ac3bb9b830e6&media_name=Washington Blade");
-(void)addMediaFilterWithName:(NSString *)aMediaName callback:(GGApiBlock)aCallback;

//  doRequest("GET", "config/filters/media/suggested/list","access_token=b4790223c67f68b744d6ac3bb9b830e6");
-(void)getMediaSuggestedList:(GGApiBlock)aCallback;

//  doRequest("POST", "config/filters/media/search","access_token=b4790223c67f68b744d6ac3bb9b830e6&q=ga");
-(void)searchMediaWithKeyword:(NSString *)aKeyword callback:(GGApiBlock)aCallback;


@end
