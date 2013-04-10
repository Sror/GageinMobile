//
//  GGFollowCompanyVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGFollowCompanyVC.h"
#import "GGSearchBar.h"
#import "GGDataPage.h"
#import "GGCompany.h"

@interface GGFollowCompanyVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *viewScroll;
@property (weak, nonatomic) IBOutlet GGSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UIButton *btnSalesForce;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCompanies;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBg;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearchResult;

@end

@implementation GGFollowCompanyVC
{
    CGRect              _searchBarRect;
    CGRect              _searchBarRectOnNavi;
    CGRect              _tvSearchResultRect;
    CGRect              _tvSearchResultRectShort;
    
    NSTimer             *_searchTimer;
    
    NSMutableArray      *_searchedCompanies;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _searchedCompanies = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    
    [super viewDidLoad];
    
    _searchBarRect = self.searchBar.frame;
    _searchBarRectOnNavi = CGRectMake(10, (self.navigationController.navigationBar.frame.size.height - _searchBarRect.size.height) / 2, _searchBarRect.size.width, _searchBarRect.size.height);
    _tvSearchResultRect = self.tableViewSearchResult.frame;
    float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT + self.tabBarController.tabBar.frame.size.height;
    _tvSearchResultRectShort = [GGUtils setH:height rect:_tvSearchResultRect];
}

- (void)viewDidUnload {
    [self setViewScroll:nil];
    [self setSearchBar:nil];
    [self setLblTip:nil];
    [self setBtnSalesForce:nil];
    [self setBtnLinkedIn:nil];
    [self setTableViewCompanies:nil];
    [self setViewSearchBg:nil];
    [self setTableViewSearchResult:nil];
    [super viewDidUnload];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableViewSearchResult) {
        self.tableViewSearchResult.hidden = (_searchedCompanies.count <= 0);
        return _searchedCompanies.count;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableViewSearchResult) {
        static NSString *companyCellId = @"companyCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companyCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companyCellId];
        }
        GGCompany *companyData = _searchedCompanies[indexPath.row];
        cell.textLabel.text = companyData.name;
        return cell;
    }
    
    static NSString *searchResultCellId = @"searchResultCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchResultCellId];
    }
    
    cell.textLabel.text = @"searchResult";
    return cell;
}

#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    searchBar.frame = _searchBarRectOnNavi;
    [self.navigationController.navigationBar addSubview:searchBar];
    self.viewSearchBg.hidden = NO;
    self.tableViewSearchResult.frame = _tvSearchResultRectShort;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.tableViewSearchResult.frame = _tvSearchResultRect;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_searchTimer invalidate];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(_callSearchCompanySuggestion) userInfo:nil repeats:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"seach button clicked");
    // search and show result
    [_searchTimer invalidate];
    _searchTimer = nil;
    [self _callSearchCompany];
    [searchBar resignFirstResponder];
    
    UIButton *cancelBtn = ((GGSearchBar *)searchBar).cancelButton;
    cancelBtn.enabled = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    DLog(@"cancel button clicked");
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    searchBar.frame = _searchBarRect;
    [self.viewScroll addSubview:searchBar];
    self.viewSearchBg.hidden = YES;
}

#pragma mark - API calls
-(void)_callSearchCompanySuggestion
{
    if (self.searchBar.text.length)
    {
        [GGSharedAPI getCompanySuggestionWithKeyword:self.searchBar.text callback:^(id operation, id aResultObject, NSError *anError) {
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            GGDataPage *page = [parser parseSearchCompany];
            _searchedCompanies = page.items;
            
            [self.tableViewSearchResult reloadData];
        }];
    }
}


-(void)_callSearchCompany
{
    if (self.searchBar.text.length)
    {
        [self showLoadingHUD];
        [GGSharedAPI searchCompaniesWithKeyword:self.searchBar.text page:0 callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            GGDataPage *page = [parser parseSearchCompany];
            _searchedCompanies = page.items;
            
            [self.tableViewSearchResult reloadData];
        }];
    }
}

@end
