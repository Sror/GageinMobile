//
//  GGHappeningsVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGHappeningsVC.h"

#import "GGDataPage.h"
#import "SVPullToRefresh.h"
#import "GGCompany.h"
#import "GGCompanyDetailVC.h"

#import "GGCompanyHappeningCell.h"
#import "GGHappening.h"
#import "GGHappeningDetailVC.h"

#import "GGTableViewExpandHelper.h"
#import "GGHappeningIpadCell.h"
#import "ODRefreshControl.h"

@interface GGHappeningsVC ()
@property (nonatomic, strong) UITableView *tvHappenings;
@end

@implementation GGHappeningsVC
{
    BOOL                                _hasMore;
    GGTableViewExpandHelper             *_happeningTvExpandHelper;
    ODRefreshControl                    *_refreshControl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _happeningTvExpandHelper = [[GGTableViewExpandHelper alloc] init];
    }
    return self;
}

-(void)_prevViewLoaded
{
    _happenings = [NSMutableArray array];
    
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
}

- (void)viewDidLoad
{
    [self _prevViewLoaded];
    
    [super viewDidLoad];
    
    self.naviTitle = @"Happenings";
    
    self.tvHappenings = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    //self.tvHappenings.rowHeight = [GGCompanyHappeningCell HEIGHT];
    self.tvHappenings.dataSource = self;
    self.tvHappenings.delegate = self;
    [self.view addSubview:self.tvHappenings];
    self.tvHappenings.backgroundColor = GGSharedColor.silver;
    _happeningTvExpandHelper.tableView = _tvHappenings;
    self.view.backgroundColor = GGSharedColor.silver;
    
    _tvHappenings.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    ////

    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_tvHappenings];
    [_refreshControl addTarget:self action:@selector(_getFirstPage) forControlEvents:UIControlEventValueChanged];
    
    [self _getFirstPage];
    
    
    __weak GGHappeningsVC *weakSelf = self;
    
//    [self.tvHappenings addPullToRefreshWithActionHandler:^{
//        [weakSelf _getFirstPage];
//    }];
    
    [self.tvHappenings addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    //[self.tvHappenings triggerPullToRefresh];
    [self addScrollToHide:_tvHappenings];
}

-(void)_getFirstPageAndShowRefresh
{
    [self _getFirstPage];
    [_refreshControl beginRefreshing];
}

-(void)dealloc
{
    [self unobserveAllNotifications];
}



#pragma mark - notification handling
-(void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    if ([notification.name isEqualToString:GG_NOTIFY_LOG_OUT])
    {
        [_happenings removeAllObjects];
        [self.tvHappenings reloadData];
    }
    else if ([notification.name isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self _getFirstPageAndShowRefresh];
        //[self.tvHappenings triggerPullToRefresh];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.happenings.count;
}

-(float)_happeningIpadCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return [self _happeningCellForIPadWithIndexPath:indexPath needDetail:NO].frame.size.height;
}

