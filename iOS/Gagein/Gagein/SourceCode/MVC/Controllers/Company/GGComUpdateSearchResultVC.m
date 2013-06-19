//
//  GGComUpdateSearchResultVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComUpdateSearchResultVC.h"

#import "GGDataPage.h"
#import "GGCompanyUpdate.h"
#import "GGCompanyUpdateCell.h"
#import "SVPullToRefresh.h"
#import "GGCompany.h"
#import "GGCompanyDetailVC.h"
#import "GGCompanyUpdateDetailVC.h"
#import "GGCompanyUpdateIpadCell.h"

#import "GGTableViewExpandHelper.h"

@interface GGComUpdateSearchResultVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@end

@implementation GGComUpdateSearchResultVC
{
    EGGCompanyUpdateRelevance   _relevance;
    
    NSUInteger          _currentPageIndex;
    BOOL                _hasMore;
    
    GGTableViewExpandHelper             *_tvExpandHelper;
}

-(void)_prevViewLoaded
{
    _currentPageIndex = GG_PAGE_START_INDEX;
    _relevance = kGGCompanyUpdateRelevanceNormal;
    _updates = [NSMutableArray array];
    
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
}

- (void)viewDidLoad
{
    [self _prevViewLoaded];
    
    [super viewDidLoad];
    
    self.naviTitle = _keyword;
    
    self.updatesTV = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    //self.updatesTV.rowHeight = [GGCompanyUpdateCell HEIGHT];
    self.updatesTV.dataSource = self;
    self.updatesTV.delegate = self;
    _updatesTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _updatesTV.showsVerticalScrollIndicator = NO;
    _updatesTV.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    _tvExpandHelper = [[GGTableViewExpandHelper alloc] initWithTableView:_updatesTV];
    
    [self.view addSubview:self.updatesTV];
    self.updatesTV.backgroundColor = GGSharedColor.silver;
    
    __weak GGComUpdateSearchResultVC *weakSelf = self;
    
    [self.updatesTV addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [self.updatesTV addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    [self.updatesTV triggerPullToRefresh];
    
    [GGSharedRuntimeData saveKeyword:_keyword];
    [self addScrollToHide:_updatesTV];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_updatesTV reloadData];
}

#pragma mark - notification handling
-(void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    if ([notification.name isEqualToString:GG_NOTIFY_LOG_OUT])
    {
        [_updates removeAllObjects];
        [self.updatesTV reloadData];
    }
    else if ([notification.name isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self.updatesTV triggerPullToRefresh];
    }
}

#pragma mark - actions
-(void)companyDetailAction:(id)sender
{
    //GGCompanyUpdateCell *cell = (GGCompanyUpdateCell *)((UIButton*)sender).superview.superview;
    int index = ((UIButton*)sender).tag;
    GGCompanyUpdate *update = [_updates objectAtIndex:index];
    
    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
    vc.companyID = update.company.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.updates.count;
}

-(float)_updateCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return [self _updateCellForIndexPath:indexPath].frame.size.height;
}

-(GGCompanyUpdateCell *)_updateCellForIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    static NSString *updateCellId = @"GGCompanyUpdateCell";
    GGCompanyUpdateCell *cell = [_updatesTV dequeueReusableCellWithIdentifier:updateCellId];
    
    GGTagetActionPair *action = [GGTagetActionPair pairWithTaget:self action:@selector(companyDetailAction:)];
    cell = [GGFactory cellOfComUpdate:cell
                                 data:_updates[row]
                            dataIndex:row
                           logoAction:action];
    
    return cell;
}

-(float)_updateIpadCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return [self _updateIpadCellForIndexPath:indexPath].frame.size.height;
}

-(GGCompanyUpdateIpadCell *)_updateIpadCellForIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    //static NSString *updateCellId = @"GGCompanyUpdateIpadCell";
    GGCompanyUpdateIpadCell *cell = nil;//[_updatesTV dequeueReusableCellWithIdentifier:updateCellId];
    
    GGTagetActionPair *logoAction = [GGTagetActionPair pairWithTaget:self action:@selector(companyDetailAction:)];
    GGTagetActionPair *headlineAction = [GGTagetActionPair pairWithTaget:self action:@selector(_enterUpdateDetailAction:)];
    
    cell = [GGFactory cellOfComUpdateIpad:cell
                                     data:_updates[row]
                                dataIndex:row
                              expandIndex:_tvExpandHelper.expandingIndex
                            isTvExpanding:_tvExpandHelper.isExpanding
                               logoAction:logoAction
                           headlineAction:headlineAction];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPADDEVICE)
    {
        return [self _updateIpadCellForIndexPath:indexPath];
    }
    else
    {
        return [self _updateCellForIndexPath:indexPath];
    }
    
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [_tvExpandHelper resetCellHeights];
    }
    
    float height = ISIPADDEVICE ? [self _updateIpadCellHeightForIndexPath:indexPath] : [self _updateCellHeightForIndexPath:indexPath];
    [_tvExpandHelper recordCellHeight:height];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (ISIPADDEVICE)
    {
        // snapshot old value...
        NSUInteger oldIndex = _tvExpandHelper.expandingIndex;
        BOOL oldIsExpanding = _tvExpandHelper.isExpanding;
        [_tvExpandHelper changeExpaningAt:row];
        
        // reload cells
        [tableView beginUpdates];
        if (indexPath.row == oldIndex)
        {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndex inSection:indexPath.section];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, oldIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        // adjust tableview content offset
        [_tvExpandHelper scrollToCenterFrom:oldIndex to:row oldIsExpanding:oldIsExpanding];
        
        [tableView endUpdates];
    }
    else
    {
        [self _enterUpdateDetailAt:indexPath.row];
    }
}

-(void)_enterUpdateDetailAction:(id)sender
{
    [self _enterUpdateDetailAt:(((UIView *)sender).tag)];
}

-(void)_enterUpdateDetailAt:(NSUInteger)aIndex
{
    GGCompanyUpdateDetailVC *vc = [[GGCompanyUpdateDetailVC alloc] init];
    
    vc.naviTitleString = self.customNaviTitle.text;
    vc.updates = self.updates;
    vc.updateIndex = aIndex;
    GGCompanyUpdate *data = _updates[aIndex];
    data.hasBeenRead = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
-(void)_getFirstPage
{
    _hasMore = YES;
    _currentPageIndex = GG_PAGE_START_INDEX;
    [self _getData];
}

-(void)_getNextPage
{
    if (_hasMore)
    {
        _currentPageIndex++;
        [self _getData];
    }
}

-(void)_getData
{
    if (!_hasMore) { return;}
    
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        //DLog(@"%@", aResultObject);
        
        //[self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetCompanyUpdates];
            
            if (page.items.count)
            {
                [_updates addObjectsFromArray:page.items];
            }
        }
        else
        {
            [GGAlert alertErrorForParser:parser];
        }
        
        [self.updatesTV reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    };
    
    id op = [GGSharedAPI searchForCompanyUpdatesWithKeyword:_keyword pageIndex:_currentPageIndex callback:callback];
    [self registerOperation:op];
}

-(void)_delayedStopAnimating
{
    __weak GGComUpdateSearchResultVC *weakSelf = self;
    [weakSelf.updatesTV.pullToRefreshView stopAnimating];
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
}

-(void)_delayedStopInfiniteAnimating
{
    __weak GGComUpdateSearchResultVC *weakSelf = self;
    
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
}


#pragma mark -
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_updatesTV centerMeHorizontallyChangeMyWidth:_updatesTV.superview.frame.size.width];
}

@end
