//
//  GGUpdatesVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-21.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGUpdatesVC.h"

#import "GGDataPage.h"
#import "GGCompanyUpdate.h"
#import "GGCompanyUpdateCell.h"
#import "SVPullToRefresh.h"
#import "GGCompany.h"
#import "GGCompanyDetailVC.h"
#import "GGCompanyUpdateDetailVC.h"
#import "GGCompanyUpdateIpadCell.h"


@interface GGUpdatesVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@end

@implementation GGUpdatesVC
{
    EGGCompanyUpdateRelevance   _relevance;
    BOOL                                _hasMore;
}

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
    _relevance = kGGCompanyUpdateRelevanceNormal;
    _updates = [NSMutableArray array];
    
    [self observeNotification:GG_NOTIFY_LOG_OUT];
    [self observeNotification:GG_NOTIFY_LOG_IN];
}

- (void)viewDidLoad
{
    [self _prevViewLoaded];
    
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.silver;
    
    self.naviTitle = @"Updates";
    
    self.updatesTV = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];
    //self.updatesTV.rowHeight = [GGCompanyUpdateCell HEIGHT];
    self.updatesTV.dataSource = self;
    self.updatesTV.delegate = self;
    [self.view addSubview:self.updatesTV];
    self.updatesTV.backgroundColor = GGSharedColor.silver;
    self.updatesTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _updatesTV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    __weak GGUpdatesVC *weakSelf = self;
    
    [self.updatesTV addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    [self.updatesTV addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];

    [self.updatesTV triggerPullToRefresh];
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
        [_updates removeAllObjects];
        [self.updatesTV reloadData];
    }
    else if ([notification.name isEqualToString:GG_NOTIFY_LOG_IN])
    {
        [self.updatesTV triggerPullToRefresh];
    }
}

#pragma mark - actions
-(void)companyDetailAction:(id)sender
{
    //GGCompanyUpdateCell *cell = (GGCompanyUpdateCell *)((UIButton*)sender).superview.superview;
    int index = ((UIButton*)sender).tag;
    GGCompanyUpdate *update = [_updates objectAtIndex:index];
    
    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
    vc.companyID = update.company.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.updates.count;
}

-(float)_updateCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return [self _updateCellForIndexPath:indexPath].frame.size.height;
}

-(GGCompanyUpdateCell *)_updateCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *updateCellId = @"GGCompanyUpdateCell";
    GGCompanyUpdateCell *cell = [_updatesTV dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGCompanyUpdateCell viewFromNibWithOwner:self];
        [cell.logoBtn addTarget:self action:@selector(companyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGCompanyUpdate *updateData = [self.updates objectAtIndex:indexPath.row];
    
    cell.ID = updateData.ID;
    cell.logoBtn.tag = indexPath.row;
    cell.titleLbl.text = [updateData headlineTruncated];
    cell.sourceLbl.text = updateData.fromSource;
    
//#warning FAKE DATA - company update description
    cell.descriptionLbl.text = updateData.content;
    cell.hasBeenRead = updateData.hasBeenRead;
    
    [cell.logoIV setImageWithURL:[NSURL URLWithString:updateData.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
    
    cell.intervalLbl.text = [updateData intervalStringWithDate:updateData.date];
    [cell adjustLayout];
    
    return cell;
}

-(GGCompanyUpdateIpadCell *)_updateIpadCellForIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString *updateCellId = @"GGCompanyUpdateIpadCell";
    GGCompanyUpdateIpadCell *cell = [_updatesTV dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGCompanyUpdateIpadCell viewFromNibWithOwner:self];
        [cell.btnLogo addTarget:self action:@selector(companyDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGCompanyUpdate *updateData = self.updates[row];
    
    //cell.ID = updateData.ID;
    cell.btnLogo.tag = row;
    
    cell.lblHeadline.text = [updateData headlineTruncated];
    cell.lblSource.text = updateData.fromSource;//[NSString stringWithFormat:@"%@ · %@", updateData.fromSource, [updateData intervalStringWithDate:updateData.date]];
    
    //#warning FAKE DATA - company update description
    cell.lblDescription.text = updateData.content;
    
    [cell.ivLogo setImageWithURL:[NSURL URLWithString:updateData.company.logoPath] placeholderImage:GGSharedImagePool.logoDefaultCompany];
    
    cell.lblInterval.text = [updateData intervalStringWithDate:updateData.date];
    //cell.hasBeenRead = updateData.hasBeenRead;
    //[cell adjustLayout];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPADDEVICE)
    {
        return [self _updateIpadCellForIndexPath:indexPath];
    }
    else
    {
        return [self _updateCellForIndexPath:indexPath];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GGCompanyUpdateDetailVC *vc = [[GGCompanyUpdateDetailVC alloc] init];

    vc.naviTitleString = self.customNaviTitle.text;
    vc.updates = self.updates;
    vc.updateIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self _updateCellHeightForIndexPath:indexPath];
}

#pragma mark - 
-(void)_getFirstPage
{
    [self _getDataWithNewsID:0 pageFlag:kGGPageFlagFirstPage pageTime:0 relevance:_relevance];
}

-(void)_getNextPage
{
    if (_hasMore)
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
    else
    {
        [self _delayedStopInfiniteAnimating];
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
        //DLog(@"%@", aResultObject);
        
        //[self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyUpdates];
        //DLog(@"%@", page);
        
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
        
        [self.updatesTV reloadData];
        
        // if network response is too quick, stop animating immediatly will cause scroll view offset problem, so delay it.
        [self performSelector:@selector(_delayedStopAnimating) withObject:nil afterDelay:.5f];
    };
    
    id op = [GGSharedAPI getCompanyUpdatesWithCompanyID:_companyID newsID:aNewsID pageFlag:aPageFlag pageTime:aPageTime relevance:aRelevance callback:callback];
    
    [self registerOperation:op];
}

-(void)_delayedStopAnimating
{
    __weak GGUpdatesVC *weakSelf = self;
    [weakSelf.updatesTV.pullToRefreshView stopAnimating];
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
}

-(void)_delayedStopInfiniteAnimating
{
    __weak GGUpdatesVC *weakSelf = self;
    
    [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
}

#pragma mark - 
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_updatesTV centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

@end
