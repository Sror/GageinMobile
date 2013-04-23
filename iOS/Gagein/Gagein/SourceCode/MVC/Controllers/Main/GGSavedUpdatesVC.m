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

#define SWITCH_WIDTH 80
#define SWITCH_HEIGHT 20

@interface GGSavedUpdatesVC ()
@property (strong) UITableView     *tvUpdates;
@end

@implementation GGSavedUpdatesVC
{
    GGSwitchButton   *_roundSwitch;
    NSUInteger      _currentPageIndex;
    BOOL            _hasMore;
    NSMutableArray  *_updates;
    
    BOOL            _isUnread;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.tabBarItem.title = @"Saved";
        //self.tabBarItem.image = [UIImage imageNamed:@"Players"];
        _updates = [NSMutableArray array];
        _currentPageIndex = GG_PAGE_START_INDEX;
        _isUnread = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
    
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.silver;
    self.navigationItem.title = @"Saved Updates";
    
    CGRect naviRc = self.navigationController.navigationBar.frame;
    
    _roundSwitch = [GGSwitchButton viewFromNibWithOwner:self];
    _roundSwitch.delegate = self;
    _roundSwitch.lblOn.text = @"Unread";
    _roundSwitch.lblOff.text = @"All";
    
    CGRect switchRc = CGRectMake(naviRc.size.width - SWITCH_WIDTH - 5
                                 , (naviRc.size.height - [GGSwitchButton HEIGHT]) / 2 + 5
                                 , SWITCH_WIDTH
                                 , [GGSwitchButton HEIGHT]);
    _roundSwitch.frame = switchRc;
    [self.navigationController.navigationBar addSubview:_roundSwitch];
    
    //
    _tvUpdates = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    _tvUpdates.rowHeight = [GGCompanyUpdateCell HEIGHT];
    _tvUpdates.dataSource = self;
    _tvUpdates.delegate = self;
    _tvUpdates.backgroundColor = GGSharedColor.silver;
    [self.view addSubview:_tvUpdates];
    
    // setup pull-to-refresh and infinite scrolling
    __weak GGSavedUpdatesVC *weakSelf = self;
    
    [_tvUpdates addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [_tvUpdates addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    [_tvUpdates triggerPullToRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_roundSwitch];
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
    GGCompanyUpdateCell *cell = (GGCompanyUpdateCell *)((UIButton*)sender).superview.superview;
    GGCompanyUpdate *update = [_updates objectAtIndex:cell.tag];
    
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
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    }
}

-(void)_callGetSavedUpdates
{
    _roundSwitch.btnSwitch.enabled = NO;
    [GGSharedAPI getSaveUpdatesWithPageIndex:_currentPageIndex isUnread:_isUnread callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _hasMore = parser.dataHasMore;
            
            GGDataPage *page = [parser parseGetSavedUpdates];
            [_updates addObjectsFromArray:page.items];
        }
        
        [_tvUpdates reloadData];
        
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    }];
}

-(void)_delayedStopAnimating
{
    __weak GGSavedUpdatesVC *weakSelf = self;
    [weakSelf.tvUpdates.pullToRefreshView stopAnimating];
    [weakSelf.tvUpdates.infiniteScrollingView stopAnimating];
    
    _roundSwitch.btnSwitch.enabled = YES;
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _updates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *updateCellId = @"GGCompanyUpdateCell";
    GGCompanyUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGCompanyUpdateCell viewFromNibWithOwner:self];
        [cell.logoBtn addTarget:self action:@selector(companyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGCompanyUpdate *updateData = [_updates objectAtIndex:indexPath.row];
    
    cell.ID = updateData.ID;
    cell.tag = indexPath.row;
    cell.titleLbl.text = updateData.headline;
    cell.sourceLbl.text = updateData.fromSource;
    cell.descriptionLbl.text = updateData.content;
    [cell.logoIV setImageWithURL:[NSURL URLWithString:updateData.company.logoPath] placeholderImage:nil];
    
    cell.intervalLbl.text = [updateData intervalStringWithDate:updateData.date];
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGCompanyUpdateDetailVC *vc = [[GGCompanyUpdateDetailVC alloc] init];
    //vc.newsID = updateData.ID;
    vc.naviTitle = self.navigationItem.title;
    vc.updates = _updates;
    vc.updateIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
