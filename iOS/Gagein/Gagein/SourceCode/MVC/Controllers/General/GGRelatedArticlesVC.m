//
//  GGRelatedArticlesVC.m
//  Gagein
//
//  Created by Dong Yiming on 7/1/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGRelatedArticlesVC.h"

#import "GGTableViewExpandHelper.h"
#import "GGCompanyUpdateCell.h"
#import "GGCompanyUpdateIpadCell.h"
#import "GGCompanyUpdateDetailVC.h"

#import "GGCompanyUpdate.h"
#import "GGDataPage.h"

@interface GGRelatedArticlesVC ()
@property (nonatomic, strong) UITableView *updatesTV;
@end

@implementation GGRelatedArticlesVC
{
    NSMutableArray  *_articles;
    GGTableViewExpandHelper             *_tvExpandHelper;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _articles = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.naviTitle = @"Related Articles";
	
    self.updatesTV = [[UITableView alloc] initWithFrame:[self viewportAdjsted] style:UITableViewStylePlain];

    self.updatesTV.dataSource = self;
    self.updatesTV.delegate = self;
    [self.view addSubview:self.updatesTV];
    
    self.updatesTV.backgroundColor = GGSharedColor.silver;
    self.updatesTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _updatesTV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _updatesTV.showsVerticalScrollIndicator = NO;
    _tvExpandHelper = [[GGTableViewExpandHelper alloc] initWithTableView:_updatesTV];
    
    [self addScrollToHide:_updatesTV];
    
    [self _getData];
}



#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articles.count;
}

-(float)_updateCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return [self _updateCellForIndexPath:indexPath].frame.size.height;
}

-(GGCompanyUpdateCell *)_updateCellForIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    static NSString *updateCellId = @"GGCompanyUpdateCell";
    GGCompanyUpdateCell *cell = [_updatesTV dequeueReusableCellWithIdentifier:updateCellId];
    
    GGTagetActionPair *action = [GGTagetActionPair pairWithTaget:self action:@selector(companyDetailAction:)];
    cell = [GGFactory cellOfComUpdate:cell
                                 data:_articles[row]
                            dataIndex:row
                           logoAction:action];
    
    return cell;
}

-(float)_updateIpadCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return [self _updateIpadCellForIndexPath:indexPath needDetail:NO].frame.size.height;
}

-(GGCompanyUpdateIpadCell *)_updateIpadCellForIndexPath:(NSIndexPath *)indexPath needDetail:(BOOL)aNeedDetail
{
    int row = indexPath.row;
    
    //static NSString *updateCellId = @"GGCompanyUpdateIpadCell";
    GGCompanyUpdateIpadCell *cell = nil;//[_updatesTV dequeueReusableCellWithIdentifier:updateCellId];
    
    GGTagetActionPair *logoAction = [GGTagetActionPair pairWithTaget:self action:@selector(companyDetailAction:)];
    GGTagetActionPair *headlineAction = [GGTagetActionPair pairWithTaget:self action:@selector(_enterUpdateDetailAction:)];
    
    cell = [GGFactory cellOfComUpdateIpad:cell
                                     data:_articles[row]
                                dataIndex:row
                              expandIndex:_tvExpandHelper.expandingIndex
                            isTvExpanding:_tvExpandHelper.isExpanding
                               logoAction:logoAction
                           headlineAction:headlineAction needDetail:aNeedDetail];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPADDEVICE)
    {
        return [self _updateIpadCellForIndexPath:indexPath needDetail:YES];
    }
    else
    {
        return [self _updateCellForIndexPath:indexPath];
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISIPADDEVICE)
    {
        if (indexPath.row == _tvExpandHelper.expandingIndex)
        {
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (ISIPADDEVICE)
    {
        // snapshot old value...
        NSUInteger oldIndex = _tvExpandHelper.expandingIndex;
        //BOOL oldIsExpanding = _tvExpandHelper.isExpanding;
        [_tvExpandHelper changeExpaningAt:row];
        
        // reload cells
        [tableView beginUpdates];
        if (indexPath.row == oldIndex)
        {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndex inSection:indexPath.section];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, oldIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        // adjust tableview content offset
        //[_tvExpandHelper scrollToCenterFrom:oldIndex to:row oldIsExpanding:oldIsExpanding];
        
        [tableView endUpdates];
    }
    else
    {
        [self _enterUpdateDetailAt:indexPath.row];
    }
}

-(void)_enterUpdateDetailAction:(id)sender
{
    [self _enterUpdateDetailAt:(((UIView *)sender).tag)];
}

-(void)_enterUpdateDetailAt:(NSUInteger)aIndex
{
    GGCompanyUpdateDetailVC *vc = [[GGCompanyUpdateDetailVC alloc] init];
    
    vc.naviTitleString = self.customNaviTitle.text;
    vc.updates = _articles;
    vc.updateIndex = aIndex;
    vc.naviTitleString = @"Related Articles";
    GGCompanyUpdate *data = _articles[aIndex];
    data.hasBeenRead = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == 0)
    //    {
    //        [_tvExpandHelper resetCellHeights];
    //    }
    float height = ISIPADDEVICE ? [self _updateIpadCellHeightForIndexPath:indexPath] : [self _updateCellHeightForIndexPath:indexPath];
    //[_tvExpandHelper recordCellHeight:height];
    return height;
}


#pragma mark - get data
-(void)_getData
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        [self hideLoadingHUD];
        
        //[self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyUpdates];
        //DLog(@"%@", page);
        
        if (parser.isOK)
        {
            //_hasMore = page.hasMore;
            
            if (page.items.count)
            {
                [_articles removeAllObjects];
                
//                for (GGCompanyUpdate *update in page.items)
//                {
//                    DLog(@"related id: %lld, origin id:%lld, similar id:%lld", update.ID, _updateID, _similarID);
//                    if (update.ID != _updateID)
//                    {
//                        [_articles addObject:update];
//                    }
//                }
                
                [_articles addObjectsFromArray:page.items];
            }
            
        }
        
        [self.updatesTV reloadData];
    };
    
    [self showLoadingHUD];
    id op = [GGSharedAPI getSimilarUpdatesWithID:_similarID callback:callback];
    
    [self registerOperation:op];
}

-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_updatesTV centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH_FULL];
}

@end
