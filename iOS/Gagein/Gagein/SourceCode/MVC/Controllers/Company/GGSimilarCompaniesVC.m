//
//  GGSimilarCompaniesVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSimilarCompaniesVC.h"

#import "GGDataPage.h"
#import "SVPullToRefresh.h"
#import "GGCustomBriefCell.h"
#import "GGCompany.h"
#import "GGCompanyDetailVC.h"

@interface GGSimilarCompaniesVC ()
@property (nonatomic, strong) UITableView *tvSimilarCompanies;
@end

@implementation GGSimilarCompaniesVC
{
    NSUInteger      _currentPageIndex;
    BOOL           _hasMore;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentPageIndex = GG_PAGE_START_INDEX;
        _hasMore = YES;
    }
    return self;
}

-(void)_prevViewLoaded
{
    _similarCompanies = [NSMutableArray array];
    
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
}

- (void)viewDidLoad
{
    [self _prevViewLoaded];
    
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.silver;
    
    self.naviTitle = @"Similar Companies";
    
    self.tvSimilarCompanies = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    self.tvSimilarCompanies.rowHeight = [GGCustomBriefCell HEIGHT];
    self.tvSimilarCompanies.dataSource = self;
    self.tvSimilarCompanies.delegate = self;
    [self.view addSubview:self.tvSimilarCompanies];
    self.tvSimilarCompanies.backgroundColor = GGSharedColor.silver;
    _tvSimilarCompanies.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tvSimilarCompanies.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    __weak GGSimilarCompaniesVC *weakSelf = self;
    
    [self.tvSimilarCompanies addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [self.tvSimilarCompanies addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    [self.tvSimilarCompanies triggerPullToRefresh];
    [self addScrollToHide:_tvSimilarCompanies];
}


#pragma mark - notification handling
-(void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    if ([notification.name isEqualToString:GG_NOTIFY_LOG_OUT])
    {
        [_similarCompanies removeAllObjects];
        [self.tvSimilarCompanies reloadData];
    }
    else if ([notification.name isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self.tvSimilarCompanies triggerPullToRefresh];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.similarCompanies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *updateCellId = @"GGPersonCell";
    GGCustomBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGCustomBriefCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGCompany *data = [self.similarCompanies objectAtIndex:indexPath.row];
    
    cell.lblName.text = data.name;
    cell.lblTitle.text = data.website;
    cell.lblAddress.text = data.address;
    [cell loadLogoWithImageUrl:data.logoPath placeholder:GGSharedImagePool.logoDefaultCompany];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGCompany *data = _similarCompanies[indexPath.row];
    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
    vc.companyID = data.ID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
-(void)_getFirstPage
{
    _hasMore = YES;
    _currentPageIndex = GG_PAGE_START_INDEX;
    
    
    [self _getEmployeesDataAppended:NO];
}

-(void)_getNextPage
{
    if (_hasMore)
    {
        _currentPageIndex ++;
        
        [self _getEmployeesDataAppended:YES];
    }
    else
    {
        [self performSelector:@selector(_delayedStopInfiniteAnimating) withObject:nil afterDelay:.5f];
    }
}

-(void)_getEmployeesDataAppended:(BOOL)anAppended
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        
        if (parser.isOK)
        {
            _hasMore = parser.dataHasMore;
            GGDataPage *page = [parser parseGetSimilarCompanies];
            
            if (!anAppended)
            {
                [_similarCompanies removeAllObjects];
            }
            [_similarCompanies addObjectsFromArray:page.items];
        }
        
        [self.tvSimilarCompanies reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    };
    
    id op = [GGSharedAPI getSimilarCompaniesWithOrgID:_companyID pageNumber:_currentPageIndex callback:callback];
    [self registerOperation:op];
}

-(void)_delayedStopAnimating
{
    __weak GGSimilarCompaniesVC *weakSelf = self;
    [weakSelf.tvSimilarCompanies.pullToRefreshView stopAnimating];
    [weakSelf.tvSimilarCompanies.infiniteScrollingView stopAnimating];
}

-(void)_delayedStopInfiniteAnimating
{
    __weak GGSimilarCompaniesVC *weakSelf = self;
    
    [weakSelf.tvSimilarCompanies.infiniteScrollingView stopAnimating];
}


#pragma mark - orient change
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_tvSimilarCompanies centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH_FULL];
}

@end


