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
#import "GGCompanyUpdate.h"

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
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Companies";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        _relevance = kGGCompanyUpdateRelevanceNormal;
    }
    return self;
}

- (void)viewDidLoad
{
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
    
    self.updatesTV = [[UITableView alloc] initWithFrame:updateRc style:UITableViewStylePlain];
    self.updatesTV.rowHeight = [GGCompanyUpdateCell HEIGHT];
    self.updatesTV.dataSource = self;
    self.updatesTV.delegate = self;
    [self.view addSubview:self.updatesTV];
    
    //[self setupDataSource];
    
    __weak GGCompaniesVC *weakSelf = self;
    
    // setup pull-to-refresh
    [self.updatesTV addPullToRefreshWithActionHandler:^{
        [weakSelf _getFirstPage];
    }];
    
    // setup infinite scrolling
    [self.updatesTV addInfiniteScrollingWithActionHandler:^{
        [weakSelf _getNextPage];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.updatesTV triggerPullToRefresh];
    //[self _getFirstPage];
}

- (void)viewDidUnload {
    [self setNaviBar:nil];
    [self setNaviItem:nil];
    [_updates removeAllObjects];
    [super viewDidUnload];
}



#pragma mark - actions
-(void)optionMenuAction:(id)sender
{
    DLog(@"option menu clicked");
}

-(void)searchUpdateAction:(id)sender
{
    DLog(@"search update clicked");
}

-(void)savedUpdateAction:(id)sender
{
    DLog(@"saved update clicked");
}



#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.updates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *updateCellId = @"GGCompanyUpdateCell";
    GGCompanyUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGCompanyUpdateCell viewFromNibWithOwner:self];
    }
    
    GGCompanyUpdate *updateData = [self.updates objectAtIndex:indexPath.row];
    
    cell.titleLbl.text = updateData.headline;
    cell.sourceLbl.text = updateData.fromSource;
    cell.descriptionLbl.text = updateData.content;
//    cell.titleLbl.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    
    return cell;
}


#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




#pragma mark - data handling
-(void)_getFirstPage
{
    [self _getDataWithNewsID:0 pageFlag:kGGPageFlagFirstPage pageTime:0 relevance:_relevance];
}

-(void)_getNextPage
{
    [self _getDataWithNewsID:0 pageFlag:kGGPageFlagMoveDown pageTime:0 relevance:_relevance];
}

-(void)_getPrevPage
{
    [self _getDataWithNewsID:0 pageFlag:kGGPageFlagMoveUp pageTime:0 relevance:_relevance];
}

-(void)_getDataWithNewsID:(int)aNewsID pageFlag:(int)aPageFlag pageTime:(long long)aPageTime relevance:(int)aRelevance
{
    [self showLoadingHUD];
    [GGSharedAPI getCompanyUpdatesWithNewsID:aNewsID pageFlag:aPageFlag pageTime:aPageTime relevance:aRelevance callback:^(id operation, id aResultObject, NSError *anError) {
        //DLog(@"%@", aResultObject);
        AFHTTPRequestOperation *httpOp = operation;
        DLog(@"%@", httpOp.responseString);
        
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyUpdates];
        //DLog(@"%@", page);
        __weak GGCompaniesVC *weakSelf = self;
        [weakSelf.updatesTV.pullToRefreshView stopAnimating];
        [weakSelf.updatesTV.infiniteScrollingView stopAnimating];
        
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
            
            [self.updatesTV reloadData];
        }
    }];
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
