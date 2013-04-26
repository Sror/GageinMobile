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

@interface GGPeopleVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@end

@implementation GGPeopleVC
{
    GGSlideSettingView          *_slideSettingView;
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
    _slideSettingView.viewTable.dataSource = self;
    _slideSettingView.viewTable.delegate = self;
    _slideSettingView.viewTable.rowHeight = [GGSettingMenuCell HEIGHT];
    _slideSettingView.searchBar.delegate = self;
    _slideSettingView.searchBar.placeholder = @"Search for updates";
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
    
    [self.updatesTV triggerPullToRefresh];
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
//    if (searchBar.text.length)
//    {
//        GGComUpdateSearchVC *vc = [[GGComUpdateSearchVC alloc] init];
//        vc.keyword = searchBar.text;
//        searchBar.text = @"";
//        
//        [_slideSettingView hideSlideOnCompletion:^{
//            
//        }];
//        
//        [self.navigationController pushViewController:vc animated:NO];
//        
//        return YES;
//    }
    
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

#pragma mark - internal
-(GGSettingHeaderView *)_followingSectionView
{
    static GGSettingHeaderView *_followingSectionView;
    if (_followingSectionView == nil) {
        _followingSectionView = [GGSettingHeaderView viewFromNibWithOwner:self];
        _followingSectionView.lblTitle.text = @"FOLLOWING";
        _followingSectionView.ivSelected.hidden = YES;
        [_followingSectionView.btnBg addTarget:self action:@selector(_followingTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_followingSectionView.btnAdd addTarget:self action:@selector(_addPersonAction:) forControlEvents:UIControlEventTouchUpInside];
        _followingSectionView.btnConfig.hidden = YES;
        _followingSectionView.btnAdd.frame = _followingSectionView.btnConfig.frame;
        
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


-(IBAction)_addPersonAction:(id)sender
{
    [_slideSettingView hideSlide];
    //[self searchForCompanyAction:nil];
}

-(IBAction)_followingTapped:(id)sender
{
    self.naviTitle = @"FOLLOWING";
    
    [self _followingSectionView].ivSelected.hidden = NO;
    [self _exploringSectionView].ivSelected.hidden = YES;
    
    [self _unselectAllMenuItem];
    [_slideSettingView.viewTable reloadData];
    
    [self _refreshWithMenuId:GG_ALL_RESULT_ID type:kGGMenuTypePerson];
}

-(IBAction)_exploringConfigTapped:(id)sender
{
    [_slideSettingView hideSlide];
    //GGSelectAgentsVC *vc = [[GGSelectAgentsVC alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)_exploringTapped:(id)sender
{
    self.naviTitle = @"EXPLORING";
    
    [self _followingSectionView].ivSelected.hidden = YES;
    [self _exploringSectionView].ivSelected.hidden = NO;
    
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
    //GGFollowCompanyVC *vc = [[GGFollowCompanyVC alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
}


-(void)companyDetailAction:(id)sender
{
//    int index = ((UIButton*)sender).tag;
//    GGCompanyUpdate *update = [_updates objectAtIndex:index];
//    
//    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
//    vc.companyID = update.company.ID;
//    [self.navigationController pushViewController:vc animated:YES];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (tableView == self.updatesTV)
    {
        static NSString *updateCellId = @"GGCompanyHappeningCell";
        GGCompanyHappeningCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
        if (cell == nil) {
            cell = [GGCompanyHappeningCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGCompanyHappening *data = self.updates[row];
        
        cell.tag = indexPath.row;
        cell.lblName.text = data.sourceText;
        cell.lblDescription.text = data.headLineText;
        cell.lblInterval.text = [data intervalStringWithDate:data.timestamp];
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
        GGMenuData *menuData = page.items[row];
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
    int row = indexPath.row;
    
    if (tableView == self.updatesTV)
    {
//        GGCompanyUpdateDetailVC *vc = [[GGCompanyUpdateDetailVC alloc] init];
//        vc.naviTitleString = self.naviTitle;
//        vc.updates = self.updates;
//        vc.updateIndex = row;
//        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if (tableView == self.happeningsTV)
//    {
//        GGHappeningDetailVC *vc = [[GGHappeningDetailVC alloc] init];
//        vc.happenings = _happenings;
//        vc.currentIndex = row;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
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
        [self _exploringSectionView].ivSelected.hidden = YES;
        [self _followingSectionView].ivSelected.hidden = YES;
        
        [tableView reloadData];
        
        //get update data by menuID
        _menuType = theData.type;
        _menuID = theData.ID;
        
        [self _refreshWithMenuId:theData.ID type:theData.type];
    }
}

#pragma mark - data handling
-(void)_callApiGetMenu
{
    [GGSharedAPI getMenuByType:kGGStrMenuTypePeople callback:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _menuDatas = [parser parseGetMenu];
            
            if (_menuID == GG_ALL_RESULT_ID)
            {
                [self _unselectAllMenuItem];
                
                [self _followingSectionView].ivSelected.hidden = !(_menuType == kGGMenuTypePerson);
                [self _exploringSectionView].ivSelected.hidden = (_menuType == kGGMenuTypePerson);
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


@end
