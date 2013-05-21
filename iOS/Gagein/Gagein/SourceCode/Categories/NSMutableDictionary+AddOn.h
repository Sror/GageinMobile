//
//  NSMutableDictionary+AddOn.h
//  Gagein
//
//  Created by Dong Yiming on 5/20/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (AddOn)
-(void)setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)aKey;
@end
