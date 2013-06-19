//
//  GGSavedUpdatesVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-18.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSavedUpdatesVC.h"

//#import "DCRoundSwitch.h"


#import "GGDataPage.h"
#import "GGCompanyUpdate.h"
#import "GGCompanyUpdateCell.h"
#import "SVPullToRefresh.h"
#import "GGCompany.h"
#import "GGCompanyDetailVC.h"
#import "GGCompanyUpdateDetailVC.h"
#import "GGEmptyView.h"
#import "GGCompanyUpdateIpadCell.h"
#import "GGTableViewExpandHelper.h"

#define SWITCH_WIDTH 80
#define SWITCH_HEIGHT 20

#define EMPTY_TEXT_ALL      @"There are no updates to show in this view."//@"No saved updates yet."
#define EMPTY_TEXT_UNREAD   @"There are no updates to show in this view."//@"No unread updates yet."

@interface GGSavedUpdatesVC ()
@property (strong, nonatomic) GGEmptyView *viewEmpty;
@property (strong) UITableView     *tvUpdates;
@end

@implementation GGSavedUpdatesVC
{
    GGSwitchButton   *_roundSwitch;
    NSUInteger      _currentPageIndex;
    BOOL            _hasMore;
    NSMutableArray  *_updates;
    
    BOOL            _isUnread;
    
    GGTableViewExpandHelper             *_tvExpandHelper;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.tabBarItem.title = @"Saved";
        //self.tabBarItem.image = [UIImage imageNamed:@"Players"];
        _updates = [NSMutableArray array];
        _currentPageIndex = GG_PAGE_START_INDEX;
        _isUnread = NO;
    }
    return self;
}

-(void)_initRoundSwitch
{
    _roundSwitch = [GGSwitchButton viewFromNibWithOwner:self];
    _roundSwitch.delegate = self;
    _roundSwitch.lblOn.text = @"Unread";
    _roundSwitch.lblOff.text = @"All";
    _roundSwitch.isOn = _isUnread;
    
    [self _setSwitchRect];
}

-(void)_setSwitchRect
{
    CGRect naviRc = self.navigationController.navigationBar.frame;
    
    CGRect switchRc = CGRectMake(naviRc.size.width - SWITCH_WIDTH - 5
                                 , (naviRc.size.height - [GGSwitchButton HEIGHT]) / 2 + 5
                                 , SWITCH_WIDTH
                                 , [GGSwitchButton HEIGHT]);
    _roundSwitch.frame = switchRc;
}

- (void)viewDidLoad
{
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
    
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"Saved Updates";
    
    [self _initRoundSwitch];
    [self.navigationController.navigationBar addSubview:_roundSwitch];
    
    //
    _tvUpdates = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    //_tvUpdates.rowHeight = [GGCompanyUpdateCell HEIGHT];
    _tvUpdates.dataSource = self;
    _tvUpdates.delegate = self;
    _tvUpdates.backgroundColor = GGSharedColor.silver;
    _tvUpdates.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tvUpdates.showsVerticalScrollIndicator = NO;
    _tvUpdates.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    _tvExpandHelper = [[GGTableViewExpandHelper alloc] initWithTableView:_tvUpdates];
    [self.view addSubview:_tvUpdates];
    
    _viewEmpty = [GGEmptyView viewFromNibWithOwner:self];
    _viewEmpty.lblMessage.text = EMPTY_TEXT_ALL;
    _viewEmpty.frame = _tvUpdates.bounds;
    [_tvUpdates addSubview:_viewEmpty];
    
    
    // setup pull-to-refresh and infinite scrolling
    __weak GGSavedUpdatesVC *weakSelf = self;
    
    [_tvUpdates addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [_tvUpdates addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    [_tvUpdates triggerPullToRefresh];
    [self addScrollToHide:_tvUpdates];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_roundSwitch];
    [self _setSwitchRect];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_roundSwitch removeFromSuperview];
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
        [_updates removeAllObjects];
        [_tvUpdates reloadData];
    }
    else if ([notification.name isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [_tvUpdates triggerPullToRefresh];
    }
}

