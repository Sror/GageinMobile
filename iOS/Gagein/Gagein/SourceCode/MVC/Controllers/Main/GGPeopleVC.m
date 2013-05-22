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
#import "GGCompanyHappening.h"
#import "GGFollowPeopleVC.h"
#import "GGPersonDetailVC.h"
#import "GGHappeningDetailVC.h"
#import "GGSelectFuncAreasVC.h"
#import "GGEmptyActionView.h"

@interface GGPeopleVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@end

@implementation GGPeopleVC
{
    GGSlideSettingView          *_slideSettingView;
    GGEmptyActionView                 *_viewUpdateEmpty;
    
    NSArray                    *_menuDatas;
    EGGMenuType                _menuType;
    long long                  _menuID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _updates = [NSMutableArray array];
        _menuType = kGGMenuTypeFunctionalArea;   // exploring...
        _menuID = GG_ALL_RESULT_ID;
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
    
    [super viewDidLoad];
    
    [self _installMenuButton];
    self.naviTitle = @"People";
    
    [self _initSlideSettingView];
    
    CGRect updateRc = [self viewportAdjsted];
    
    self.updatesTV = [[UITableView alloc] initWithFrame:updateRc style:UITableViewStylePlain];
    self.updatesTV.rowHeight = [GGCompanyHappeningCell HEIGHT];
    self.updatesTV.dataSource = self;
    self.updatesTV.delegate = self;
    //[_scrollingView addPage:self.updatesTV];
    self.updatesTV.backgroundColor = GGSharedColor.silver;
    [self.view addSubview:self.updatesTV];
    
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // change menu to people type
    [_slideSettingView changeDelegate:self];
    _slideSettingView.viewTable.tableHeaderView = nil;
    [self _callApiGetMenu];
    
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
    self.view.userInteractionEnabled = !aIsShowed;
}

