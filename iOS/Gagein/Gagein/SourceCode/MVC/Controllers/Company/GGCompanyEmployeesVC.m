//
//  GGCompanyEmployeesVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyEmployeesVC.h"

#import "GGDataPage.h"
#import "SVPullToRefresh.h"
#import "GGCustomBriefCell.h"
#import "GGPerson.h"
#import "GGPersonDetailVC.h"

@interface GGCompanyEmployeesVC ()
@property (nonatomic, strong) UITableView *tvEmployees;
@end

@implementation GGCompanyEmployeesVC
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
    _employees = [NSMutableArray array];
    
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
}

- (void)viewDidLoad
{
    [self _prevViewLoaded];
    
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.silver;
    
    self.naviTitle = @"Employees";
    
    self.tvEmployees = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    self.tvEmployees.rowHeight = [GGCustomBriefCell HEIGHT];
    self.tvEmployees.dataSource = self;
    self.tvEmployees.delegate = self;
    [self.view addSubview:self.tvEmployees];
    self.tvEmployees.backgroundColor = GGSharedColor.silver;
    _tvEmployees.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tvEmployees.showsVerticalScrollIndicator = NO;
    
    __weak GGCompanyEmployeesVC *weakSelf = self;
    
    [self.tvEmployees addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [self.tvEmployees addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    [self.tvEmployees triggerPullToRefresh];
    [self addScrollToHide:_tvEmployees];
}

-(void)dealloc
{
    [self unobserveAllNotifications];
}

#pragma mark - notification handling
-(void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    if ([notification.name isEqualToString:GG_NOTIFY_LOG_OUT])
    {
        [_employees removeAllObjects];
        [self.tvEmployees reloadData];
    }
    else if ([notification.name isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self.tvEmployees triggerPullToRefresh];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.employees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *updateCellId = @"GGPersonCell";
    GGCustomBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGCustomBriefCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGPerson *data = [self.employees objectAtIndex:indexPath.row];
    
    cell.lblName.text = data.name;
    cell.lblTitle.text = data.orgTitle;
    cell.lblAddress.text = data.address;
    [cell.ivPhoto setImageWithURL:[NSURL URLWithString:data.photoPath] placeholderImage:GGSharedImagePool.placeholder];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGPerson *data = [self.employees objectAtIndex:indexPath.row];
    
    GGPersonDetailVC *vc = [GGPersonDetailVC createInstance];
    vc.personID = data.ID;
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
            GGDataPage *page = [parser parseGetCompanyPeople];
            
            if (!anAppended)
            {
                [_employees removeAllObjects];
            }
            [_employees addObjectsFromArray:page.items];
        }
        
        [self.tvEmployees reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    };
    
    id op = [GGSharedAPI getCompanyPeopleWithOrgID:_companyID pageNumber:_currentPageIndex callback:callback];
    [self registerOperation:op];
}

-(void)_delayedStopAnimating
{
    __weak GGCompanyEmployeesVC *weakSelf = self;
    [weakSelf.tvEmployees.pullToRefreshView stopAnimating];
    [weakSelf.tvEmployees.infiniteScrollingView stopAnimating];
}

-(void)_delayedStopInfiniteAnimating
{
    __weak GGCompanyEmployeesVC *weakSelf = self;
    
    [weakSelf.tvEmployees.infiniteScrollingView stopAnimating];
}

#pragma mark - orientation change
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_tvEmployees centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

@end

