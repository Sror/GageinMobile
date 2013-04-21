//
//  GGCompaniesVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompaniesVC.h"
#import "SVPullToRefresh.h"
#import "GGCompanyUpdateCell.h"
#import "GGDataPage.h"
#import "GGCompany.h"
#import "GGCompanyUpdate.h"
#import "GGCompanyHappening.h"
#import "GGMenuData.h"

#import "GGSlideSettingView.h"
#import "GGCompanyDetailVC.h"
#import "GGCompanyUpdateDetailVC.h"
#import "GGScrollingView.h"
#import "GGFollowCompanyVC.h"
#import "GGSettingHeaderView.h"
#import "GGSettingMenuCell.h"
#import "GGAppDelegate.h"
#import "GGCompanyHappeningCell.h"
#import "GGSelectAgentsVC.h"

@interface GGCompaniesVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@property (nonatomic, strong) UITableView *happeningsTV;
@end

@implementation GGCompaniesVC
{
    EGGCompanyUpdateRelevance   _relevance;
    GGScrollingView             *_scrollingView;
    GGSlideSettingView          *_slideSettingView;
    NSArray                    *_menuDatas;
    
    EGGMenuType                _menuType;
    long long                  _menuID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Companies";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        _relevance = kGGCompanyUpdateRelevanceNormal;
        _updates = [NSMutableArray array];
        _happenings = [NSMutableArray array];
        _menuType = kGGMenuTypeAgent;   // exploring...
        _menuID = GG_ALL_RESULT_ID;
    }
    return self;
}

- (void)viewDidLoad
{
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
    
    [super viewDidLoad];
    
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(optionMenuAction:)];
    

    //self.naviBar.hidden = YES;
    self.navigationItem.title = @"EXPLORING";
    self.navigationItem.leftBarButtonItem = menuBtn;
    
    
    CGRect updateRc = self.view.bounds;
    
    //
    _slideSettingView = [[GGSlideSettingView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    _slideSettingView.viewTable.backgroundColor = GGSharedColor.clear;
    _slideSettingView.viewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _slideSettingView.viewTable.dataSource = self;
    _slideSettingView.viewTable.delegate = self;
    _slideSettingView.viewTable.rowHeight = [GGSettingMenuCell HEIGHT];
    UIView *theWindow = GGSharedDelegate.window;
    [theWindow addSubview:_slideSettingView];
    
    // ------- add scrolling view
    _scrollingView = [GGScrollingView viewFromNibWithOwner:self];
    _scrollingView.frame = self.view.bounds;
    _scrollingView.delegate = self;
    [self.view addSubview:_scrollingView];
    
    self.updatesTV = [[UITableView alloc] initWithFrame:updateRc style:UITableViewStylePlain];
    self.updatesTV.rowHeight = [GGCompanyUpdateCell HEIGHT];
    self.updatesTV.dataSource = self;
    self.updatesTV.delegate = self;
    [_scrollingView addPage:self.updatesTV];
    self.updatesTV.backgroundColor = GGSharedColor.silver;
    
    self.happeningsTV = [[UITableView alloc] initWithFrame:updateRc style:UITableViewStylePlain];
    self.happeningsTV.rowHeight = [GGCompanyHappeningCell HEIGHT];
    self.happeningsTV.dataSource = self;
    self.happeningsTV.delegate = self;
    [_scrollingView addPage:self.happeningsTV];
    self.happeningsTV.backgroundColor = GGSharedColor.silver;
    
    //
    [self.view bringSubviewToFront:_slideSettingView];
    
    
    // setup pull-to-refresh and infinite scrolling
    __weak GGCompaniesVC *weakSelf = self;

    [self.updatesTV addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [self.updatesTV addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    [self.happeningsTV addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstHappeningPage];
    }];
    
    [self.happeningsTV addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextHappeningPage];
    }];
    
    [self.updatesTV triggerPullToRefresh];
    [self. happeningsTV triggerPullToRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    //[self setNaviBar:nil];
    //[self setNaviItem:nil];
    [_updates removeAllObjects];
    [super viewDidUnload];
}