-(GGHappeningIpadCell *)_happeningCellForIPadWithIndexPath:(NSIndexPath *)aIndexPath needDetail:(BOOL)aNeedDetail
{
    int row = aIndexPath.row;
    
    //static NSString *updateCellId = @"GGHappeningIpadCell";
    GGHappeningIpadCell *cell = nil;//[_happeningsTV dequeueReusableCellWithIdentifier:updateCellId];;
    
    //
    GGTagetActionPair *action = [GGTagetActionPair pairWithTaget:self action:@selector(companyDetailAction:)];
    cell = [GGFactory cellOfHappeningIpad:cell
                                     data:_happenings[row]
                                dataIndex:row
                              expandIndex:_happeningTvExpandHelper.expandingIndex
                            isTvExpanding:_happeningTvExpandHelper.isExpanding
                               logoAction:action
                       isCompanyHappening:YES needDetail:aNeedDetail];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (ISIPADDEVICE)
    {
        return [self _happeningCellForIPadWithIndexPath:indexPath needDetail:YES];
    }
    
    static NSString *updateCellId = @"GGCompanyHappeningCell";
    GGCompanyHappeningCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
    
    GGTagetActionPair *action = [GGTagetActionPair pairWithTaget:self action:@selector(companyDetailAction:)];
    cell = [GGFactory cellOfHappening:cell data:_happenings[row] dataIndex:row logoAction:action isCompanyHappening:YES];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPADDEVICE)
    {
        return [self _happeningIpadCellHeightForIndexPath:indexPath];
    }
    else
    {
        GGHappening *data = _happenings[indexPath.row];
        return [GGCompanyHappeningCell heightWithHappening:data];
    }
    
    return 0.f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPADDEVICE)
    {
        if (_happeningTvExpandHelper.isExpanding && indexPath.row == _happeningTvExpandHelper.expandingIndex)
        {
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = indexPath.row;
    
    if (ISIPADDEVICE)
    {
        //NSUInteger oldIndex = _happeningTvExpandHelper.expandingIndex;
        
        
        [_happeningTvExpandHelper changeExpaningAt:row];
        
        [tableView reloadData];
        
//        [tableView beginUpdates];
//        
//        if (indexPath.row == oldIndex)
//        {
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//        else
//        {
//            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndex inSection:indexPath.section];
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, oldIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//        
//        [tableView endUpdates];
    }
    else
    {
        [self _enterHappeningDetailAt:row];
    }
}


#pragma mark - actions
-(void)companyDetailAction:(id)sender
{
    int index = ((UIButton*)sender).tag;
    GGHappening *data = _happenings[index];
    
    if (data.company.orgID > 0)
    {
        [self enterCompanyDetailWithID:data.company.ID];
        
//        GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
//        vc.companyID = data.company.orgID;
//        
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)_enterHappeningDetailAction:(id)sender
{
    [self _enterHappeningDetailAt:(((UIView *)sender).tag)];
}

-(void)_enterHappeningDetailAt:(NSUInteger)aIndex
{
    GGHappeningDetailVC *vc = [[GGHappeningDetailVC alloc] init];
    //vc.isPeopleHappening = YES;
    vc.happenings = _happenings;
    vc.happeningIndex = aIndex;
    
    GGHappening *data = _happenings[aIndex];
    data.hasBeenRead = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
-(void)_getFirstPage
{
    [self _getDataWithEventID:0 pageFlag:kGGPageFlagFirstPage pageTime:0];
}

-(void)_getNextPage
{
    if (_hasMore)
    {
        long long newsID = 0, pageTime = 0;
        GGHappening *last = [_happenings lastObject];
        if (last)
        {
            newsID = last.ID;
            pageTime = last.timestamp;
        }
        
        [self _getDataWithEventID:newsID pageFlag:kGGPageFlagMoveDown pageTime:pageTime];
    }
    else
    {
        [self _delayedStopInfiniteAnimating];
    }
}

-(void)_getDataWithEventID:(long long)anEventID pageFlag:(int)aPageFlag pageTime:(long long)aPageTime
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {

        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyHappenings];
        
        if (parser.isOK)
        {
            _hasMore = page.hasMore;
            
            if (page.items.count)
            {
                switch (aPageFlag)
                {
                    case kGGPageFlagFirstPage:
                    {
                        [_happenings removeAllObjects];
                        [_happenings addObjectsFromArray:page.items];
                    }
                        break;
                        
                    case kGGPageFlagMoveDown:
                    {
                        [_happenings addObjectsFromArray:page.items];
                        
                        
                    }
                        break;
                        
                    case kGGPageFlagMoveUp:
                    {
                        NSMutableArray *newHappenings = [NSMutableArray arrayWithArray:page.items];
                        [newHappenings addObjectsFromArray:_happenings];
                        self.happenings = newHappenings;
                    }
                        break;
                        
                    default:
                        break;
                }
            }

        }
        
        [self.tvHappenings reloadData];
        [_refreshControl endRefreshing];
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        //[self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:SCROLL_REFRESH_STOP_DELAY];
    };
    
    if (_isPersonHappenings)
    {
        id op = [GGSharedAPI getHappeningsWithPersonID:_personID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
        [self registerOperation:op];
    }
    else
    {
        id op = [GGSharedAPI getHappeningsWithCompanyID:_companyID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
        [self registerOperation:op];
    }
    
}

-(void)_delayedStopAnimating
{
    __weak GGHappeningsVC *weakSelf = self;
    //[weakSelf.tvHappenings.pullToRefreshView stopAnimating];
    [_refreshControl endRefreshing];
    [weakSelf.tvHappenings.infiniteScrollingView stopAnimating];
}

-(void)_delayedStopInfiniteAnimating
{
    __weak GGHappeningsVC *weakSelf = self;
    
    [weakSelf.tvHappenings.infiniteScrollingView stopAnimating];
}


#pragma mark - 
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_tvHappenings centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH_FULL];
}

@end