#pragma mark - actions
-(void)switchButton:(GGSwitchButton *)aSwitchButton isOn:(BOOL)aIsOn
{
    _isUnread = aIsOn;
    [_tvUpdates triggerPullToRefresh];
}

-(void)companyDetailAction:(id)sender
{
    UIButton *button = sender;
    GGCompanyUpdate *update = [_updates objectAtIndex:button.tag];
    
    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
    vc.companyID = update.company.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - API calls
-(void)_getFirstPage
{
    [_updates removeAllObjects];
    _currentPageIndex = GG_PAGE_START_INDEX;
    _hasMore = YES;
    [self _callGetSavedUpdates];
}

-(void)_getNextPage
{
    if (_hasMore)
    {
        _currentPageIndex++;
        [self _callGetSavedUpdates];
    }
    else
    {
        [self _delayedStopInfiniteAnimating];
        //[self performSelector:@selector(_delayedStopInfiniteAnimating) withObject:nil afterDelay:.5f];
    }
}

-(void)_callGetSavedUpdates
{
    _roundSwitch.btnSwitch.enabled = NO;
    id op = [GGSharedAPI getSaveUpdatesWithPageIndex:_currentPageIndex isUnread:_isUnread callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _hasMore = parser.dataHasMore;
            
            GGDataPage *page = [parser parseGetSavedUpdates];
            [_updates addObjectsFromArray:page.items];
        }
        else
        {
            _hasMore = NO;
        }
        
        _viewEmpty.hidden = _updates.count;
        _viewEmpty.lblMessage.text = _isUnread ? EMPTY_TEXT_UNREAD : EMPTY_TEXT_ALL;
        [_tvUpdates reloadData];
        
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    }];
    
    [self registerOperation:op];
}

-(void)_delayedStopAnimating
{
    __weak GGSavedUpdatesVC *weakSelf = self;
    [weakSelf.tvUpdates.pullToRefreshView stopAnimating];
    [weakSelf.tvUpdates.infiniteScrollingView stopAnimating];
    
    _roundSwitch.btnSwitch.enabled = YES;
}

-(void)_delayedStopInfiniteAnimating
{
    __weak GGSavedUpdatesVC *weakSelf = self;
    
    [weakSelf.tvUpdates.infiniteScrollingView stopAnimating];
    
    _roundSwitch.btnSwitch.enabled = YES;
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = _updates.count;
    return count;
}

-(float)_updateCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return [self _updateCellForIndexPath:indexPath].frame.size.height;
}

-(GGCompanyUpdateCell *)_updateCellForIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    static NSString *updateCellId = @"GGCompanyUpdateCell";
    GGCompanyUpdateCell *cell = [_tvUpdates dequeueReusableCellWithIdentifier:updateCellId];
    
    GGTagetActionPair *action = [GGTagetActionPair pairWithTaget:self action:@selector(companyDetailAction:)];
    cell = [GGFactory cellOfComUpdate:cell
                                 data:[_updates objectAtIndexSafe:row]
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
    GGCompanyUpdateIpadCell *cell = nil;//[_tvUpdates dequeueReusableCellWithIdentifier:updateCellId];
    
    GGTagetActionPair *logoAction = [GGTagetActionPair pairWithTaget:self action:@selector(companyDetailAction:)];
    GGTagetActionPair *headlineAction = [GGTagetActionPair pairWithTaget:self action:@selector(_enterUpdateDetailAction:)];
    
    cell = [GGFactory cellOfComUpdateIpad:cell
                                     data:[_updates objectAtIndexSafe:row]
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

#pragma mark - tableView delegate
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
    vc.updates = _updates;
    vc.updateIndex = aIndex;
    GGCompanyUpdate *data = _updates[aIndex];
    data.hasBeenRead = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidUnload {
    [self setViewEmpty:nil];
    [super viewDidUnload];
}

#pragma mark -
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_tvUpdates centerMeHorizontallyChangeMyWidth:_tvUpdates.superview.frame.size.width];
    
    [self _setSwitchRect];
}

@end
