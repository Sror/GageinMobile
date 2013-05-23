//
//  GGHappeningsVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGHappeningsVC.h"

#import "GGDataPage.h"
#import "SVPullToRefresh.h"
#import "GGCompany.h"
#import "GGCompanyDetailVC.h"

#import "GGCompanyHappeningCell.h"
#import "GGHappening.h"

@interface GGHappeningsVC ()
@property (nonatomic, strong) UITableView *tvHappenings;
@end

@implementation GGHappeningsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)_prevViewLoaded
{
    _happenings = [NSMutableArray array];
    
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
}

- (void)viewDidLoad
{
    [self _prevViewLoaded];
    
    [super viewDidLoad];
    
    self.naviTitle = @"Happenings";
    
    self.tvHappenings = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    self.tvHappenings.rowHeight = [GGCompanyHappeningCell HEIGHT];
    self.tvHappenings.dataSource = self;
    self.tvHappenings.delegate = self;
    [self.view addSubview:self.tvHappenings];
    self.tvHappenings.backgroundColor = GGSharedColor.silver;
    
    __weak GGHappeningsVC *weakSelf = self;
    
    [self.tvHappenings addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [self.tvHappenings addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
    
    [self.tvHappenings triggerPullToRefresh];
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
        [_happenings removeAllObjects];
        [self.tvHappenings reloadData];
    }
    else if ([notification.name isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self.tvHappenings triggerPullToRefresh];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.happenings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *updateCellId = @"GGCompanyHappeningCell";
    GGCompanyHappeningCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGCompanyHappeningCell viewFromNibWithOwner:self];
        //[cell.logoBtn addTarget:self action:@selector(companyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGHappening *data = [self.happenings objectAtIndex:indexPath.row];
    
    cell.lblName.text = data.sourceText;
    cell.lblDescription.text = data.headLineText;
    cell.lblInterval.text = [data intervalStringWithDate:data.timestamp];
    [cell.ivLogo setImageWithURL:[NSURL URLWithString:data.orgLogoPath] placeholderImage:(_isPersonHappenings ? GGSharedImagePool.logoDefaultPerson : GGSharedImagePool.logoDefaultCompany)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    GGCompanyUpdateDetailVC *vc = [[GGCompanyUpdateDetailVC alloc] init];
//    
//    vc.naviTitleString = self.customNaviTitle.text;
//    vc.updates = self.updates;
//    vc.updateIndex = indexPath.row;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
-(void)_getFirstPage
{
    [self _getDataWithEventID:0 pageFlag:kGGPageFlagFirstPage pageTime:0];
}

-(void)_getNextPage
{
    long long newsID = 0, pageTime = 0;
    GGHappening *last = [_happenings lastObject];
    if (last)
    {
        newsID = last.ID;
        pageTime = last.timestamp;
    }
    
    [self _getDataWithEventID:newsID pageFlag:kGGPageFlagMoveDown pageTime:pageTime];
}

-(void)_getDataWithEventID:(long long)anEventID pageFlag:(int)aPageFlag pageTime:(long long)aPageTime
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
                    NSMutableArray *newHappenings = [NSMutableArray arrayWithArray:page.items];
                    [newHappenings addObjectsFromArray:_happenings];
                    self.happenings = newHappenings;
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        [self.tvHappenings reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    };
    
    if (_isPersonHappenings)
    {
        id op = [GGSharedAPI getHappeningsWithPersonID:_personID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
        [self registerOperation:op];
    }
    else
    {
        id op = [GGSharedAPI getHappeningsWithCompanyID:_companyID eventID:anEventID pageFlag:aPageFlag pageTime:aPageTime callback:callback];
        [self registerOperation:op];
    }
    
}

-(void)_delayedStopAnimating
{
    __weak GGHappeningsVC *weakSelf = self;
    [weakSelf.tvHappenings.pullToRefreshView stopAnimating];
    [weakSelf.tvHappenings.infiniteScrollingView stopAnimating];
}


@end
