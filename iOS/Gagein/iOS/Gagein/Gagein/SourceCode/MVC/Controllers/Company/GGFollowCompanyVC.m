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
#import "GGCompanySearchCell.h"

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
    NSMutableArray      *_followedCompanies;
    NSMutableArray      *_suggestedCompanies;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _searchedCompanies = [NSMutableArray array];
        _followedCompanies = [NSMutableArray array];
        _suggestedCompanies = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.veryLightGray;
    
    
    _searchBarRect = self.searchBar.frame;
    _searchBarRectOnNavi = CGRectMake(10, (self.navigationController.navigationBar.frame.size.height - _searchBarRect.size.height) / 2, _searchBarRect.size.width, _searchBarRect.size.height);
    _tvSearchResultRect = self.tableViewSearchResult.frame;
    float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT + self.tabBarController.tabBar.frame.size.height;
    _tvSearchResultRectShort = [GGUtils setH:height rect:_tvSearchResultRect];
    
    self.tableViewSearchResult.rowHeight = [GGCompanySearchCell HEIGHT];
    
    [self _showTitle:YES];
    [self _showDoneBtn:YES];
    
    [self _callGetFollowedCompanies];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackButton];
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

#pragma mark - internal
-(void)_showDoneBtn:(BOOL)aShow
{
    if (aShow)
    {
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
        self.navigationItem.rightBarButtonItem = doneBtn;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)_showTitle:(BOOL)aShow
{
    if (aShow)
    {
        self.title = @"Follow Companies";
    }
    else
    {
        self.title = @"";
    }
}

-(BOOL)_isCompanyFollowed:(long long)aComanyID
{
    for (GGCompany *company in _followedCompanies)
    {
        if (company.ID == aComanyID && company.followed)
        {
            return YES;
        }
    }
    
    return NO;
}

-(int)_indexInFollowedListWithCompanyID:(long long)aComanyID
{
    NSUInteger count = _followedCompanies.count;
    for (int i = 0; i < count; i++)
    {
        GGCompany *company = _followedCompanies[i];
        if (company.ID == aComanyID)
        {
            return i;
        }
    }
    
    return NSNotFound;
}

#pragma mark - actions
-(void)doneAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableViewSearchResult)
    {
        return 1;
    }
    
    if (_suggestedCompanies.count) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableViewSearchResult) {
        self.tableViewSearchResult.hidden = (_searchedCompanies.count <= 0);
        return _searchedCompanies.count;
    }
    
    return _followedCompanies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableViewSearchResult) {
        static NSString *searchResultCellId = @"GGCompanySearchCell";
        GGCompanySearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellId];
        if (cell == nil) {
            cell = [GGCompanySearchCell viewFromNibWithOwner:self];
        }
        
        GGCompany *companyData = _searchedCompanies[indexPath.row];
        [cell.ivLogo setImageWithURL:[NSURL URLWithString:companyData.logoPath] placeholderImage:nil];
        cell.lblName.text = companyData.name;
        cell.lblName.textColor = (companyData.getType == kGGCompanyTypePrivate) ? GGSharedColor.gray : GGSharedColor.black;
        cell.lblWebsite.text = companyData.website;
        cell.tag = indexPath.row;
        
        return cell;
    }
    
    /////
    static NSString *companyCellId = @"companyCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companyCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companyCellId];
    }
    
    GGCompany *companyData = _followedCompanies[indexPath.row];
    cell.textLabel.text = companyData.name;
    cell.accessoryType = companyData.followed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableViewCompanies)
    {
        if (section == 0)
        {
            return @"Followed Companies";
        }
        else if (section == 1)
        {
            return @"Suggested Companies";
        }
    }
    
    return nil;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableViewCompanies)
    {
        if (indexPath.section == 0)
        {
            GGCompany *company = _followedCompanies[indexPath.row];
            
            if (company.followed)
            {
                [GGSharedAPI unfollowCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        company.followed = NO;
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    else
                    {
                        [GGAlert alert:parser.message];
                    }
                }];
            }
            else
            {
                [GGSharedAPI followCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        company.followed = YES;
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    else
                    {
                        [GGAlert alert:parser.message];
                    }
                }];
            }
        }
    }
    else if (tableView == self.tableViewSearchResult)
    {
        GGCompany *company = _searchedCompanies[indexPath.row];

        
        if ([self _isCompanyFollowed:company.ID])
        {
            [GGAlert alert:@"Ops, You have already followed this company."];
        }
        else if (company.getType == kGGCompanyTypePrivate)
        {
            [GGAlert alert:@"Sorry, You can't follow this company, please upgrade your plan."];
        }
        else
        {
            [GGSharedAPI followCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    int indexInFollowedList = [self _indexInFollowedListWithCompanyID:company.ID];
                    if (indexInFollowedList != NSNotFound)
                    {
                        GGCompany *followedCompany = _followedCompanies[indexInFollowedList];
                        followedCompany.followed = YES;
                        
                        [self.tableViewCompanies reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexInFollowedList inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    else
                    {
                        company.followed = YES;
                        [_followedCompanies insertObject:company atIndex:0];
                        
                        [self.tableViewCompanies insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    
                    
                    [self searchBarCancelButtonClicked:self.searchBar];
                }
                else
                {
                    [GGAlert alert:parser.message];
                }
            }];
        }
    }
}

#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    searchBar.frame = _searchBarRectOnNavi;
    
    [self.navigationController.navigationBar addSubview:searchBar];
    [self _showDoneBtn:NO];
    [self _showTitle:NO];
    //[self hideBackButton];
    
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
    
    [_searchedCompanies removeAllObjects];
    [self.tableViewSearchResult reloadData];
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    searchBar.frame = _searchBarRect;
    [self.viewScroll addSubview:searchBar];
    
    [self _showTitle:YES];
    [self _showDoneBtn:YES];
    //[self hideBackButton];
    
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
            if (_searchedCompanies.count <= 0) {
                [GGAlert alert:@"Sorry, No company matched."];
            }
            
            [self.tableViewSearchResult reloadData];
        }];
    }
}

-(void)_callGetFollowedCompanies
{
    [GGSharedAPI getFollowedCompaniesWithPage:0 callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseFollowedCompanies];
        _followedCompanies = page.items;
        
        for (GGCompany *company in _followedCompanies) {
            company.followed = 1;
        }
        
        [self.tableViewCompanies reloadData];
    }];
}

@end
