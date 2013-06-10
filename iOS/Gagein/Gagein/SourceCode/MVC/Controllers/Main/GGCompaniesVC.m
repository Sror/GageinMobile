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
#import "GGHappening.h"
#import "GGMenuData.h"


#import "GGCompanyDetailVC.h"
#import "GGCompanyUpdateDetailVC.h"
#import "GGComUpdateSearchVC.h"
#import "GGHappeningDetailVC.h"
#import "GGConfigFiltersVC.h"

#import "GGScrollingView.h"
#import "GGFollowCompanyVC.h"
#import "GGSettingHeaderView.h"
#import "GGSettingMenuCell.h"
#import "GGAppDelegate.h"
#import "GGCompanyHappeningCell.h"
#import "GGSelectAgentsVC.h"
#import "GGSearchBar.h"
#import "GGSwitchButton.h"
#import "GGRelevanceBar.h"
//#import "GGEmptyView.h"
#import "GGEmptyActionView.h"
#import "GGComUpdateSearchResultVC.h"
#import "GGKeywordExampleCell.h"
#import "GGConfigLabel.h"
#import "GGCompanyUpdateIpadCell.h"

#define SWITCH_WIDTH 90
#define SWITCH_HEIGHT 20

@interface GGCompaniesVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@property (nonatomic, strong) UITableView *happeningsTV;

@end

@implementation GGCompaniesVC
{
    EGGCompanyUpdateRelevance           _relevance;
    
    GGSlideSettingView                  *_slideSettingView;
    GGRelevanceBar                      *_relevanceBar;
    
    GGEmptyActionView                   *_viewUpdateEmpty;
    GGEmptyActionView                   *_viewHappeningEmpty;
    GGKeywordExampleCell                *_keywordExampleView;
    
    GGSwitchButton                      *_btnSwitchUpdate;
    BOOL                                _isShowingUpdate;
    
    NSArray                             *_menuDatas;
    EGGMenuType                         _menuType;
    long long                           _menuID;
    
    CGPoint                             _lastContentOffset;

    CGRect                              _updateTvRect;
    
    NSTimer                             *_searchTimer;
    NSMutableArray                      *_suggestedUpdates;
    BOOL                                _isShowingRecentSearches;
    
    BOOL                                _hasMoreUpdates;
    BOOL                                _hasMoreHappenings;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _relevance = kGGCompanyUpdateRelevanceHigh;
        _updates = [NSMutableArray array];
        _happenings = [NSMutableArray array];
        _suggestedUpdates = [NSMutableArray array];
        
        _menuType = kGGMenuTypeAgent;   // exploring...
        _menuID = GG_ALL_RESULT_ID;
        _isShowingUpdate = YES;
        
        _keywordExampleView = [GGKeywordExampleCell viewFromNibWithOwner:self];
    }
    return self;
}

