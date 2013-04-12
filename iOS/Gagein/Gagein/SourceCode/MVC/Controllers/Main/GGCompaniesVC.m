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

#import "GGSlideSettingView.h"
#import "GGCompanyDetailVC.h"
#import "GGCompanyUpdateDetailVC.h"
#import "GGScrollingView.h"
#import "GGFollowCompanyVC.h"
#import "GGSettingHeaderView.h"

//#define USE_CUSTOM_NAVI_BAR       // 是否使用自定义导航条

@interface GGCompaniesVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@property (nonatomic, strong) UITableView *happeningsTV;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviItem;
//@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation GGCompaniesVC
{
    EGGCompanyUpdateRelevance   _relevance;
    GGScrollingView             *_scrollingView;
    GGSlideSettingView          *_slideSettingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Companies";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        _relevance = kGGCompanyUpdateRelevanceNormal;
        _updates = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
    
    
#if defined(USE_CUSTOM_NAVI_BAR)
    self.navigationController.navigationBarHidden = YES;
#endif
    [super viewDidLoad];
    
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(optionMenuAction:)];
    UIBarButtonItem *searchUpdateBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchUpdateAction:)];
    UIBarButtonItem *savedUpdateBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(savedUpdateAction:)];
    
#if defined(USE_CUSTOM_NAVI_BAR)
    self.naviItem.title = @"EXPLORING";
    self.naviItem.leftBarButtonItem = menuBtn;
    self.naviItem.rightBarButtonItems = [NSArray arrayWithObjects:savedUpdateBtn, searchUpdateBtn, nil];
#else
    self.naviBar.hidden = YES;
    self.title = @"EXPLORING";
    self.navigationItem.leftBarButtonItem = menuBtn;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:savedUpdateBtn, searchUpdateBtn, nil];
#endif
    
    
    CGRect updateRc = self.view.bounds;
#if defined(USE_CUSTOM_NAVI_BAR)
    updateRc.origin.y += self.naviBar.frame.size.height;
    updateRc.size.height -= self.naviBar.frame.size.height;
#endif
    
    //
    _slideSettingView = [[GGSlideSettingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_slideSettingView];
    _slideSettingView.viewTable.dataSource = self;
    _slideSettingView.viewTable.delegate = self;

    
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
    
    self.happeningsTV = [[UITableView alloc] initWithFrame:updateRc style:UITableViewStylePlain];
    self.happeningsTV.dataSource = self;
    self.happeningsTV.delegate = self;
    [_scrollingView addPage:self.happeningsTV];
    
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
    
    [self.updatesTV triggerPullToRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [self setNaviBar:nil];
    [self setNaviItem:nil];
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
    }
    else if ([notification.name isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self.updatesTV triggerPullToRefresh];
    }
}

#pragma mark - actions
-(void)optionMenuAction:(id)sender
{
    DLog(@"option menu clicked");
    if (!_slideSettingView.isShowing)
    {
        [_slideSettingView showSlide];
    }
    else
    {
        [_slideSettingView hideSlide];
    }
}

-(void)searchUpdateAction:(id)sender
{
    DLog(@"search update clicked");
    
    GGFollowCompanyVC *vc = [[GGFollowCompanyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)savedUpdateAction:(id)sender
{
    DLog(@"saved update clicked");
    [GGAlert alert:@"Saved updates (TODO)"];
}

-(void)companyDetailAction:(id)sender
{
    GGCompanyUpdateCell *cell = (GGCompanyUpdateCell *)((UIButton*)sender).superview.superview;
    GGCompanyUpdate *update = [_updates objectAtIndex:cell.tag];
    
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
        return 20;
    }
    else if (tableView == _slideSettingView.viewTable)
    {
        return 5;
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
        }
        
        GGCompanyUpdate *updateData = [self.updates objectAtIndex:indexPath.row];
        
        cell.ID = updateData.ID;
        cell.tag = indexPath.row;
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
        static NSString *happeningCellId = @"happeningCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:happeningCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:happeningCellId];
        }
        cell.textLabel.text = @"happening";
        return cell;
    }
    else if (tableView == _slideSettingView.viewTable)
    {
        static NSString *menuCellId = @"menuCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuCellId];
        }
        cell.textLabel.text = @"settings";
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
        GGSettingHeaderView * headerView = [GGSettingHeaderView viewFromNibWithOwner:self];
        return headerView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.updatesTV)
    {
        GGCompanyUpdate *updateData = [self.updates objectAtIndex:indexPath.row];
        GGCompanyUpdateDetailVC *vc = [[GGCompanyUpdateDetailVC alloc] init];
        vc.newsID = updateData.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tableView == self.happeningsTV)
    {
        //
    }
    else if (tableView == _slideSettingView.viewTable)
    {
        //
    }
}

#pragma mark - scrolling view delegate
-(void)scrollingView:(GGScrollingView *)aScrollingView didScrollToIndex:(NSUInteger)aPageIndex;
{
    DLog(@"scrolling to index:%d", aPageIndex);
}


#pragma mark - data handling
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
    GGCompanyUpdate *lastUpdate = _updates.count > 0 ? [_updates objectAtIndex:0] : nil;
    if (lastUpdate)
    {
        newsID = lastUpdate.ID;
        pageTime = lastUpdate.date;
    }
    
    [self _getDataWithNewsID:newsID pageFlag:kGGPageFlagMoveUp pageTime:pageTime relevance:_relevance];
}

-(void)_getDataWithNewsID:(long long)aNewsID pageFlag:(int)aPageFlag pageTime:(long long)aPageTime relevance:(int)aRelevance
{
    //[self showLoadingHUD];
    [GGSharedAPI getExploringUpdatesWithNewsID:aNewsID pageFlag:aPageFlag pageTime:aPageTime relevance:aRelevance callback:^(id operation, id aResultObject, NSError *anError) {
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
    }];
}

-(void)_delayedStopAnimating
{
    __weak GGCompaniesVC *weakSelf = self;
    [weakSelf.updatesTV.pullToRefreshView stopAnimating];
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
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
