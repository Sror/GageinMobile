//
//  GGPeopleVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGPeopleVC.h"
#import "SVPullToRefresh.h"
#import "GGDataPage.h"
#import "GGMenuData.h"

#import "GGSettingHeaderView.h"
#import "GGSettingMenuCell.h"
#import "GGSearchBar.h"
#import "GGAppDelegate.h"

#import "GGCompanyHappeningCell.h"
#import "GGHappening.h"
#import "GGFollowPeopleVC.h"
#import "GGPersonDetailVC.h"
#import "GGHappeningDetailVC.h"
#import "GGSelectFuncAreasVC.h"
#import "GGEmptyActionView.h"

#import "GGTableViewExpandHelper.h"
#import "GGHappeningIpadCell.h"

@interface GGPeopleVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@end

@implementation GGPeopleVC
{
    GGSlideSettingView                  *_slideSettingView;
    GGEmptyActionView                   *_viewUpdateEmpty;
    
    NSArray                             *_menuDatas;
    EGGMenuType                         _menuType;
    long long                           _menuID;
    
    //CGPoint                             _lastContentOffset;
    
    BOOL                                _hasMore;
    
    GGTableViewExpandHelper             *_happeningTvExpandHelper;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _updates = [NSMutableArray array];
        _happeningTvExpandHelper = [[GGTableViewExpandHelper alloc] init];
        _menuType = kGGMenuTypeFunctionalArea;   // exploring...
        _menuID = GG_ALL_RESULT_ID;
    }
    return self;
}

-(void)_initSlideSettingView
{
    _slideSettingView = GGSharedDelegate.slideSettingView;
    _slideSettingView.delegate = self;
    
    _slideSettingView.searchBar.tfSearch.placeholder = @"Search for updates";
    [_slideSettingView changeDelegate:self];
}

-(void)_installMenuButton
{
    //UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(optionMenuAction:)];
    
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

- (void)viewDidLoad
{
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
    [self observeNotification:GG_NOTIFY_MENU_REVEAL];
    [self observeNotification:GG_NOTIFY_MENU_COVER];
    [self observeNotification:GG_NOTIFY_PERSON_FOLLOW_CHANGED];
    [self observeNotification:GG_NOTIFY_FUNC_ROLE_CHANGED];
    
    [super viewDidLoad];
    
    [self _installMenuButton];
    self.naviTitle = @"Exploring";
    
    [self _initSlideSettingView];
    
    CGRect updateRc = [self viewportAdjsted];
    
    self.updatesTV = [[UITableView alloc] initWithFrame:updateRc style:UITableViewStylePlain];
    
    self.updatesTV.dataSource = self;
    self.updatesTV.delegate = self;
    _updatesTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[_scrollingView addPage:self.updatesTV];
    self.updatesTV.backgroundColor = GGSharedColor.silver;
    _happeningTvExpandHelper.tableView = _updatesTV;
    [self.view addSubview:self.updatesTV];
    [self addScrollToHide:_updatesTV];
    
    // setup pull-to-refresh and infinite scrolling
    __weak GGPeopleVC *weakSelf = self;
    
    [self.updatesTV addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [self.updatesTV addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    //[self.updatesTV triggerPullToRefresh];
    [self _getInitData];
    [self _callApiGetMenu];
}

-(BOOL)doNeedMenu
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self adjustScrollViewFrames];
    
    // change menu to people type
    [_slideSettingView changeDelegate:self];
    _slideSettingView.viewTable.tableHeaderView = nil;
    
    
    [GGSharedDelegate.rootVC enableSwipGesture:YES];
    
    [_updatesTV reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GGSharedDelegate.rootVC enableSwipGesture:NO];
}

- (void)viewDidUnload {
    [_updates removeAllObjects];
    [super viewDidUnload];
}

-(void)dealloc
{
    [self unobserveAllNotifications];
}

#pragma mark - UISearchBar delegate
-(BOOL)_searchAction:(UISearchBar *)searchBar
{
    return NO;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self _searchAction:searchBar];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self _searchAction:searchBar];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
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
    }
    else if ([noteName isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self.updatesTV triggerPullToRefresh];
    }
    else if ([noteName isEqualToString:GG_NOTIFY_MENU_REVEAL])
    {
        //self.view.userInteractionEnabled = NO;
        if (![self isIPadLandscape])
        {
            [self freezeMe:YES];
        }
    }
    else if ([noteName isEqualToString:GG_NOTIFY_MENU_COVER])
    {
        //self.view.userInteractionEnabled = YES;
        [self freezeMe:NO];
        [_slideSettingView.searchBar resignFirstResponder];
    }
    
    else if ([noteName isEqualToString:GG_NOTIFY_PERSON_FOLLOW_CHANGED]
             || [noteName isEqualToString:GG_NOTIFY_FUNC_ROLE_CHANGED])
    {
        [self _callApiGetMenu];
    }
}