-(void)_initSlideSettingView
{
    _slideSettingView = GGSharedDelegate.slideSettingView;
    _slideSettingView.delegate = self;
    _slideSettingView.viewTable.rowHeight = [GGSettingMenuCell HEIGHT];
    _slideSettingView.searchBar.tfSearch.placeholder = @"Search for updates";
    
    [_slideSettingView.searchBar.btnFilter addTarget:self action:@selector(_exploringConfigTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_slideSettingView changeDelegate:self];
}

-(void)_installMenuButton
{
    UIImage *menuBtnImg = [UIImage imageNamed:@"menuBtn"];
    UIView *containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuBtnImg.size.width, menuBtnImg.size.height)];
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setImage:menuBtnImg forState:UIControlStateNormal];
    menuBtn.frame = CGRectMake(0, 3, menuBtnImg.size.width
                               , menuBtnImg.size.height);
    [menuBtn addTarget:self action:@selector(optionMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [containingView addSubview:menuBtn];
    
    UIBarButtonItem *menuBtnItem = [[UIBarButtonItem alloc] initWithCustomView:containingView];
    self.navigationItem.leftBarButtonItem = menuBtnItem;
}

-(void)_initRoundSwitch
{
    _btnSwitchUpdate = [GGSwitchButton viewFromNibWithOwner:self];
    _btnSwitchUpdate.delegate = self;
    _btnSwitchUpdate.lblOn.text = @"Updates";
    _btnSwitchUpdate.lblOff.text = @"Happenings";
    _btnSwitchUpdate.isOn = _isShowingUpdate;
    
    [self _setSwitchUpdateRect];
}

-(void)_setSwitchUpdateRect
{
    CGRect naviRc = self.navigationController.navigationBar.frame;
    CGRect switchRc = CGRectMake(naviRc.size.width - SWITCH_WIDTH - 5
                                 , (naviRc.size.height - [GGSwitchButton HEIGHT]) / 2 + 5
                                 , SWITCH_WIDTH
                                 , [GGSwitchButton HEIGHT]);
    _btnSwitchUpdate.frame = switchRc;
}

-(CGRect)_relevanceFrameHided:(BOOL)aHided
{
    CGRect relevanceRc = _relevanceBar.frame;
    float width = _updatesTV.frame.size.width;
    return aHided ? CGRectMake(0, 5 - relevanceRc.size.height, width, relevanceRc.size.height) : CGRectMake(0, 5, width, relevanceRc.size.height);
}

- (void)viewDidLoad
{
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
    [self observeNotification:GG_NOTIFY_MENU_REVEAL];
    [self observeNotification:GG_NOTIFY_MENU_COVER];
    [self observeNotification:GG_NOTIFY_PAN_BEGIN];
    [self observeNotification:GG_NOTIFY_PAN_END];
    
    [super viewDidLoad];
    
    [self _installMenuButton];
//#warning COLOR is originally silver
    self.view.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"EXPLORING";
    
    [self _initRoundSwitch];

    [self _initSlideSettingView];

    //
     _updateTvRect = [self viewportAdjsted];
    
    self.happeningsTV = [[UITableView alloc] initWithFrame:_updateTvRect style:UITableViewStylePlain];
    self.happeningsTV.dataSource = self;
    self.happeningsTV.delegate = self;
    self.happeningsTV.backgroundColor = GGSharedColor.silver;
    self.happeningsTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.happeningsTV.hidden = YES;
    _happeningsTV.showsVerticalScrollIndicator = NO;
    //_happeningsTV.scrollsToTop = YES;
    
    [self.view addSubview:self.happeningsTV];
    
    //
    self.updatesTV = [[UITableView alloc] initWithFrame:_updateTvRect style:UITableViewStylePlain];
    self.updatesTV.dataSource = self;
    self.updatesTV.delegate = self;
    self.updatesTV.backgroundColor = GGSharedColor.silver;
    self.updatesTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _updatesTV.showsVerticalScrollIndicator = NO;
    //_updatesTV.scrollsToTop = YES;
    
    [self.view addSubview:self.updatesTV];

    //
    _relevanceBar = [GGRelevanceBar viewFromNibWithOwner:self];
    //_relevanceRectShow = CGRectOffset(_relevanceBar.frame, 0, 5);
    //_relevanceRectHide = CGRectOffset(_relevanceRectShow, 0, -_relevanceBar.frame.size.height);
    _relevanceBar.frame = [self _relevanceFrameHided:NO];
    [self.view addSubview:_relevanceBar];
    _relevanceBar.btnSwitch.delegate = self;
    _relevanceBar.btnSwitch.lblOn.text = @"High";
    _relevanceBar.btnSwitch.lblOff.text = @"Medium";
    _relevanceBar.btnSwitch.isOn = YES;
    //_isRelevanceBarShowing = YES;
    
    _updateTvRect.origin.y = CGRectGetMaxY(_relevanceBar.frame) - 5;
#warning working
    _updateTvRect.size.height = self.view.frame.size.height - _updateTvRect.origin.y;
    _updatesTV.frame = _updateTvRect;
    
    //[self.view bringSubviewToFront:_relevanceBar];
    
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
    
    
    //[UIView setAnimationsEnabled:NO];
    [self _getInitData];
    
    //[_updatesTV ScrollMeToTopOnly];
}

-(BOOL)doNeedMenu
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self _adjustTvFrames];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    // show/hide switch button
    [self _setSwitchUpdateRect];
    [self.navigationController.navigationBar addSubview:_btnSwitchUpdate];
    _btnSwitchUpdate.hidden = (_menuType == kGGMenuTypeAgent);
    
    // change menu to company type
    [_slideSettingView changeDelegate:self];
    _slideSettingView.viewTable.tableHeaderView = _slideSettingView.searchBar;
    
    // enable gesture
    [GGSharedDelegate.rootVC enableSwipGesture:YES];
    
    [_updatesTV reloadData];
    [_happeningsTV reloadData];
    
    // this line to solve that when view appear again, update switch doesnt get touch event
    //[_btnSwitchUpdate goTop];
    
    [self _callApiGetMenu];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_btnSwitchUpdate removeFromSuperview];
    
    [GGSharedDelegate.rootVC enableSwipGesture:NO];
    [GGSharedDelegate.rootVC enableTapGesture:NO];
}



- (void)viewDidUnload {
    [_updates removeAllObjects];
    [_happenings removeAllObjects];
    [super viewDidUnload];
}

-(void)dealloc
{
    [self unobserveAllNotifications];
}

#pragma mark - switch button delegate
-(void)switchButton:(GGSwitchButton *)aSwitchButton isOn:(BOOL)aIsOn
{
    if (aSwitchButton == _btnSwitchUpdate)
    {
        _isShowingUpdate = aIsOn;
        self.updatesTV.hidden = _relevanceBar.hidden = !_isShowingUpdate;
        _happeningsTV.hidden = _isShowingUpdate;
        //_isShowingUpdate ? [_updatesTV triggerPullToRefresh] : [_happeningsTV triggerPullToRefresh];
    } else if (aSwitchButton == _relevanceBar.btnSwitch)
    {
        _relevance = (_relevanceBar.btnSwitch.isOn) ? kGGCompanyUpdateRelevanceHigh : kGGCompanyUpdateRelevanceNormal;
        
        [_updates removeAllObjects];
        [self.updatesTV reloadData];
        [self.updatesTV triggerPullToRefresh];
    }
}

