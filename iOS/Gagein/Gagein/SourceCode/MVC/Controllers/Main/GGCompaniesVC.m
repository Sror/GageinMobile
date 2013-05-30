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

#define SWITCH_WIDTH 90
#define SWITCH_HEIGHT 20

@interface GGCompaniesVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@property (nonatomic, strong) UITableView *happeningsTV;

@end

@implementation GGCompaniesVC
{
    EGGCompanyUpdateRelevance   _relevance;
    
    GGSlideSettingView          *_slideSettingView;
    GGRelevanceBar              *_relevanceBar;
    
    GGEmptyActionView                 *_viewUpdateEmpty;
    GGEmptyActionView                 *_viewHappeningEmpty;
    
    GGSwitchButton             *_btnSwitchUpdate;
    BOOL                       _isShowingUpdate;
    
    NSArray                    *_menuDatas;
    
    EGGMenuType                _menuType;
    long long                  _menuID;
    
    CGPoint                     _lastContentOffset;
    
    CGRect                      _relevanceRectShow;
    CGRect                      _relevanceRectHide;
    CGRect                      _updateTvRect;
    
    NSTimer                     *_searchTimer;
    NSMutableArray              *_suggestedUpdates;
    GGKeywordExampleCell        *_keywordExampleView;
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
    CGRect naviRc = self.navigationController.navigationBar.frame;
    
    _btnSwitchUpdate = [GGSwitchButton viewFromNibWithOwner:self];
    _btnSwitchUpdate.delegate = self;
    _btnSwitchUpdate.lblOn.text = @"Updates";
    _btnSwitchUpdate.lblOff.text = @"Happenings";
    _btnSwitchUpdate.isOn = _isShowingUpdate;
    
    CGRect switchRc = CGRectMake(naviRc.size.width - SWITCH_WIDTH - 5
                                 , (naviRc.size.height - [GGSwitchButton HEIGHT]) / 2 + 5
                                 , SWITCH_WIDTH
                                 , [GGSwitchButton HEIGHT]);
    _btnSwitchUpdate.frame = switchRc;
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
    self.view.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"EXPLORING";
    
    [self _initRoundSwitch];

    [self _initSlideSettingView];
    
    _relevanceBar = [GGRelevanceBar viewFromNibWithOwner:self];
    _relevanceRectShow = CGRectOffset(_relevanceBar.frame, 0, 5);
    _relevanceRectHide = CGRectOffset(_relevanceRectShow, 0, -_relevanceBar.frame.size.height);
    _relevanceBar.frame = _relevanceRectShow;
    [self.view addSubview:_relevanceBar];
    _relevanceBar.btnSwitch.delegate = self;
    _relevanceBar.btnSwitch.lblOn.text = @"High";
    _relevanceBar.btnSwitch.lblOff.text = @"Medium";
    _relevanceBar.btnSwitch.isOn = YES;
    
     _updateTvRect = [self viewportAdjsted];
    
    self.happeningsTV = [[UITableView alloc] initWithFrame:_updateTvRect style:UITableViewStylePlain];
    self.happeningsTV.dataSource = self;
    self.happeningsTV.delegate = self;
    self.happeningsTV.backgroundColor = GGSharedColor.silver;
    self.happeningsTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.happeningsTV.hidden = YES;
    [self.view addSubview:self.happeningsTV];
    
    _updateTvRect.origin.y = CGRectGetMaxY(_relevanceBar.frame) - 5;
    _updateTvRect.size.height = self.view.frame.size.height - _updateTvRect.origin.y;
    self.updatesTV = [[UITableView alloc] initWithFrame:_updateTvRect style:UITableViewStylePlain];
    self.updatesTV.dataSource = self;
    self.updatesTV.delegate = self;
    self.updatesTV.backgroundColor = GGSharedColor.silver;
    self.updatesTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.updatesTV];

    
    [self.view bringSubviewToFront:_relevanceBar];
    
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
    
    [self _getInitData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_btnSwitchUpdate removeFromSuperview];
    
    [GGSharedDelegate.rootVC enableSwipGesture:NO];
    [GGSharedDelegate.rootVC enableTapGesture:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // show/hide switch button
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
    //[_btnSwitchUpdate.superview bringSubviewToFront:_btnSwitchUpdate];
    
    [self _callApiGetMenu];
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
    _slideSettingView.tvSuggestedUpdates.hidden = YES;
    
    return YES;
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
            
            [_slideSettingView.tvSuggestedUpdates reloadData];
        }];
        
        [self registerOperation:op];
    }
}


