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
    NSUInteger      _currentPageIndex;
    BOOL            _hasMore;
    NSMutableArray  *_updates;
    
    BOOL            _isUnread;
    
    GGTableViewExpandHelper             *_tvExpandHelper;
    UIImageView                         *_tvPictureView;
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

-(UILabel *)_subNaviLabel
{
    static UILabel *_subNaviLabel = nil;
    if (_subNaviLabel == nil)
    {
        CGRect naviRc = [GGLayout navibarFrame];
        CGRect subNaviRc = CGRectMake(naviRc.size.width / 4, 30, naviRc.size.width / 2, 15);
        _subNaviLabel = [[UILabel alloc] initWithFrame:subNaviRc];
        _subNaviLabel.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_LIGHT size:12.f];
        _subNaviLabel.textColor = GGSharedColor.white;
        _subNaviLabel.backgroundColor = GGSharedColor.clear;
        _subNaviLabel.textAlignment = NSTextAlignmentCenter;
        _subNaviLabel.text = _isUnread ? GGString(@"Unread") : GGString(@"All");
    }
    
    return _subNaviLabel;
}

-(void)_makeSubNaviTitleVisible:(BOOL)aVisible
{
    if (aVisible)
    {
        [self.navigationController.navigationBar addSubview:[self _subNaviLabel]];
        [[self _subNaviLabel] centerMeHorizontally];
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0.f forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [[self _subNaviLabel] removeFromSuperview];
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:5.f forBarMetrics:UIBarMetricsDefault];
    }
}

-(IBAction)switchBtweenUpdateAndHappening:(id)sender
{
    _isUnread = !_isUnread;
    [self _subNaviLabel].text = _isUnread ? GGString(@"Unread") : GGString(@"All");

    
    _tvPictureView.image = [_tvUpdates myPicture];
    _tvPictureView.frame = _tvUpdates.frame;
    _tvPictureView.alpha = 1.f;
    
    float offsetX = _isUnread ? self.view.frame.size.width : -self.view.frame.size.width;
    _tvUpdates.frame = CGRectMake(offsetX, _tvUpdates.frame.origin.y, _tvUpdates.frame.size.width, _tvUpdates.frame.size.height);
    _tvUpdates.alpha = 0.f;
    
    [UIView animateWithDuration:.3f animations:^{
        
        _tvUpdates.frame = CGRectMake(0, _tvUpdates.frame.origin.y, _tvUpdates.frame.size.width, _tvUpdates.frame.size.height);
        _tvUpdates.alpha = 1.f;
        
        _tvPictureView.frame = CGRectOffset(_tvUpdates.frame, -offsetX, 0);
        _tvPictureView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        [_updates removeAllObjects];
        [_tvUpdates reloadData];
        [_tvUpdates triggerPullToRefresh];
        
    }];
    
}


- (void)viewDidLoad
{
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
    
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"Saved Updates";
    
    //[self _initRoundSwitch];
    //[self.navigationController.navigationBar addSubview:_roundSwitch];
    
    // switch bar button
//    CGPoint offset = CGPointMake(0, 3);
//    GGTagetActionPair *action = [GGTagetActionPair pairWithTaget:self action:@selector(switchBtweenUpdateAndHappening:)];
//    UIBarButtonItem *switchBtn = [GGUtils barButtonWithImageName:@"btnSwitchArrow" offset:offset action:action];
//    self.navigationItem.rightBarButtonItem = switchBtn;
    
    //
    _tvUpdates = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    _tvUpdates.dataSource = self;
    _tvUpdates.delegate = self;
    _tvUpdates.backgroundColor = GGSharedColor.silver;
    _tvUpdates.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tvUpdates.showsVerticalScrollIndicator = NO;
    _tvUpdates.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    _tvExpandHelper = [[GGTableViewExpandHelper alloc] initWithTableView:_tvUpdates];
    //_tvUpdates.backgroundColor = GGSharedColor.random;
    [self.view addSubview:_tvUpdates];
    //
    _tvPictureView = [[UIImageView alloc] initWithFrame:_tvUpdates.frame];
    _tvPictureView.alpha = 0;
    [self.view addSubview:_tvPictureView];
    
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
    
    //[_tvUpdates centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH_FULL];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (ISIPADDEVICE)
    {
        [_tvUpdates centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH_FULL];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self _makeSubNaviTitleVisible:NO];
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
//-(void)switchButton:(GGSwitchButton *)aSwitchButton isOn:(BOOL)aIsOn
//{
//    _isUnread = aIsOn;
//    [_tvUpdates triggerPullToRefresh];
//}

-(void)companyDetailAction:(id)sender
{
    UIButton *button = sender;
    GGCompanyUpdate *update = [_updates objectAtIndex:button.tag];
    
    [self enterCompanyDetailWithID:update.company.ID];
    
//    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
//    vc.companyID = update.company.ID;
//    [self.navigationController pushViewController:vc animated:YES];
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
    //_roundSwitch.btnSwitch.enabled = NO;
    _viewEmpty.hidden = YES;
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
    
    //_roundSwitch.btnSwitch.enabled = YES;
}

-(void)_delayedStopInfiniteAnimating
{
    __weak GGSavedUpdatesVC *weakSelf = self;
    
    [weakSelf.tvUpdates.infiniteScrollingView stopAnimating];
    
    //_roundSwitch.btnSwitch.enabled = YES;
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
    return [self _updateIpadCellForIndexPath:indexPath needDetail:NO].frame.size.height;
}

-(GGCompanyUpdateIpadCell *)_updateIpadCellForIndexPath:(NSIndexPath *)indexPath needDetail:(BOOL)aNeedDetail
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
                           headlineAction:headlineAction needDetail:aNeedDetail];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPADDEVICE)
    {
        return [self _updateIpadCellForIndexPath:indexPath needDetail:YES];
    }
    else
    {
        return [self _updateCellForIndexPath:indexPath];
    }
    
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0)
//    {
//        [_tvExpandHelper resetCellHeights];
//    }
    
    float height = ISIPADDEVICE ? [self _updateIpadCellHeightForIndexPath:indexPath] : [self _updateCellHeightForIndexPath:indexPath];
    //[_tvExpandHelper recordCellHeight:height];
    return height;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPADDEVICE)
    {
        if (_tvExpandHelper.isExpanding && indexPath.row == _tvExpandHelper.expandingIndex)
        {
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
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
        //BOOL oldIsExpanding = _tvExpandHelper.isExpanding;
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
        //[_tvExpandHelper scrollToCenterFrom:oldIndex to:row oldIsExpanding:oldIsExpanding];
        
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
    
    vc.naviTitleString = @"Saved Updates";
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
    
//#warning LAYOUT PROBLEM!!!
    //_tvUpdates.backgroundColor = GGSharedColor.darkRed;
    [_tvUpdates centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH_FULL];
    
    [[self _subNaviLabel] centerMeHorizontally];
}

@end
