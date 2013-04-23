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
#import "GGPersonCell.h"
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
    
    self.naviTitle = @"Similar Companies";
    
    self.tvSimilarCompanies = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    self.tvSimilarCompanies.rowHeight = [GGPersonCell HEIGHT];
    self.tvSimilarCompanies.dataSource = self;
    self.tvSimilarCompanies.delegate = self;
    [self.view addSubview:self.tvSimilarCompanies];
    self.tvSimilarCompanies.backgroundColor = GGSharedColor.silver;
    
    __weak GGSimilarCompaniesVC *weakSelf = self;
    
    [self.tvSimilarCompanies addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [self.tvSimilarCompanies addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    [self.tvSimilarCompanies triggerPullToRefresh];
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
    GGPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGPersonCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGCompany *data = [self.similarCompanies objectAtIndex:indexPath.row];
    
    cell.lblName.text = data.name;
    cell.lblTitle.text = data.website;
    cell.lblAddress.text = data.address;
    [cell.ivPhoto setImageWithURL:[NSURL URLWithString:data.logoPath] placeholderImage:GGSharedImagePool.placeholder];
    
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
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
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
    
    [GGSharedAPI getSimilarCompaniesWithOrgID:_companyID pageNumber:_currentPageIndex callback:callback];
}

-(void)_delayedStopAnimating
{
    __weak GGSimilarCompaniesVC *weakSelf = self;
    [weakSelf.tvSimilarCompanies.pullToRefreshView stopAnimating];
    [weakSelf.tvSimilarCompanies.infiniteScrollingView stopAnimating];
}


@end


