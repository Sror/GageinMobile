//
//  NSMutableArray+AddOn.h
//  Gagein
//
//  Created by Dong Yiming on 5/22/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AddOn)
-(id)objectAtIndexSafe:(NSUInteger)index;
@end

@interface NSMutableArray (AddOn)

-(void)addObjectIfNotNil:(id)anObject;
@end