#pragma mark -
-(void)_refreshTimer
{
    [_searchTimer invalidate];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(_callApiGetSuggestions) userInfo:nil repeats:NO];
}

#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(GGBaseSearchBar *)searchBar
{
    [_slideSettingView switchSearchMode:YES];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(GGBaseSearchBar *)searchBar
{
    GGBlackSearchBar *blackBar = (GGBlackSearchBar *)searchBar;
    BOOL needShowRecentSearches = (blackBar.tfSearch.text.length <= 0);
    [self _showRecentSearches:needShowRecentSearches];
    [_slideSettingView.tvSuggestedUpdates reloadData];
}

- (BOOL)searchBarShouldEndEditing:(GGBaseSearchBar *)searchBar
{
    //[self _searchAction:searchBar];
    //[_slideSettingView switchSearchMode:NO];
    return YES;
}

- (void)searchBarTextDidEndEditing:(GGBaseSearchBar *)searchBar
{
    
}

- (BOOL)searchBar:(GGBaseSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (range.location <= 0 && text.length <= 0)
    {
        [self searchBarShouldClear:searchBar];
    }
    else
    {
        [self _refreshTimer];
    }

    return YES;
}

- (BOOL)searchBarShouldClear:(GGBaseSearchBar *)searchBar
{
    [_searchTimer invalidate];
    _searchTimer = nil;
    //_slideSettingView.tvSuggestedUpdates.hidden = YES;
    
    [self _showRecentSearches:YES];
    [_slideSettingView.tvSuggestedUpdates reloadData];
    
    return YES;
}

-(void)_showRecentSearches:(BOOL)aIsShow
{
    _isShowingRecentSearches = aIsShow;
    
//    if (_isShowingRecentSearches)
//    {
//        [_suggestedUpdates removeAllObjects];
//        [_suggestedUpdates addObjectsFromArray:GGSharedRuntimeData.recentSearches];
//    }
    
    //[_slideSettingView.tvSuggestedUpdates reloadData];
}

- (BOOL)searchBarShouldSearch:(GGBaseSearchBar *)searchBar
{
    [self _searchAction:searchBar];
    return YES;
}

- (void)searchBarCanceled:(GGBaseSearchBar *)searchBar
{
    [_slideSettingView switchSearchMode:NO];
}

-(BOOL)_searchAction:(GGBaseSearchBar *)searchBar
{
    GGBlackSearchBar *blackBar = (GGBlackSearchBar *)searchBar;
    if (blackBar.tfSearch.text.length)
    {
        [self _doSearchWithKeyword:blackBar.tfSearch.text];
        //blackBar.tfSearch.text = @"";
        
        return YES;
    }
    
    return NO;
}

-(void)_doSearchWithKeyword:(NSString *)aKeyword
{
    if (aKeyword.length)
    {
        [_searchTimer invalidate];
        _searchTimer = nil;
        
        GGComUpdateSearchResultVC *vc = [[GGComUpdateSearchResultVC alloc] init];
        vc.keyword = aKeyword;
        
        
        [_slideSettingView switchSearchMode:NO];
        [_slideSettingView hideSlideOnCompletion:^{
            
        }];
        
        [self.navigationController pushViewController:vc animated:NO];
    }
}

-(void)_callApiGetSuggestions
{
    NSString *keyword = _slideSettingView.searchBar.tfSearch.text;
    if (keyword.length)
    {
        [_slideSettingView showLoadingHUD];
        id op = [GGSharedAPI getUpdateSuggestionWithKeyword:keyword callback:^(id operation, id aResultObject, NSError *anError) {
            [_slideSettingView hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [_suggestedUpdates removeAllObjects];
                NSArray *keywords = parser.dataInfos;
                for (NSDictionary *dic in keywords)
                {
                    [_suggestedUpdates addObject:[dic objectForKey:@"keywords"]];
                }
            }
            
            [self _showRecentSearches:NO];
            [_slideSettingView.tvSuggestedUpdates reloadData];
        }];
        
        [self registerOperation:op];
    }
}


#pragma mark - slide setting view delegate
-(void)slideview:(GGSlideSettingView *)aSlideView isShowed:(BOOL)aIsShowed
{
    if (![self isIPadLandscape])
    {
        [self freezeMe:aIsShowed];
    }
}

#pragma mark - notification handling
-(void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    NSString *noteName = notification.name;
    if ([noteName isEqualToString:GG_NOTIFY_LOG_OUT])
    {
        [_updates removeAllObjects];
        [self.updatesTV reloadData];
        
        [_happenings removeAllObjects];
        [self.happeningsTV reloadData];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else if ([noteName isEqualToString:GG_NOTIFY_LOG_IN])
    {
        //[self.updatesTV triggerPullToRefresh];
        [self _getInitData];
        //[self.happeningsTV triggerPullToRefresh];
    }
    else if ([noteName isEqualToString:GG_NOTIFY_MENU_REVEAL])
    {
        if (![self isIPadLandscape])
        {
            [self freezeMe:YES];
        }
    }
    else if ([noteName isEqualToString:GG_NOTIFY_MENU_COVER])
    {
        [self freezeMe:NO];
        [_slideSettingView.searchBar resignFirstResponder];
    }
    
    else if ([noteName isEqualToString:GG_NOTIFY_PAN_BEGIN])
    {
        [self blockUI];
    }
    else if ([noteName isEqualToString:GG_NOTIFY_PAN_END])
    {
        [self unblockUI];
    }
    //
}

#pragma mark - internal
-(GGSettingHeaderView *)_followingSectionView
{
    static GGSettingHeaderView *_followingSectionView;
    if (_followingSectionView == nil) {
        _followingSectionView = [GGSettingHeaderView viewFromNibWithOwner:self];
        _followingSectionView.lblTitle.text = @"FOLLOWING";
        [_followingSectionView setHightlighted:NO];
        //_followingSectionView.ivSelected.hidden = YES;
        [_followingSectionView.btnBg addTarget:self action:@selector(_followingTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_followingSectionView.btnAdd addTarget:self action:@selector(_addCompanyAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _followingSectionView.btnAdd.frame = _followingSectionView.btnConfig.frame;
        _followingSectionView.btnConfig.hidden = YES;
        //[_followingSectionView.btnConfig addTarget:self action:@selector(_configFiltersAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_followingSectionView usingFollowingStyle];
    }
    
    return _followingSectionView;
}

-(GGSettingHeaderView *)_exploringSectionView
{
    static GGSettingHeaderView *_exploringSectionView;
    if (_exploringSectionView == nil) {
        _exploringSectionView = [GGSettingHeaderView viewFromNibWithOwner:self];
        _exploringSectionView.lblTitle.text = @"EXPLORING";
        [_exploringSectionView setHightlighted:YES];
        
        _exploringSectionView.btnAdd.hidden = YES;
        [_exploringSectionView.btnBg addTarget:self action:@selector(_exploringTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _exploringSectionView.btnConfig.hidden = YES;
        //[_exploringSectionView.btnConfig addTarget:self action:@selector(_exploringConfigTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exploringSectionView;
}


-(IBAction)_configFiltersAction:(id)sender
{
    if (![self isIPadLandscape])
    {
        [_slideSettingView hideSlide];
    }
    
    GGConfigFiltersVC *vc = [[GGConfigFiltersVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)_addCompanyAction:(id)sender
{
    if (![self isIPadLandscape])
    {
        [_slideSettingView hideSlide];
    }
    
    [self searchForCompanyAction:nil];
}

-(IBAction)_followingTapped:(id)sender
{
    [self _doFollowingHideSlide:![self isIPadLandscape]];
}

-(void)_doFollowingHideSlide:(BOOL)aHideSlide
{
    self.naviTitle = @"FOLLOWING";
    
    [[self _followingSectionView] setHightlighted:YES];
    [[self _exploringSectionView] setHightlighted:NO];
    
    [self _unselectAllMenuItem];
    [_slideSettingView.viewTable reloadData];
    
    [self _refreshWithMenuId:GG_ALL_RESULT_ID type:kGGMenuTypeCompany hideSlide:aHideSlide];
}

-(IBAction)_exploringConfigTapped:(id)sender
{
    if (![self isIPadLandscape])
    {
        [_slideSettingView hideSlide];
    }
    
    [self presentPageConfigFilters];
}

-(IBAction)_exploringTapped:(id)sender
{
    [_btnSwitchUpdate switchOn:YES];
    
    [self _doExploringHideSlide:![self isIPadLandscape]];
}

-(void)_doExploringHideSlide:(BOOL)aHideSlide
{
    self.naviTitle = @"EXPLORING";
    
    [[self _followingSectionView] setHightlighted:NO];
    [[self _exploringSectionView] setHightlighted:YES];
    
    [self _unselectAllMenuItem];
    [_slideSettingView.viewTable reloadData];
    
    [self _refreshWithMenuId:GG_ALL_RESULT_ID type:kGGMenuTypeAgent hideSlide:aHideSlide];
}

-(void)_refreshWithMenuId:(long long)aMenuID type:(EGGMenuType)aType hideSlide:(BOOL)aHideSlide
{
    if (aHideSlide)
    {
        [_slideSettingView hideSlide];
    }
    
    _menuType = aType;
    _menuID = aMenuID;
    [self.updates removeAllObjects];
    [self.updatesTV reloadData];
    [self.updatesTV triggerPullToRefresh];
    
    [self.happenings removeAllObjects];
    [self.happeningsTV reloadData];
    [self.happeningsTV triggerPullToRefresh];
    
    _btnSwitchUpdate.hidden = (_menuType == kGGMenuTypeAgent);
    //[self _showRelevanceBar:YES];
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
    if (!GGSharedDelegate.rootVC.isRevealed)
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
    [self presentPageFollowCompanies];
}

//-(void)savedUpdateAction:(id)sender
//{
//    DLog(@"saved update clicked");
//    [GGAlert alert:@"Saved updates (TODO)"];
//}

-(void)companyDetailAction:(id)sender
{
    int index = ((UIButton*)sender).tag;
    GGCompanyUpdate *update = [_updates objectAtIndex:index];
    
    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
    vc.companyID = update.company.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)companyDetailForHappeningAction:(id)sender
{
    int index = ((UIButton*)sender).tag;
    GGHappening *data = _happenings[index];
    
    if (data.company.orgID > 0)
    {
        GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
        vc.companyID = data.company.orgID;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    else if (tableView == _slideSettingView.tvSuggestedUpdates)
    {
        
        
        int count = [self _suggestedUpdatesDataSource].count;
        
        //_slideSettingView.tvSuggestedUpdates.hidden = (count <= 0);
        return count + 1;   // add one extra cell
    }
    
    return 0;
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
    if (cell == nil) {
        cell = [GGCompanyUpdateCell viewFromNibWithOwner:self];
        [cell.logoBtn addTarget:self action:@selector(companyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGCompanyUpdate *updateData = self.updates[row];
    
    cell.ID = updateData.ID;
    cell.logoBtn.tag = row;
    
    cell.titleLbl.text = [updateData headlineTruncated];
    cell.sourceLbl.text = updateData.fromSource;//[NSString stringWithFormat:@"%@ · %@", updateData.fromSource, [updateData intervalStringWithDate:updateData.date]];
    
//#warning FAKE DATA - company update description
    cell.descriptionLbl.text = updateData.content;
    
    [cell.logoIV setImageWithURL:[NSURL URLWithString:updateData.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
    
    cell.intervalLbl.text = [updateData intervalStringWithDate:updateData.date];
    cell.hasBeenRead = updateData.hasBeenRead;
    [cell adjustLayout];
    
    return cell;
}

-(GGCompanyUpdateIpadCell *)_updateIpadCellForIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString *updateCellId = @"GGCompanyUpdateIpadCell";
    GGCompanyUpdateIpadCell *cell = [_updatesTV dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGCompanyUpdateIpadCell viewFromNibWithOwner:self];
        [cell.btnLogo addTarget:self action:@selector(companyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGCompanyUpdate *updateData = self.updates[row];
    
    //cell.ID = updateData.ID;
    cell.btnLogo.tag = row;
    
    cell.lblHeadline.text = [updateData headlineTruncated];
    cell.lblSource.text = updateData.fromSource;//[NSString stringWithFormat:@"%@ · %@", updateData.fromSource, [updateData intervalStringWithDate:updateData.date]];
    
    //#warning FAKE DATA - company update description
    cell.lblDescription.text = updateData.content;
    
    [cell.ivLogo setImageWithURL:[NSURL URLWithString:updateData.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
    
    cell.lblInterval.text = [updateData intervalStringWithDate:updateData.date];
    //cell.hasBeenRead = updateData.hasBeenRead;
    //[cell adjustLayout];
    
    return cell;
}

//GGCompanyUpdateIpadCell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (tableView == self.updatesTV)
    {
        if (ISIPADDEVICE)
        {
            return [self _updateIpadCellForIndexPath:indexPath];
        }
        else
        {
            return [self _updateCellForIndexPath:indexPath];
        }
    }
    else if (tableView == self.happeningsTV)
    {
        static NSString *happeningCellId = @"GGCompanyHappeningCell";
        GGCompanyHappeningCell *cell = [tableView dequeueReusableCellWithIdentifier:happeningCellId];
        if (cell == nil) {
            cell = [GGCompanyHappeningCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.btnLogo addTarget:self action:@selector(companyDetailForHappeningAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGHappening *data = _happenings[row];
        cell.tag = row;
        cell.btnLogo.tag = row;
        cell.lblName.text = data.sourceText;
        cell.lblDescription.text = data.headLineText;
        cell.lblInterval.text = [data intervalStringWithDate:data.timestamp];
        [cell.ivLogo setImageWithURL:[NSURL URLWithString:data.company.orgLogoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
        cell.hasBeenRead = data.hasBeenRead;
        
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
        GGMenuData *menuData = page.items[row];
        cell.lblInterval.text = menuData.timeInterval;
        cell.lblName.text = menuData.name;
        
        [cell setHightlighted:menuData.checked];
        
        return cell;
    }
    else if (tableView == _slideSettingView.tvSuggestedUpdates)
    {
        NSArray *dataSource = [self _suggestedUpdatesDataSource];
        if (row == dataSource.count) // extra one
        {
            return _keywordExampleView;
        }
        else
        {
            static NSString *cellID = @"suggestedUpdateCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            NSString *keyword = dataSource[row];
            cell.textLabel.text = keyword;
            
            return cell;
        }
        
    }

    return nil;
}

-(NSArray *)_suggestedUpdatesDataSource
{
    return _isShowingRecentSearches ? GGSharedRuntimeData.recentSearches : _suggestedUpdates;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (tableView == _slideSettingView.tvSuggestedUpdates)
//    {
//        return _keywordExampleView.frame.size.height;
//    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    if (tableView == _slideSettingView.tvSuggestedUpdates)
//    {
//        return _keywordExampleView;
//    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _slideSettingView.viewTable)
    {
        return [GGSettingHeaderView HEIGHT];
    }
    else if (_isShowingRecentSearches && tableView == _slideSettingView.tvSuggestedUpdates)
    {
        return [GGConfigLabel HEIGHT];
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
    else if (_isShowingRecentSearches && tableView == _slideSettingView.tvSuggestedUpdates)
    {
        GGConfigLabel *configLabel = [GGConfigLabel viewFromNibWithOwner:self];
        configLabel.lblText.text = @"Recent Searches";
        return configLabel;
    }
    
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.updatesTV)
    {
        float height = [self _updateCellHeightForIndexPath:indexPath];
        //DLog(@"table view height:%f", height);
        return height;
    }
    else if (tableView == self.happeningsTV)
    {
        return [GGCompanyHappeningCell HEIGHT];
    }
    else if (tableView == _slideSettingView.viewTable)
    {
        return [GGSettingMenuCell HEIGHT];
    }
    else if (tableView == _slideSettingView.tvSuggestedUpdates && indexPath.row == [self _suggestedUpdatesDataSource].count) // extra one
    {
        return _keywordExampleView.frame.size.height;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = indexPath.row;
    
    if (tableView == self.updatesTV)
    {
        GGCompanyUpdateDetailVC *vc = [[GGCompanyUpdateDetailVC alloc] init];
        vc.naviTitleString = self.naviTitle;
        vc.updates = self.updates;
        vc.updateIndex = row;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tableView == self.happeningsTV)
    {
        GGHappeningDetailVC *vc = [[GGHappeningDetailVC alloc] init];
        vc.happenings = _happenings;
        vc.happeningIndex = row;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tableView == _slideSettingView.viewTable)
    {
        GGDataPage *thePage = _menuDatas[indexPath.section];
        GGMenuData *theData = thePage.items[row];
        
        for (GGDataPage *page in _menuDatas) {
            BOOL isPageMatch = (thePage == page);
            for (GGMenuData *menuData in page.items) {
                menuData.checked = (isPageMatch && theData == menuData);
            }
        }
        
        self.naviTitle = theData.name;
        [[self _followingSectionView] setHightlighted:NO];
        [[self _exploringSectionView] setHightlighted:NO];
        
        [tableView reloadData];
        
        //get update data by menuID
        _menuType = theData.type;
        _menuID = theData.ID;
        
        if (theData.type == kGGMenuTypeAgent)
        {
            [_btnSwitchUpdate switchOn:YES];
        }
        
        [self _refreshWithMenuId:theData.ID type:theData.type hideSlide:![self isIPadLandscape]];
    }
    else if (tableView == _slideSettingView.tvSuggestedUpdates)
    {
        NSArray *dataSource = [self _suggestedUpdatesDataSource];
        if (row < dataSource.count)
        {
            NSString *keyword = dataSource[row];
            [self _doSearchWithKeyword:keyword];
        }
    }
}

//#pragma mark - scrolling view delegate
//-(void)scrollingView:(GGScrollingView *)aScrollingView didScrollToIndex:(NSUInteger)aPageIndex;
//{
//    DLog(@"scrolling to index:%d", aPageIndex);
//}

#pragma mark - scrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _slideSettingView.viewTable)
    {
        [_slideSettingView.searchBar resignFirstResponder];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (scrollView == _updatesTV || scrollView == _happeningsTV)
    {
        _lastContentOffset = scrollView.contentOffset;
    }
    
    GGSharedDelegate.rootVC.canBeDragged = NO;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    DLog(@"scrollView: %@ Will End Dragging, is dragging:%d", NSStringFromClass([scrollView class]), scrollView.isDragging);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    DLog(@"scrollView: %@ did End Dragging, is dragging:%d", NSStringFromClass([scrollView class]), scrollView.isDragging);
    
    GGSharedDelegate.rootVC.canBeDragged = YES;
}


-(void)_adjustTvFrames
{
    CGRect thisRc = self.view.bounds;
    //[self.view centerMeHorizontally];
    
    CGRect relevanceRc = _relevanceBar.frame;
    relevanceRc.size.width = _relevanceBar.superview.frame.size.width;
    _relevanceBar.frame = relevanceRc;
    
    CGRect updateRc = _updatesTV.frame;
    updateRc.origin.y = CGRectGetMaxY(_relevanceBar.frame);
    updateRc.size.width = self.view.bounds.size.width;
    updateRc.size.height = self.view.bounds.size.height - updateRc.origin.y;
    _updatesTV.frame = updateRc;
    
    CGRect happeningRc = _happeningsTV.frame;
    happeningRc.size.width = self.view.bounds.size.width;
    happeningRc.size.height = self.view.bounds.size.height - happeningRc.origin.y;
    _happeningsTV.frame = happeningRc;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    if (!ISIPADDEVICE && scrollView.contentSize.height > scrollView.frame.size.height)
    {
        if (_lastContentOffset.y < scrollView.contentOffset.y)
        {
            //DLog(@"moved up");
            
            if (scrollView == _updatesTV)
            {
                [self _showRelevanceBar:NO];
            }
            
            [GGUtils hideTabBar];
        }
        else
        {
            //DLog(@"moved down");
            
            if (scrollView == _updatesTV)
            {
                [self _showRelevanceBar:YES];
            }
            
            [GGUtils showTabBar];
        }
        
        [self _adjustTvFrames];
    }
}

-(void)_showRelevanceBar:(BOOL)aShow
{
    //_isRelevanceBarShowing = aShow;
    float kAnimInterval = .3f;
    if (aShow)
    {
        [UIView animateWithDuration:kAnimInterval delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _relevanceBar.frame = [self _relevanceFrameHided:NO];
           // _relevanceBar.alpha = 1.f;
            
        } completion:^(BOOL finished){
            //_updatesTV.frame = _updateTvRect;
        }];
    }
    else
    {
        [UIView animateWithDuration:kAnimInterval delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
           _relevanceBar.frame = [self _relevanceFrameHided:YES];
            //_relevanceBar.alpha = 0.5f;
            
        } completion:^(BOOL finished){
//            CGRect tvRc = _updateTvRect;
//            tvRc.origin.y = [self _relevanceFrameHided:NO].origin.y;
//            tvRc.size.height += [self _relevanceFrameHided:NO].size.height;
//            _updatesTV.frame = tvRc;
        }];
    }
}


#pragma mark - data handling
-(void)_getInitData
{
    id op = [GGSharedAPI getMenuByType:kGGStrMenuTypeCompanies callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _menuDatas = [parser parseGetMenu:YES];
            GGDataPage *page = _menuDatas[0];   //following
            if (page.items.count)
            {
                _menuType = kGGMenuTypeCompany;
            }
        }
        
        if (_menuType == kGGMenuTypeCompany)
        {
            [self _doFollowingHideSlide:NO];
        }
        else
        {
            [self _doExploringHideSlide:NO];
        }
        
        //[UIView setAnimationsEnabled:YES];
    }];
    
    [self registerOperation:op];
}

-(void)_callApiGetMenu
{
    [_slideSettingView showLoadingHUD];
    id op = [GGSharedAPI getMenuByType:kGGStrMenuTypeCompanies callback:^(id operation, id aResultObject, NSError *anError) {
        [_slideSettingView hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _menuDatas = [parser parseGetMenu:YES];
            
            if (_menuID == GG_ALL_RESULT_ID)
            {
                [self _unselectAllMenuItem];
                
                BOOL isMenuCompany = (_menuType == kGGMenuTypeCompany);
                [[self _followingSectionView] setHightlighted:isMenuCompany];
                [[self _exploringSectionView] setHightlighted:!isMenuCompany];

            }
            else
            {
                [self _selectMenuItemByID:_menuID];
                
                [[self _followingSectionView] setHightlighted:NO];
                [[self _exploringSectionView] setHightlighted:NO];

            }
            
            [_slideSettingView.viewTable reloadData];
        }
        else
        {
            _menuDatas = nil;
            [GGAlert alertWithApiParser:parser];
        }
    }];
    
    [self registerOperation:op];
}

-(void)_getFirstPage
{
    [self _getDataWithNewsID:0 pageFlag:kGGPageFlagFirstPage pageTime:0 relevance:_relevance];
}

-(void)_getNextPage
{
    if (_hasMoreUpdates)
    {
        long long newsID = 0, pageTime = 0;
        GGCompanyUpdate *lastUpdate = [_updates lastObject];
        if (lastUpdate)
        {
            newsID = lastUpdate.ID;
            pageTime = lastUpdate.date;
            
            [self _getDataWithNewsID:newsID pageFlag:kGGPageFlagMoveDown pageTime:pageTime relevance:_relevance];
        }
    }
    else
    {
        [self _delayedStopInfiniteAnimating];
    }
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

        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyUpdates];
        
        [_viewUpdateEmpty removeFromSuperview];
        
        if (parser.isOK)
        {
            _hasMoreUpdates = page.hasMore;
            
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
        }
        else if (parser.status == kGGApiStatusUserOperationError)
        {
            _viewUpdateEmpty = [GGEmptyActionView viewFromNibWithOwner:self];
            _viewUpdateEmpty.frame = self.view.bounds;
            [_viewUpdateEmpty setMessageCode:parser vc:self];

            [_updatesTV addSubview:_viewUpdateEmpty];
        }
        
        [self.updatesTV reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    };
    
    //[self showLoadingHUD];
    if (_menuType == kGGMenuTypeCompany)
    {
        id op = [GGSharedAPI getCompanyUpdatesWithCompanyID:_menuID newsID:aNewsID pageFlag:aPageFlag pageTime:aPageTime relevance:aRelevance callback:callback];
        [self registerOperation:op];
    }
    else if (_menuType == kGGMenuTypeAgent)
    {
        id op = [GGSharedAPI getCompanyUpdatesWithAgentID:_menuID newsID:aNewsID pageFlag:aPageFlag pageTime:aPageTime relevance:aRelevance callback:callback];
        [self registerOperation:op];
    }
}

#pragma mark -
-(void)_getFirstHappeningPage
{
    [self _getHappeningsDataWithPageFlag:kGGPageFlagFirstPage pageTime:0 eventID:0];
}

-(void)_getNextHappeningPage
{
    if (_hasMoreHappenings)
    {
        long long happeningID = 0, pageTime = 0;
        GGHappening *lastHappening = [_happenings lastObject];
        if (lastHappening)
        {
            happeningID = lastHappening.ID;
            pageTime = lastHappening.timestamp;
        }
        
        [self _getHappeningsDataWithPageFlag:kGGPageFlagMoveDown pageTime:pageTime eventID:happeningID];
    }
    else
    {
        [self _delayedStopHappeningInfiniteAnimating];
    }
}

-(void)_getHappeningsDataWithPageFlag:(int)aPageFlag pageTime:(long long)aPageTime eventID:(long long)anEventID
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {

        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyHappenings];
        
        [_viewHappeningEmpty removeFromSuperview];
        
        if (parser.isOK)
        {
            _hasMoreHappenings = page.hasMore;
            
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
        }
        else if (parser.status == kGGApiStatusUserOperationError)
        {
            _viewHappeningEmpty = [GGEmptyActionView viewFromNibWithOwner:self];
            _viewHappeningEmpty.frame = self.view.bounds;
            [_viewHappeningEmpty setMessageCode:parser vc:self];
            
            [_happeningsTV addSubview:_viewHappeningEmpty];
        }
        
        [self.happeningsTV reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopHappeningAnimating) withObject:nil afterDelay:.5f];
    };
    
    if (_menuType == kGGMenuTypeCompany)
    {
        id op = [GGSharedAPI getHappeningsWithCompanyID:_menuID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
        [self registerOperation:op];
    }
    else if (_menuType == kGGMenuTypeAgent)
    {
        [self performSelector:@selector(_delayedStopHappeningAnimating) withObject:nil afterDelay:.5f];
    }
}

#pragma mark - stop animation

-(void)_delayedStopAnimating
{
    [self _delayedStopRefreshAnimating];
    [self _delayedStopInfiniteAnimating];
}

-(void)_delayedStopRefreshAnimating
{
    __weak GGCompaniesVC *weakSelf = self;
    [weakSelf.updatesTV.pullToRefreshView stopAnimating];
}

-(void)_delayedStopInfiniteAnimating
{
    __weak GGCompaniesVC *weakSelf = self;
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
}

-(void)_delayedStopHappeningAnimating
{
    __weak GGCompaniesVC *weakSelf = self;
    [weakSelf.happeningsTV.pullToRefreshView stopAnimating];
    [weakSelf.happeningsTV.infiniteScrollingView stopAnimating];
}

-(void)_delayedStopHappeningRefreshAnimating
{
    __weak GGCompaniesVC *weakSelf = self;
    [weakSelf.happeningsTV.pullToRefreshView stopAnimating];
}

-(void)_delayedStopHappeningInfiniteAnimating
{
    __weak GGCompaniesVC *weakSelf = self;
    [weakSelf.happeningsTV.infiniteScrollingView stopAnimating];
}

#pragma mark -
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    //CGRect orientRc = [GGUtils frameWithOrientation:toInterfaceOrientation rect:[UIScreen mainScreen].bounds];
    self.navigationItem.leftBarButtonItem = nil;
    //static BOOL isMenuShowingBeforeChangeToLandscape = NO;
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        [self _installMenuButton];
    }
    else
    {
        [self _callApiGetMenu];
    }
    
    [self _adjustSelfFrameForIpadWithOrient:toInterfaceOrientation];
    
    [self _adjustTvFrames];
    
    [_updatesTV reloadData];
    [_happeningsTV reloadData];
    
    CGRect relevanceRc = [self _relevanceFrameHided:NO];
    _relevanceBar.frame = relevanceRc;
}

-(void)_adjustSelfFrameForIpadWithOrient:(UIInterfaceOrientation)anOrient
{
    if (ISIPADDEVICE)
    {
        CGRect theFrame = [GGLayout frameWithOrientation:anOrient rect:[GGLayout screenFrame]];
        theFrame.size.height -= [GGLayout statusHeight] + [GGLayout navibarFrame].size.height + [GGLayout tabbarFrame].size.height;
        if (UIInterfaceOrientationIsLandscape(anOrient))
        {
            theFrame.size.width -= SLIDE_SETTING_VIEW_WIDTH;
        }
        
        self.view.frame = theFrame;
    }
}

@end
