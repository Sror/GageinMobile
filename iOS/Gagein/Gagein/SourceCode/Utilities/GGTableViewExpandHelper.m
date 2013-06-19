//
//  GGTableViewExpandHelper.m
//  Gagein
//
//  Created by Dong Yiming on 6/19/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGTableViewExpandHelper.h"

@implementation GGTableViewExpandHelper

- (id)init
{
    self = [super init];
    if (self) {
        _cellHeights = [NSMutableArray array];
    }
    return self;
}

-(id)initWithTableView:(UITableView *)aTableView
{
    self = [self init];
    if (self) {
        _tableView = aTableView;
    }
    return self;
}

-(void)changeExpaningAt:(NSUInteger)aIndex
{
    // snapshot old value...
    NSUInteger oldIndex = _expandingIndex;
    //BOOL oldIsExpanding = _isExpanding;
    
    if (_isExpanding)
    {
        if (aIndex == oldIndex)
        {
            _isExpanding = NO;
        }
        else
        {
            _expandingIndex = aIndex;
        }
    }
    else
    {
        _isExpanding = YES;
        _expandingIndex = aIndex;
    }
}

-(void)resetCellHeights
{
    [_cellHeights removeAllObjects];
}

-(void)recordCellHeight:(float)aCellHeight
{
    id heightObj = @(aCellHeight);
    [_cellHeights addObject:heightObj];
}

-(float)yForCellAt:(NSUInteger)aIndex
{
    float yPos = 0.f;
    aIndex = MIN(aIndex, _cellHeights.count - 1);
    for (int i = 0; i < aIndex; i++)
    {
        yPos += [self heightForCellAt:aIndex];
    }
    
    return yPos;
}

-(float)heightForCellAt:(NSUInteger)aIndex
{
    if (aIndex < _cellHeights.count)
    {
        float height = [(_cellHeights[aIndex]) floatValue];
        return height;
    }
    
    return 0.f;
}

-(void)scrollToCenterFrom:(NSUInteger)anOldIndex to:(NSUInteger)aNewIndex oldIsExpanding:(BOOL)aOldIsExpanding
{
    // adjust tableview content offset
    if (_isExpanding)
    {
        float yPos = [self yForCellAt:aNewIndex];
        float oldExpandCellHeight = [self heightForCellAt:anOldIndex];
//        if (aOldIsExpanding && anOldIndex < aNewIndex)
//        {
//            yPos -= oldExpandCellHeight - 20;
//        }
        
        float offsetAdjust = (_tableView.frame.size.height - oldExpandCellHeight) / 4;
        yPos = UIInterfaceOrientationIsPortrait([GGLayout currentOrient]) ? yPos - offsetAdjust : yPos;
        yPos = MAX(0, yPos);
        
        [_tableView setContentOffset:CGPointMake(0, yPos) animated:YES];
    }
}

@end