#pragma mark - slide setting view delegate
-(void)slideview:(GGSlideSettingView *)aSlideView isShowed:(BOOL)aIsShowed
{
    self.view.userInteractionEnabled = !aIsShowed;
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
    }
    else if ([noteName isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self.updatesTV triggerPullToRefresh];
        [self.happeningsTV triggerPullToRefresh];
    }
    else if ([noteName isEqualToString:GG_NOTIFY_MENU_REVEAL])
    {
        self.view.userInteractionEnabled = NO;
    }
    else if ([noteName isEqualToString:GG_NOTIFY_MENU_COVER])
    {
        self.view.userInteractionEnabled = YES;
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
        [_followingSectionView.btnConfig addTarget:self action:@selector(_configFiltersAction:) forControlEvents:UIControlEventTouchUpInside];
        
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
        //_exploringSectionView.ivSelected.hidden = NO;
        _exploringSectionView.btnAdd.hidden = YES;
        [_exploringSectionView.btnBg addTarget:self action:@selector(_exploringTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_exploringSectionView.btnConfig addTarget:self action:@selector(_exploringConfigTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exploringSectionView;
}


-(IBAction)_configFiltersAction:(id)sender
{
    [_slideSettingView hideSlide];
    GGConfigFiltersVC *vc = [[GGConfigFiltersVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)_addCompanyAction:(id)sender
{
    [_slideSettingView hideSlide];
    [self searchForCompanyAction:nil];
}

-(IBAction)_followingTapped:(id)sender
{
    self.naviTitle = @"FOLLOWING";
    
    [[self _followingSectionView] setHightlighted:YES];
    [[self _exploringSectionView] setHightlighted:NO];
    
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
    self.naviTitle = @"EXPLORING";
    
    [[self _followingSectionView] setHightlighted:NO];
    [[self _exploringSectionView] setHightlighted:YES];
    
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
    
    _btnSwitchUpdate.hidden = (_menuType == kGGMenuTypeAgent);
    [self _showRelevanceBar:YES];
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
    else if (tableView == _slideSettingView.tvSuggestedUpdates)
    {
        int count = _suggestedUpdates.count;
        _slideSettingView.tvSuggestedUpdates.hidden = (count <= 0);
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
    
    cell.titleLbl.text = updateData.headline;//[updateData headlineMaxCharCount:90];
    cell.sourceLbl.text = updateData.fromSource;//[NSString stringWithFormat:@"%@ · %@", updateData.fromSource, [updateData intervalStringWithDate:updateData.date]];
    
//#warning FAKE DATA - company update description
    cell.descriptionLbl.text = updateData.content;
    
    [cell.logoIV setImageWithURL:[NSURL URLWithString:updateData.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
    
    cell.intervalLbl.text = [updateData intervalStringWithDate:updateData.date];
    cell.hasBeenRead = updateData.hasBeenRead;
    [cell adjustLayout];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (tableView == self.updatesTV)
    {
        return [self _updateCellForIndexPath:indexPath];
    }
    else if (tableView == self.happeningsTV)
    {
        static NSString *happeningCellId = @"GGCompanyHappeningCell";
        GGCompanyHappeningCell *cell = [tableView dequeueReusableCellWithIdentifier:happeningCellId];
        if (cell == nil) {
            cell = [GGCompanyHappeningCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGHappening *data = _happenings[row];
        cell.tag = row;
        cell.lblName.text = data.sourceText;
        cell.lblDescription.text = data.headLineText;
        cell.lblInterval.text = [data intervalStringWithDate:data.timestamp];
        [cell.ivLogo setImageWithURL:[NSURL URLWithString:data.orgLogoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
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
        if (row == _suggestedUpdates.count) // extra one
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
            
            NSString *keyword = _suggestedUpdates[row];
            cell.textLabel.text = keyword;
            
            return cell;
        }
        
    }

    return nil;
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
    else if (tableView == _slideSettingView.tvSuggestedUpdates && indexPath.row == _suggestedUpdates.count) // extra one
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
        
        [self _refreshWithMenuId:theData.ID type:theData.type];
    }
    else if (tableView == _slideSettingView.tvSuggestedUpdates)
    {
        if (row < _suggestedUpdates.count)
        {
            NSString *keyword = _suggestedUpdates[row];
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
    
    if (scrollView == _updatesTV)
    {
        _lastContentOffset = scrollView.contentOffset;
    }
    
    GGSharedDelegate.rootVC.canBeDragged = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    GGSharedDelegate.rootVC.canBeDragged = YES;
}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _updatesTV)
    {
        if (_lastContentOffset.y < (int)scrollView.contentOffset.y) {
            DLog(@"moved up");
            
            [self _showRelevanceBar:NO];
            
        }
        else
        {
            DLog(@"moved down");
            
            [self _showRelevanceBar:YES];

        }
    }
}

-(void)_showRelevanceBar:(BOOL)aShow
{
    if (aShow)
    {
        [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _relevanceBar.frame = _relevanceRectShow;
            
            _updatesTV.frame = _updateTvRect;
            
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _relevanceBar.frame = _relevanceRectHide;
            
            CGRect tvRc = _updateTvRect;
            tvRc.origin.y = _relevanceRectShow.origin.y;
            tvRc.size.height += _relevanceRectShow.size.height;
            _updatesTV.frame = tvRc;
            
        } completion:nil];
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
            [self _followingTapped:nil];
        }
        else
        {
            [self _exploringTapped:nil];
        }
    }];
    
    [self registerOperation:op];
}

-(void)_callApiGetMenu
{
    //[_slideSettingView showLoadingHUD];
    id op = [GGSharedAPI getMenuByType:kGGStrMenuTypeCompanies callback:^(id operation, id aResultObject, NSError *anError) {
        //[_slideSettingView hideLoadingHUD];
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
            [GGAlert alertWithApiMessage:parser.message];
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
    long long newsID = 0, pageTime = 0;
    GGCompanyUpdate *lastUpdate = [_updates lastObject];
    if (lastUpdate)
    {
        newsID = lastUpdate.ID;
        pageTime = lastUpdate.date;
        
        [self _getDataWithNewsID:newsID pageFlag:kGGPageFlagMoveDown pageTime:pageTime relevance:_relevance];
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
            
//            if (_updates.count)
//            {
//                [_viewUpdateEmpty removeFromSuperview];
//            }
//            else
//            {
//                [_updatesTV addSubview:_viewUpdateEmpty];
//            }
        }
        else if (parser.status == kGGApiStatusUserOperationError)
        {
            _viewUpdateEmpty = [GGEmptyActionView viewFromNibWithOwner:self];
            _viewUpdateEmpty.frame = self.view.bounds;
            //[_viewUpdateEmpty setMessageCode:parser.messageCode];
            [_viewUpdateEmpty setMessageCode:parser vc:self];
            
            //_viewUpdateEmpty = _emptyView;
            [_updatesTV addSubview:_viewUpdateEmpty];
        }
        
        //[self _installEmptyViewToUpdateTV:YES];
        
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

//-(void)_installEmptyViewToUpdateTV:(BOOL)aIsUpdate // 'aIsUpdate' means if the context is an update or a happening
//{
//    //
//    aIsUpdate ? [_viewUpdateEmpty removeFromSuperview] : [_viewHappeningEmpty removeFromSuperview];
//    if ((aIsUpdate &&_updates.count) || (!aIsUpdate && _happenings.count))
//    {
//        return;
//    }
//    
//    GGEmptyActionView *emptyView = [GGEmptyActionView viewFromNibWithOwner:self];
//    emptyView.frame = self.view.bounds;
//    emptyView.viewSimple.hidden = YES;
//    aIsUpdate ? [_updatesTV addSubview:emptyView] : [_happeningsTV addSubview:emptyView];
//    
//    emptyView.lblTitle.text = @"Have trouble seeing updates?";
//    
//    if (_menuType == kGGMenuTypeCompany)
//    {
//        if (((GGDataPage *)_menuDatas[0]).items.count <= 0)
//        {
//            emptyView.lblMessage.text = @"Add companies to watch for important updates.";
//            [emptyView.btnAction addTarget:self action:@selector(_addCompanyAction:) forControlEvents:UIControlEventTouchUpInside];
//            [emptyView.btnAction setTitle:@"Add Companies to Follow" forState:UIControlStateNormal];
//        }
//        else
//        {
//            emptyView.viewSimple.hidden = NO;
//            if (aIsUpdate)
//            {
//                emptyView.lblSimpleMessage.text = @"In the last 7 days, there were no triggers found for your followed companies.";
//            }
//            else
//            {
//                emptyView.lblSimpleMessage.text = @"No happenings found for your followed companies as of this new feature launch in May 2013";
//            }
//        }
//    }
//    else if (_menuType == kGGMenuTypeAgent)
//    {
//        emptyView.lblMessage.text = @"Select sales triggers to explore new opportunities.";
//        [emptyView.btnAction addTarget:self action:@selector(_exploringConfigTapped:) forControlEvents:UIControlEventTouchUpInside];
//        [emptyView.btnAction setTitle:@"Select Sales Triggers" forState:UIControlStateNormal];
//    }
//    
//    aIsUpdate ? (_viewUpdateEmpty = emptyView) : (_viewHappeningEmpty = emptyView);
//}

#pragma mark -
-(void)_getFirstHappeningPage
{
    [self _getHappeningsDataWithPageFlag:kGGPageFlagFirstPage pageTime:0 eventID:0];
}

-(void)_getNextHappeningPage
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

-(void)_getHappeningsDataWithPageFlag:(int)aPageFlag pageTime:(long long)aPageTime eventID:(long long)anEventID
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {

        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyHappenings];
        
        [_viewHappeningEmpty removeFromSuperview];
        
        if (parser.isOK)
        {
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
            //[_viewHappeningEmpty setMessageCode:parser.messageCode];
            [_viewHappeningEmpty setMessageCode:parser vc:self];
            
            //_viewHappeningEmpty = _emptyView;
            [_happeningsTV addSubview:_viewHappeningEmpty];
        }
        
        //[self _installEmptyViewToUpdateTV:NO];
        
        [self.happeningsTV reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopHappeningAnimating) withObject:nil afterDelay:.5f];
    };
    
    //[self showLoadingHUD];
    if (_menuType == kGGMenuTypeCompany)
    {
        id op = [GGSharedAPI getHappeningsWithCompanyID:_menuID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
        [self registerOperation:op];
    }
    else if (_menuType == kGGMenuTypeAgent)
    {
//#warning no happenings for agent!
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