#pragma mark - internal
-(GGSettingHeaderView *)_followingSectionView
{
    static GGSettingHeaderView *_followingSectionView;
    if (_followingSectionView == nil) {
        _followingSectionView = [GGSettingHeaderView viewFromNibWithOwner:self];
        _followingSectionView.lblTitle.text = @"FOLLOWING";
        [_followingSectionView setHightlighted:NO];
        
        [_followingSectionView.btnBg addTarget:self action:@selector(_followingTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_followingSectionView.btnAdd addTarget:self action:@selector(_addPersonAction:) forControlEvents:UIControlEventTouchUpInside];
        _followingSectionView.btnConfig.hidden = YES;
        //_followingSectionView.btnAdd.frame = _followingSectionView.btnConfig.frame;
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
        [_exploringSectionView.btnConfig addTarget:self action:@selector(_exploringConfigTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exploringSectionView;
}


-(IBAction)_addPersonAction:(id)sender
{
    if (![self isIPadLandscape])
    {
        [_slideSettingView hideSlide];
    }
    
    [self presentPageFollowPeople];
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
    
    [self _refreshWithMenuId:GG_ALL_RESULT_ID type:kGGMenuTypePerson hideSlide:aHideSlide];
}

-(IBAction)_exploringConfigTapped:(id)sender
{
    if (![self isIPadLandscape])
    {
        [_slideSettingView hideSlide];
    }
    
    [self presentPageSelectFuncArea];
}

-(IBAction)_exploringTapped:(id)sender
{
    [self _doExploringHideSlide:![self isIPadLandscape]];
}

-(void)_doExploringHideSlide:(BOOL)aHideSlide
{
    self.naviTitle = @"EXPLORING";
    
    [[self _followingSectionView] setHightlighted:NO];
    [[self _exploringSectionView] setHightlighted:YES];
    
    [self _unselectAllMenuItem];
    [_slideSettingView.viewTable reloadData];
    
    [self _refreshWithMenuId:GG_ALL_RESULT_ID type:kGGMenuTypeFunctionalArea hideSlide:aHideSlide];
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
        //[self _callApiGetMenu];
    }
    else
    {
        [_slideSettingView hideSlide];
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
    else if (tableView == _slideSettingView.viewTable)
    {
        GGDataPage *page = _menuDatas[section];
        return page.items.count;
    }
    
    return 0;
}

-(void)_enterPersonDetailAction:(UIButton *)aButton
{
    GGHappening *data = self.updates[aButton.tag];
    
    [self enterPersonDetailWithID:data.person.ID];
}



-(float)_happeningIpadCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return [self _happeningCellForIPadWithIndexPath:indexPath].frame.size.height;
}

-(GGHappeningIpadCell *)_happeningCellForIPadWithIndexPath:(NSIndexPath *)aIndexPath
{
    int row = aIndexPath.row;
    
    //static NSString *updateCellId = @"GGHappeningIpadCell";
    GGHappeningIpadCell *cell = nil;//[_happeningsTV dequeueReusableCellWithIdentifier:updateCellId];;
    
    //
    GGTagetActionPair *action = [GGTagetActionPair pairWithTaget:self action:@selector(_enterPersonDetailAction:)];
    cell = [GGFactory cellOfHappeningIpad:cell
                                     data:_updates[row]
                                dataIndex:row
                              expandIndex:_happeningTvExpandHelper.expandingIndex
                            isTvExpanding:_happeningTvExpandHelper.isExpanding
                               logoAction:action
                       isCompanyHappening:NO];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (tableView == self.updatesTV)
    {
        if (ISIPADDEVICE)
        {
            return [self _happeningCellForIPadWithIndexPath:indexPath];
        }
        
        static NSString *updateCellId = @"GGCompanyHappeningCell";
        GGCompanyHappeningCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
        
        GGTagetActionPair *action = [GGTagetActionPair pairWithTaget:self action:@selector(_enterPersonDetailAction:)];
        cell = [GGFactory cellOfHappening:cell data:_updates[row] dataIndex:row logoAction:action isCompanyHappening:NO];
        
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

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _updatesTV)
    {
//        if (indexPath.row == 0)
//        {
//            [_happeningTvExpandHelper resetCellHeights];
//        }
        
        float height = ISIPADDEVICE ? [self _happeningIpadCellHeightForIndexPath:indexPath] : [GGCompanyHappeningCell HEIGHT];
        //[_happeningTvExpandHelper recordCellHeight:height];
        return height;
    }
    else if (tableView == _slideSettingView.viewTable)
    {
        return [GGSettingMenuCell HEIGHT];
    }
    
    return 0.f;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPADDEVICE)
    {
        if (indexPath.row == _happeningTvExpandHelper.expandingIndex)
        {
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = indexPath.row;
    
    if (tableView == self.updatesTV)
    {
        if (ISIPADDEVICE)
        {
            //NSIndexPath *oldIdxPath = _expandIndexPathForHappeningTV;
            NSUInteger oldIndex = _happeningTvExpandHelper.expandingIndex;
            //BOOL oldIsExpanding = _happeningTvExpandHelper.isExpanding;
            
            [_happeningTvExpandHelper changeExpaningAt:row];
            
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
            //[_happeningTvExpandHelper scrollToCenterFrom:oldIndex to:row oldIsExpanding:oldIsExpanding];
            
            [tableView endUpdates];
        }
        else
        {
            [self _enterHappeningDetailAt:row];
        }

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
        
        [self _refreshWithMenuId:theData.ID type:theData.type hideSlide:![self isIPadLandscape]];
    }
}

-(void)_enterHappeningDetailAction:(id)sender
{
    [self _enterHappeningDetailAt:(((UIView *)sender).tag)];
}

-(void)_enterHappeningDetailAt:(NSUInteger)aIndex
{
    GGHappeningDetailVC *vc = [[GGHappeningDetailVC alloc] init];
    vc.isPeopleHappening = YES;
    vc.happenings = _updates;
    vc.happeningIndex = aIndex;
    
    GGHappening *data = _updates[aIndex];
    data.hasBeenRead = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - data handling
-(void)_getInitData
{
    id op = [GGSharedAPI getMenuByType:kGGStrMenuTypePeople callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _menuDatas = [parser parseGetMenu:YES];
            GGDataPage *page = _menuDatas[0];   //following
            if (page.items.count)
            {
                _menuType = kGGMenuTypePerson;
            }
        }
        
        if (_menuType == kGGMenuTypePerson)
        {
            [self _doFollowingHideSlide:NO];
        }
        else
        {
            [self _doExploringHideSlide:NO];
        }
    }];
    
    [self registerOperation:op];
}

-(void)_callApiGetMenu
{
    //[_slideSettingView showLoadingHUD];
    id op = [GGSharedAPI getMenuByType:kGGStrMenuTypePeople callback:^(id operation, id aResultObject, NSError *anError) {
        //[_slideSettingView hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _menuDatas = [parser parseGetMenu:NO];
            
            if (_menuID == GG_ALL_RESULT_ID)
            {
                [self _unselectAllMenuItem];
                
                BOOL isMenuTypePerson = (_menuType == kGGMenuTypePerson);
                [[self _followingSectionView] setHightlighted:isMenuTypePerson];
                [[self _exploringSectionView] setHightlighted:!isMenuTypePerson];
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
    [self _getDataWithPageFlag:kGGPageFlagFirstPage pageTime:0 eventID:0];
}

-(void)_getNextPage
{
    if (_hasMore)
    {
        long long happeningID = 0, pageTime = 0;
        GGHappening *lastOne = [_updates lastObject];
        if (lastOne)
        {
            happeningID = lastOne.ID;
            pageTime = lastOne.timestamp;
            
            [self _getDataWithPageFlag:kGGPageFlagMoveDown pageTime:pageTime eventID:happeningID];
        }
    }
    else
    {
        [self _delayedStopInfiniteAnimating];
    }
}

-(void)_getDataWithPageFlag:(int)aPageFlag pageTime:(long long)aPageTime eventID:(long long)anEventID
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyHappenings];
        
        [_viewUpdateEmpty removeFromSuperview];
        
        if (parser.isOK)
        {
            _hasMore = page.hasMore;
            
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
        
        //[self _installEmptyView];
        [self.updatesTV reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    };
    
    if (_menuType == kGGMenuTypePerson)
    {
        id op = [GGSharedAPI getHappeningsWithPersonID:_menuID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
        [self registerOperation:op];
    }
    else if (_menuType == kGGMenuTypeFunctionalArea)
    {
        id op = [GGSharedAPI getHappeningsWithFunctionalAreaID:_menuID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
        [self registerOperation:op];
    }
}

-(void)_delayedStopAnimating
{
    __weak GGPeopleVC *weakSelf = self;
    [weakSelf.updatesTV.pullToRefreshView stopAnimating];
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
}

-(void)_delayedStopInfiniteAnimating
{
    __weak GGPeopleVC *weakSelf = self;
    
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
}

#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [super scrollViewWillBeginDragging:scrollView];
    
    GGSharedDelegate.rootVC.canBeDragged = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    GGSharedDelegate.rootVC.canBeDragged = YES;
}

//-(void)_adjustTvFrames
//{
//    CGRect updateRc = _updatesTV.frame;
//    updateRc.size.width = _updatesTV.superview.bounds.size.width;
//    updateRc.size.height = _updatesTV.superview.bounds.size.height - updateRc.origin.y;
//    _updatesTV.frame = updateRc;
//}

#pragma mark -
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        [self _installMenuButton];
    }
    else
    {
        //[self _callApiGetMenu];
    }
    
    [self _adjustSelfFrameForIpadWithOrient:toInterfaceOrientation];
    
    [self adjustScrollViewFrames];
    
    [_updatesTV reloadData];
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
