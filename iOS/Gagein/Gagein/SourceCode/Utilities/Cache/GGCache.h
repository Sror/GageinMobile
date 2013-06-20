//
//  GGCache.h
//  Gagein
//
//  Created by Dong Yiming on 6/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>


///
@interface GGCache : NSObject
{
 @protected
    NSMutableArray      *_cache;
}

-(void)add:(id)anObect;
-(void)remove:(id)anObject;
-(void)setMaxCapacity:(NSUInteger)aCapacity;

-(BOOL)object:(id)anObject isTheSameWith:(id)anotherObject;

@end



////
@interface GGClassCacheBase : GGCache
{
 @protected
    Class   _class;
}
-(id)initWithClass:(Class)aClass;
@end

