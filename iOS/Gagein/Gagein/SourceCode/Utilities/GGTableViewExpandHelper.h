//
//  GGTableViewExpandHelper.h
//  Gagein
//
//  Created by Dong Yiming on 6/19/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGTableViewExpandHelper : NSObject
@property (weak)    UITableView     *tableView;
@property (assign)  NSUInteger      expandingIndex;
@property (assign)  BOOL            isExpanding;
@property (strong)  NSMutableArray  *cellHeights;

//
-(id)initWithTableView:(UITableView *)aTableView;


//
-(void)changeExpaningAt:(NSUInteger)aIndex;
-(void)resetCellHeights;
-(void)recordCellHeight:(float)aCellHeight;
-(float)yForCellAt:(NSUInteger)aIndex;
-(float)heightForCellAt:(NSUInteger)aIndex;

//-(void)scrollToCenterFrom:(NSUInteger)anOldIndex to:(NSUInteger)aNewIndex oldIsExpanding:(BOOL)aOldIsExpanding;

@end