#pragma mark - notification handling
-(void)handleNotification:(NSNotification *)notification
{
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
        self.view.userInteractionEnabled = NO;
    }
    else if ([noteName isEqualToString:GG_NOTIFY_MENU_COVER])
    {
        self.view.userInteractionEnabled = YES;
        [_slideSettingView.searchBar resignFirstResponder];
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
    [_slideSettingView hideSlide];
    
    GGFollowPeopleVC *vc = [[GGFollowPeopleVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)_enterFollowPeople
{
    GGFollowPeopleVC *vc = [[GGFollowPeopleVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)_followingTapped:(id)sender
{
    self.naviTitle = @"FOLLOWING";
    
    [[self _followingSectionView] setHightlighted:YES];
    [[self _exploringSectionView] setHightlighted:NO];
    
    [self _unselectAllMenuItem];
    [_slideSettingView.viewTable reloadData];
    
    [self _refreshWithMenuId:GG_ALL_RESULT_ID type:kGGMenuTypePerson];
}

-(IBAction)_exploringConfigTapped:(id)sender
{
    [_slideSettingView hideSlide];
    GGSelectFuncAreasVC *vc = [[GGSelectFuncAreasVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)_exploringTapped:(id)sender
{
    self.naviTitle = @"EXPLORING";
    
    [[self _followingSectionView] setHightlighted:NO];
    [[self _exploringSectionView] setHightlighted:YES];
    
    [self _unselectAllMenuItem];
    [_slideSettingView.viewTable reloadData];
    
    [self _refreshWithMenuId:GG_ALL_RESULT_ID type:kGGMenuTypeFunctionalArea];
}

-(void)_refreshWithMenuId:(long long)aMenuID type:(EGGMenuType)aType
{
    [_slideSettingView hideSlide];
    
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
        [self _callApiGetMenu];
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
    GGCompanyHappening *data = self.updates[aButton.tag];
    GGPersonDetailVC *vc = [[GGPersonDetailVC alloc] init];
    vc.personID = data.person.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (tableView == self.updatesTV)
    {
        static NSString *updateCellId = @"GGCompanyHappeningCell";
        GGCompanyHappeningCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
        if (cell == nil) {
            cell = [GGCompanyHappeningCell viewFromNibWithOwner:self];
            [cell.btnLogo addTarget:self action:@selector(_enterPersonDetailAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGCompanyHappening *data = self.updates[row];
        
        cell.tag = cell.btnLogo.tag = indexPath.row;
        cell.lblName.text = data.sourceText;
        cell.lblDescription.text = data.headLineText;
        cell.lblInterval.text = [data intervalStringWithDate:data.timestamp];
        [cell.ivLogo setImageWithURL:[NSURL URLWithString:data.photoPath] placeholderImage:GGSharedImagePool.logoDefaultPerson];
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
    int row = indexPath.row;
    
    if (tableView == self.updatesTV)
    {
        GGHappeningDetailVC *vc = [[GGHappeningDetailVC alloc] init];
        vc.isPeopleHappening = YES;
        vc.happenings = _updates;
        vc.currentIndex = row;
        
        GGCompanyHappening *data = _updates[row];
        data.hasBeenRead = YES;
        
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
}

#pragma mark - data handling
-(void)_getInitData
{
    [GGSharedAPI getMenuByType:kGGStrMenuTypePeople callback:^(id operation, id aResultObject, NSError *anError) {
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
            [self _followingTapped:nil];
        }
        else
        {
            [self _exploringTapped:nil];
        }
    }];
}

-(void)_callApiGetMenu
{
    //[_slideSettingView showLoadingHUD];
    [GGSharedAPI getMenuByType:kGGStrMenuTypePeople callback:^(id operation, id aResultObject, NSError *anError) {
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
            [GGAlert alertWithApiMessage:parser.message];
        }
    }];
}

-(void)_getFirstPage
{
    [self _getDataWithPageFlag:kGGPageFlagFirstPage pageTime:0 eventID:0];
}

-(void)_getNextPage
{
    long long happeningID = 0, pageTime = 0;
    GGCompanyHappening *lastOne = [_updates lastObject];
    if (lastOne)
    {
        happeningID = lastOne.ID;
        pageTime = lastOne.timestamp;
    }
    
    [self _getDataWithPageFlag:kGGPageFlagMoveDown pageTime:pageTime eventID:happeningID];
}

-(void)_getDataWithPageFlag:(int)aPageFlag pageTime:(long long)aPageTime eventID:(long long)anEventID
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyHappenings];
        
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
        
        [self _installEmptyView];
        [self.updatesTV reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    };
    
    if (_menuType == kGGMenuTypePerson)
    {
        [GGSharedAPI getHappeningsWithPersonID:_menuID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
    }
    else if (_menuType == kGGMenuTypeFunctionalArea)
    {
        [GGSharedAPI getHappeningsWithFunctionalAreaID:_menuID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
    }
}

-(void)_delayedStopAnimating
{
    __weak GGPeopleVC *weakSelf = self;
    [weakSelf.updatesTV.pullToRefreshView stopAnimating];
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
}

-(void)_installEmptyView
{
    //
    [_viewUpdateEmpty removeFromSuperview];
    if (_updates.count)
    {
        return;
    }
    
    _viewUpdateEmpty = [GGEmptyActionView viewFromNibWithOwner:self];
    _viewUpdateEmpty.frame = self.view.bounds;
    [_updatesTV addSubview:_viewUpdateEmpty];
    
    _viewUpdateEmpty.lblTitle.text = @"Have trouble seeing updates?";
    _viewUpdateEmpty.viewSimple.hidden = YES;
    
    if (_menuType == kGGMenuTypePerson)
    {
        if (((GGDataPage *)_menuDatas[0]).items.count <= 0)
        {
            _viewUpdateEmpty.lblMessage.text = @"Add people to watch for job, location and other changes.";
            [_viewUpdateEmpty.btnAction addTarget:self action:@selector(_enterFollowPeople) forControlEvents:UIControlEventTouchUpInside];
            [_viewUpdateEmpty.btnAction setTitle:@"Add People to Follow" forState:UIControlStateNormal];
        }
        else
        {
            _viewUpdateEmpty.viewSimple.hidden = NO;
            _viewUpdateEmpty.lblSimpleMessage.text = @"No update found for this person as of this new feature launch in May 2013.";
        }
    }
    else if (_menuType == kGGMenuTypeFunctionalArea)
    {
        _viewUpdateEmpty.lblMessage.text = @"Select functional roles to keep up with leadership changes.";
        [_viewUpdateEmpty.btnAction addTarget:self action:@selector(_exploringConfigTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_viewUpdateEmpty.btnAction setTitle:@"Select Functional Roles" forState:UIControlStateNormal];
    }
}


@end