-(void)dealloc
{
    [self unobserveAllNotifications];
}

#pragma mark - notification handling
-(void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:GG_NOTIFY_LOG_OUT])
    {
        [_updates removeAllObjects];
        [self.updatesTV reloadData];
        
        [_happenings removeAllObjects];
        [self.happeningsTV reloadData];
    }
    else if ([notification.name isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self.updatesTV triggerPullToRefresh];
        [self.happeningsTV triggerPullToRefresh];
    }
}

#pragma mark - internal
-(GGSettingHeaderView *)_followingSectionView
{
    static GGSettingHeaderView *_followingSectionView;
    if (_followingSectionView == nil) {
        _followingSectionView = [GGSettingHeaderView viewFromNibWithOwner:self];
        _followingSectionView.lblTitle.text = @"FOLLOWING";
        _followingSectionView.ivSelected.hidden = YES;
        [_followingSectionView.btnBg addTarget:self action:@selector(_followingTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_followingSectionView.btnAdd addTarget:self action:@selector(_addCompanyAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _followingSectionView;
}

-(GGSettingHeaderView *)_exploringSectionView
{
    static GGSettingHeaderView *_exploringSectionView;
    if (_exploringSectionView == nil) {
        _exploringSectionView = [GGSettingHeaderView viewFromNibWithOwner:self];
        _exploringSectionView.lblTitle.text = @"EXPLORING";
        _exploringSectionView.ivSelected.hidden = NO;
        _exploringSectionView.btnAdd.hidden = YES;
        [_exploringSectionView.btnBg addTarget:self action:@selector(_exploringTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_exploringSectionView.btnConfig addTarget:self action:@selector(_exploringConfigTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exploringSectionView;
}


-(IBAction)_addCompanyAction:(id)sender
{
    [_slideSettingView hideSlide];
    [self searchForCompanyAction:nil];
}

-(IBAction)_followingTapped:(id)sender
{
    self.navigationItem.title = @"FOLLOWING";
    
    [self _followingSectionView].ivSelected.hidden = NO;
    [self _exploringSectionView].ivSelected.hidden = YES;
    
    [self _unselectAllMenuItem];
    [_slideSettingView.viewTable reloadData];
    
    [self _refreshWithMenuId:GG_ALL_RESULT_ID type:kGGMenuTypeCompany];
}

-(IBAction)_exploringConfigTapped:(id)sender
{
    [_slideSettingView hideSlide];
    GGSelectAgentsVC *vc = [[GGSelectAgentsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)_exploringTapped:(id)sender
{
    self.navigationItem.title = @"EXPLORING";
    
    [self _followingSectionView].ivSelected.hidden = YES;
    [self _exploringSectionView].ivSelected.hidden = NO;
    
    [self _unselectAllMenuItem];
    [_slideSettingView.viewTable reloadData];
    
    [self _refreshWithMenuId:GG_ALL_RESULT_ID type:kGGMenuTypeAgent];
}

-(void)_refreshWithMenuId:(long long)aMenuID type:(EGGMenuType)aType
{
    [_slideSettingView hideSlide];
    
    _menuType = aType;
    _menuID = aMenuID;
    [self.updates removeAllObjects];
    [self.updatesTV reloadData];
    [self.updatesTV triggerPullToRefresh];
    
    [self.happenings removeAllObjects];
    [self.happeningsTV reloadData];
    [self.happeningsTV triggerPullToRefresh];
}

-(void)_unselectAllMenuItem
{
    for (GGDataPage *page in _menuDatas) {
        for (GGMenuData *menuData in page.items) {
            menuData.checked = NO;
        }
    }
}

-(void)_selectMenuItemByID:(long long)aMenuID
{
    for (GGDataPage *page in _menuDatas) {
        for (GGMenuData *menuData in page.items) {
            menuData.checked = (menuData.ID == aMenuID);
        }
    }
}


#pragma mark - actions
-(void)optionMenuAction:(id)sender
{
    DLog(@"option menu clicked");
    if (!_slideSettingView.isShowing)
    {
        [_slideSettingView showSlide];
        [self _callApiGetMenu];
    }
    else
    {
        [_slideSettingView hideSlide];
    }
}

-(void)searchForCompanyAction:(id)sender
{
    GGFollowCompanyVC *vc = [[GGFollowCompanyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//-(void)savedUpdateAction:(id)sender
//{
//    DLog(@"saved update clicked");
//    [GGAlert alert:@"Saved updates (TODO)"];
//}

-(void)companyDetailAction:(id)sender
{
    //GGCompanyUpdateCell *cell = (GGCompanyUpdateCell *)((UIButton*)sender).superview.superview;
    int index = ((UIButton*)sender).tag;
    GGCompanyUpdate *update = [_updates objectAtIndex:index];
    
    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
    vc.companyID = update.company.ID;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _slideSettingView.viewTable)
    {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.updatesTV) {
        return self.updates.count;
    }
    else if (tableView == self.happeningsTV)
    {
        return self.happenings.count;
    }
    else if (tableView == _slideSettingView.viewTable)
    {
        GGDataPage *page = _menuDatas[section];
        return page.items.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.updatesTV)
    {
        static NSString *updateCellId = @"GGCompanyUpdateCell";
        GGCompanyUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
        if (cell == nil) {
            cell = [GGCompanyUpdateCell viewFromNibWithOwner:self];
            [cell.logoBtn addTarget:self action:@selector(companyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGCompanyUpdate *updateData = [self.updates objectAtIndex:indexPath.row];
        
        cell.ID = updateData.ID;
        cell.logoBtn.tag = indexPath.row;
        //cell.tag = indexPath.row;
        cell.titleLbl.text = updateData.headline;
        cell.sourceLbl.text = updateData.fromSource;
        cell.descriptionLbl.text = updateData.content;
        [cell.logoIV setImageWithURL:[NSURL URLWithString:updateData.company.logoPath] placeholderImage:nil];
        
        cell.intervalLbl.text = [updateData intervalStringWithDate:updateData.date];
        
//        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//        formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//        NSString *dateStr = [formater stringFromDate:date];
//        cell.titleLbl.text = [NSString stringWithFormat:@"%d", days];//dateStr;//[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterFullStyle];
        
        return cell;
    }
    else if (tableView == self.happeningsTV)
    {
        static NSString *happeningCellId = @"GGCompanyHappeningCell";
        GGCompanyHappeningCell *cell = [tableView dequeueReusableCellWithIdentifier:happeningCellId];
        if (cell == nil) {
            cell = [GGCompanyHappeningCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGCompanyHappening *data = _happenings[indexPath.row];
        cell.lblName.text = data.sourceText;
        cell.lblDescription.text = data.headLineText;
        [cell.ivLogo setImageWithURL:[NSURL URLWithString:data.orgLogoPath] placeholderImage:nil];
        
        return cell;
    }
    else if (tableView == _slideSettingView.viewTable)
    {
        static NSString *menuCellId = @"GGSettingMenuCell";
        GGSettingMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellId];
        if (cell == nil) {
            cell = [GGSettingMenuCell viewFromNibWithOwner:self];
        }
        
        GGDataPage *page = _menuDatas[indexPath.section];
        GGMenuData *menuData = page.items[indexPath.row];
        cell.lblInterval.text = menuData.timeInterval;
        cell.lblName.text = menuData.name;
        
        cell.ivSelected.hidden = !menuData.checked;
        
        return cell;
    }
    
    return nil;
}


#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _slideSettingView.viewTable)
    {
        return [GGSettingHeaderView HEIGHT];
    }
    
    return 0;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _slideSettingView.viewTable)
    {
        if (section == 0) {
            return [self _followingSectionView];
        } else {
            return [self _exploringSectionView];
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.updatesTV)
    {
        //GGCompanyUpdate *updateData = [self.updates objectAtIndex:indexPath.row];
        GGCompanyUpdateDetailVC *vc = [[GGCompanyUpdateDetailVC alloc] init];
        //vc.newsID = updateData.ID;
        vc.naviTitle = self.navigationItem.title;
        vc.updates = self.updates;
        vc.updateIndex = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tableView == self.happeningsTV)
    {
        //
    }
    else if (tableView == _slideSettingView.viewTable)
    {
        GGDataPage *thePage = _menuDatas[indexPath.section];
        GGMenuData *theData = thePage.items[indexPath.row];
        
        for (GGDataPage *page in _menuDatas) {
            BOOL isPageMatch = (thePage == page);
            for (GGMenuData *menuData in page.items) {
                menuData.checked = (isPageMatch && theData == menuData);
            }
        }
        
        self.navigationItem.title = theData.name;
        [self _exploringSectionView].ivSelected.hidden = YES;
        [self _followingSectionView].ivSelected.hidden = YES;
        
        [tableView reloadData];
        
        //get update data by menuID
        _menuType = theData.type;
        _menuID = theData.ID;
        
//        [self.updates removeAllObjects];
//        [self.updatesTV reloadData];
//        [self.updatesTV triggerPullToRefresh];
//        [self.happenings removeAllObjects];
//        [self.happeningsTV reloadData];
//        [self.happeningsTV triggerPullToRefresh];
        
        [self _refreshWithMenuId:theData.ID type:theData.type];
    }
}

#pragma mark - scrolling view delegate
-(void)scrollingView:(GGScrollingView *)aScrollingView didScrollToIndex:(NSUInteger)aPageIndex;
{
    DLog(@"scrolling to index:%d", aPageIndex);
}


#pragma mark - data handling
-(void)_callApiGetMenu
{
    [GGSharedAPI getMenuByType:kGGStrMenuTypeCompanies callback:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _menuDatas = [parser parseGetMenu];
            
            if (_menuID == GG_ALL_RESULT_ID)
            {
                [self _unselectAllMenuItem];
                
                [self _followingSectionView].ivSelected.hidden = !(_menuType == kGGMenuTypeCompany);
                [self _exploringSectionView].ivSelected.hidden = (_menuType == kGGMenuTypeCompany);
            }
            else
            {
                [self _selectMenuItemByID:_menuID];
                
                [self _followingSectionView].ivSelected.hidden = YES;
                [self _exploringSectionView].ivSelected.hidden = YES;
            }
            
            [_slideSettingView.viewTable reloadData];
        }
        else
        {
            _menuDatas = nil;
            [GGAlert alert:parser.message];
        }
    }];
}

-(void)_getFirstPage
{
    [self _getDataWithNewsID:0 pageFlag:kGGPageFlagFirstPage pageTime:0 relevance:_relevance];
}

-(void)_getNextPage
{
    long long newsID = 0, pageTime = 0;
    GGCompanyUpdate *lastUpdate = [_updates lastObject];
    if (lastUpdate)
    {
        newsID = lastUpdate.ID;
        pageTime = lastUpdate.date;
    }
    
    [self _getDataWithNewsID:newsID pageFlag:kGGPageFlagMoveDown pageTime:pageTime relevance:_relevance];
}

-(void)_getPrevPage
{
    long long newsID = 0, pageTime = 0;
    GGCompanyUpdate *firstUpdate = _updates.count > 0 ? [_updates objectAtIndex:0] : nil;
    if (firstUpdate)
    {
        newsID = firstUpdate.ID;
        pageTime = firstUpdate.date;
    }
    
    [self _getDataWithNewsID:newsID pageFlag:kGGPageFlagMoveUp pageTime:pageTime relevance:_relevance];
}

-(void)_getDataWithNewsID:(long long)aNewsID pageFlag:(int)aPageFlag pageTime:(long long)aPageTime relevance:(int)aRelevance
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        //DLog(@"%@", aResultObject);
        
        //[self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyUpdates];
        //DLog(@"%@", page);
        
        if (page.items.count)
        {
            switch (aPageFlag)
            {
                case kGGPageFlagFirstPage:
                {
                    [_updates removeAllObjects];
                    [_updates addObjectsFromArray:page.items];
                }
                    break;
                    
                case kGGPageFlagMoveDown:
                {
                    [_updates addObjectsFromArray:page.items];
                    
                    
                }
                    break;
                    
                case kGGPageFlagMoveUp:
                {
                    NSMutableArray *newUpdates = [NSMutableArray arrayWithArray:page.items];
                    [newUpdates addObjectsFromArray:_updates];
                    self.updates = newUpdates;
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        [self.updatesTV reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    };
    
    //[self showLoadingHUD];
    if (_menuType == kGGMenuTypeCompany)
    {
        [GGSharedAPI getCompanyUpdatesWithCompanyID:_menuID newsID:aNewsID pageFlag:aPageFlag pageTime:aPageTime relevance:aRelevance callback:callback];
    }
    else if (_menuType == kGGMenuTypeAgent)
    {
        [GGSharedAPI getCompanyUpdatesWithAgentID:_menuID newsID:aNewsID pageFlag:aPageFlag pageTime:aPageTime relevance:aRelevance callback:callback];
    }
}

-(void)_getFirstHappeningPage
{
    [self _getHappeningsDataWithPageFlag:kGGPageFlagFirstPage pageTime:0];
}

-(void)_getNextHappeningPage
{
    long long pageTime = 0;
    GGCompanyHappening *lastHappening = [_happenings lastObject];
    if (lastHappening)
    {
        pageTime = lastHappening.timestamp;
    }
    
    [self _getHappeningsDataWithPageFlag:kGGPageFlagMoveDown pageTime:pageTime];
}

-(void)_getPrevHappeningPage
{
    long long pageTime = 0;
    GGCompanyHappening *firstHappening = _happenings.count > 0 ? [_happenings objectAtIndex:0] : nil;
    if (firstHappening)
    {
        pageTime = firstHappening.timestamp;
    }
    
    [self _getHappeningsDataWithPageFlag:kGGPageFlagMoveUp pageTime:pageTime];
}

-(void)_getHappeningsDataWithPageFlag:(int)aPageFlag pageTime:(long long)aPageTime
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        //DLog(@"%@", aResultObject);
        
        //[self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyHappenings];
        //DLog(@"%@", page);
        
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
                    NSMutableArray *newUpdates = [NSMutableArray arrayWithArray:page.items];
                    [newUpdates addObjectsFromArray:_happenings];
                    self.happenings = newUpdates;
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        [self.happeningsTV reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopHappeningAnimating) withObject:nil afterDelay:.5f];
    };
    
    //[self showLoadingHUD];
    if (_menuType == kGGMenuTypeCompany)
    {
        [GGSharedAPI getHappeningsWithCompanyID:_menuID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
    }
    else if (_menuType == kGGMenuTypeAgent)
    {
#warning no happenings for agent!
        [self performSelector:@selector(_delayedStopHappeningAnimating) withObject:nil afterDelay:.5f];
    }
}

-(void)_delayedStopAnimating
{
    __weak GGCompaniesVC *weakSelf = self;
    [weakSelf.updatesTV.pullToRefreshView stopAnimating];
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
}

-(void)_delayedStopHappeningAnimating
{
    __weak GGCompaniesVC *weakSelf = self;
    [weakSelf.happeningsTV.pullToRefreshView stopAnimating];
    [weakSelf.happeningsTV.infiniteScrollingView stopAnimating];
}





//- (void)insertRowAtTop {
//    __weak GGCompaniesVC *weakSelf = self;
//    
//    int64_t delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [weakSelf.updatesTV beginUpdates];
//        [weakSelf.dataSource insertObject:[NSDate date] atIndex:0];
//        [weakSelf.updatesTV insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
//        [weakSelf.updatesTV endUpdates];
//        
//        [weakSelf.updatesTV.pullToRefreshView stopAnimating];
//    });
//}
//
//
//- (void)insertRowAtBottom {
//    __weak GGCompaniesVC *weakSelf = self;
//    
//    int64_t delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [weakSelf.updatesTV beginUpdates];
//        [weakSelf.dataSource addObject:[weakSelf.dataSource.lastObject dateByAddingTimeInterval:-90]];
//        [weakSelf.updatesTV insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//        [weakSelf.updatesTV endUpdates];
//        
//        [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
//    });
//}

@end
