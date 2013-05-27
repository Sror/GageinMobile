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
#import "GGSearchSuggestionCell.h"
#import "GGConfigLabel.h"
#import "GGGroupedCell.h"

@interface GGFollowCompanyVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *viewScroll;
//@property (weak, nonatomic) IBOutlet GGSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UIButton *btnSalesForce;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCompanies;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBg;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearchResult;
@property (weak, nonatomic) IBOutlet GGStyledSearchBar *viewSearchBar;
@property (weak, nonatomic) IBOutlet UIView *viewSearchTransparent;
@property (weak, nonatomic) IBOutlet UIView *viewTvCompaniesHeader;

@end

@implementation GGFollowCompanyVC
{
    CGRect              _searchBarRect;
    CGRect              _searchBarRectOnNavi;
    //CGRect              _tvSearchResultRect;
    CGRect              _tvSearchResultRectShort;
    
    NSTimer             *_searchTimer;
    
    NSMutableArray      *_searchedCompanies;
    NSMutableArray      *_followedCompanies;
    NSMutableArray      *_suggestedCompanies;
    
    UITapGestureRecognizer          *_tapGestToHideSearch;
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
    self.naviTitle = @"Follow Companies";
    self.view.backgroundColor = GGSharedColor.veryLightGray;
    
    // replace the search bar placeholder view with the real search bar
    _viewSearchBar = [GGUtils replaceFromNibForView:_viewSearchBar];
    _viewSearchBar.tfSearch.placeholder = @"Search for companies";
    _viewSearchBar.delegate = self;
    
    // record the rect of the search bar, and calculate the rect of the search bar when it becomes the first responder.
    _searchBarRect = self.viewSearchBar.frame;
    _searchBarRectOnNavi = CGRectMake((self.navigationController.navigationBar.frame.size.width - _searchBarRect.size.width) / 2
                                      , (self.navigationController.navigationBar.frame.size.height - _searchBarRect.size.height) / 2
                                      , _searchBarRect.size.width
                                      , _searchBarRect.size.height);
    
    //_tvSearchResultRect = self.tableViewSearchResult.frame;
    float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT + self.tabBarController.tabBar.frame.size.height;
    _tvSearchResultRectShort = [GGUtils setH:height rect:self.tableViewSearchResult.frame];
    self.tableViewSearchResult.frame = _tvSearchResultRectShort;
    
    self.tableViewSearchResult.rowHeight = [GGSearchSuggestionCell HEIGHT];
    
    //
    _tapGestToHideSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideSearch:)];
    [_viewSearchTransparent addGestureRecognizer:_tapGestToHideSearch];
    
    //
    //[_viewTvCompaniesHeader removeFromSuperview];
    _tableViewCompanies.tableHeaderView = _viewTvCompaniesHeader;
    _tableViewCompanies.backgroundColor = GGSharedColor.silver;
    _tableViewCompanies.rowHeight = [GGGroupedCell HEIGHT];
    
    [self _showTitle:YES];
    [self _showDoneBtn:YES];
    
    
    [self _callGetFollowedCompanies];
}

-(void)tapToHideSearch:(UITapGestureRecognizer *)aTapGest
{
    [self searchBarCanceled:_viewSearchBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackButton];
}


- (void)viewDidUnload {
    [self setViewScroll:nil];
    //[self setSearchBar:nil];
    [self setLblTip:nil];
    [self setBtnSalesForce:nil];
    [self setBtnLinkedIn:nil];
    [self setTableViewCompanies:nil];
    [self setViewSearchBg:nil];
    [self setTableViewSearchResult:nil];
    [self setViewSearchBar:nil];
    [self setViewSearchTransparent:nil];
    [self setViewTvCompaniesHeader:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [_searchTimer invalidate];
    _searchTimer = nil;
}

#pragma mark - internal
-(void)_showDoneBtn:(BOOL)aShow
{
    if (aShow)
    {
//        UIButton *doneBtn = [GGUtils darkGrayButtonWithTitle:@"Done" frame:CGRectMake(0, 0, 100, 30)];
//        [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
        //[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
        self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(doneAction:)];;
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
    int row = indexPath.row;
    //int section = indexPath.section;
    
    if (tableView == self.tableViewSearchResult) {
        static NSString *searchResultCellId = @"GGSearchSuggestionCell";
        GGSearchSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellId];
        if (cell == nil) {
            cell = [GGSearchSuggestionCell viewFromNibWithOwner:self];
        }
        
        GGCompany *companyData = _searchedCompanies[row];
        [cell.ivLogo setImageWithURL:[NSURL URLWithString:companyData.logoPath] placeholderImage:nil];
        cell.lblName.text = companyData.name;
        cell.lblName.textColor = (companyData.getType == kGGCompanyTypePrivate) ? GGSharedColor.gray : GGSharedColor.black;
        cell.lblWebsite.text = companyData.website;
        cell.tag = indexPath.row;
        
        return cell;
    }
    
    /////
//    static NSString *companyCellId = @"companyCellId";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companyCellId];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companyCellId];
//    }
//    
//    GGCompany *companyData = _followedCompanies[indexPath.row];
//    cell.textLabel.text = companyData.name;
//    cell.accessoryType = companyData.followed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
//    
//    return cell;
    
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
    }
    
    GGCompany *data = _followedCompanies[indexPath.row];
    
    cell.lblTitle.text = data.name;
    cell.tag = row;
    
    cell.style = [GGUtils styleForArrayCount:_followedCompanies.count atIndex:row];
    
    cell.checked = data.followed;
    [cell showSubTitle:NO];
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (tableView == self.tableViewCompanies)
//    {
//        if (section == 0)
//        {
//            return @"Followed Companies";
//        }
//        else if (section == 1)
//        {
//            return @"Suggested Companies";
//        }
//    }
//    
//    return nil;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableViewCompanies)
    {
        GGConfigLabel *configLabel = [GGConfigLabel viewFromNibWithOwner:self];
        if (section == 0)
        {
            configLabel.lblText.text = @"FOLLOWED COMPANIES";
        }
        else if (section == 1)
        {
            configLabel.lblText.text = @"SUGGESTED COMPANIES";
        }
        
        return configLabel;
    }
    
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableViewCompanies)
    {
        return [GGConfigLabel HEIGHT];
    }
    
    return 0.f;
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
                id op = [GGSharedAPI unfollowCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        company.followed = NO;
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    else
                    {
                        [GGAlert alertWithApiMessage:parser.message];
                    }
                }];
                
                [self registerOperation:op];
            }
            else
            {
                id op = [GGSharedAPI followCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        company.followed = YES;
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    else
                    {
                        [GGAlert alertWithApiMessage:parser.message];
                    }
                }];
                
                [self registerOperation:op];
            }
        }
    }
    else if (tableView == self.tableViewSearchResult)
    {
        GGCompany *company = _searchedCompanies[indexPath.row];

        
        if ([self _isCompanyFollowed:company.ID])
        {
            [GGAlert alertWithMessage:@"Ops, You have already followed this company."];
        }
        else if (company.getType == kGGCompanyTypePrivate)
        {
            [GGAlert alertWithMessage:@"Sorry, You can't follow this company, please upgrade your plan."];
        }
        else
        {
            id op = [GGSharedAPI followCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
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
                    
                    
                    //[self searchBarCancelButtonClicked:self.searchBar];
                    [self searchBarCanceled:_viewSearchBar];
                }
                else
                {
                    [GGAlert alertWithApiMessage:parser.message];
                }
            }];
            
            [self registerOperation:op];
        }
    }
}

#pragma mark - GGStyledSearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(GGBaseSearchBar *)searchBar
{
    // install the search bar to the navigation bar
    searchBar.frame = _searchBarRectOnNavi;
    [self.navigationController.navigationBar addSubview:searchBar];
    
    [self _showDoneBtn:NO];
    [self _showTitle:NO];
    //[self hideBackButton];
    
    self.viewSearchBg.hidden = NO;
    //self.tableViewSearchResult.frame = _tvSearchResultRectShort;
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(GGBaseSearchBar *)searchBar
{
    
}

- (BOOL)searchBarShouldEndEditing:(GGBaseSearchBar *)searchBar
{
    
    //self.tableViewSearchResult.frame = _tvSearchResultRect;
    
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(GGBaseSearchBar *)searchBar
{
    
}

- (BOOL)searchBar:(GGBaseSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (range.location <= 0 && text.length <= 0)
    {
        [self searchBarShouldClear:searchBar];
    }
    else
    {
        [self _refreshTimer];
    }
    
    return YES;
}

-(void)_refreshTimer
{
    [_searchTimer invalidate];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(_callSearchCompanySuggestion) userInfo:nil repeats:NO];
}

- (BOOL)searchBarShouldClear:(GGBaseSearchBar *)searchBar
{
    [_searchTimer invalidate];
    _searchTimer = nil;
    _tableViewSearchResult.hidden = YES;
    
    return YES;
}

- (void)searchBarCanceled:(GGBaseSearchBar *)searchBar
{
    [_viewSearchBar resignFirstResponder];
    _viewSearchBar.frame = _searchBarRect;
    [_viewScroll addSubview:_viewSearchBar];
    self.viewSearchBg.hidden = YES;
    
    [self _showDoneBtn:YES];
    [self _showTitle:YES];
}

- (BOOL)searchBarShouldSearch:(GGBaseSearchBar *)searchBar
{
    DLog(@"seach button clicked");
    // search and show result
    [_searchTimer invalidate];
    _searchTimer = nil;
    [self _callSearchCompany];
    //[searchBar resignFirstResponder];
    
//    UIButton *cancelBtn = ((GGSearchBar *)searchBar).cancelButton;
//    cancelBtn.enabled = YES;
    
    return YES;
}

-(NSString *)_searchText
{
    return self.viewSearchBar.tfSearch.text;
}


//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
//{
//    DLog(@"cancel button clicked");
//    
//    [_searchedCompanies removeAllObjects];
//    [self.tableViewSearchResult reloadData];
//    
//    searchBar.text = @"";
//    [searchBar resignFirstResponder];
//    searchBar.showsCancelButton = NO;
//    searchBar.frame = _searchBarRect;
//    [self.viewScroll addSubview:searchBar];
//    
//    [self _showTitle:YES];
//    [self _showDoneBtn:YES];
//    //[self hideBackButton];
//    
//    self.viewSearchBg.hidden = YES;
//}

#pragma mark - API calls
-(void)_callSearchCompanySuggestion
{
    NSString *keyword = [self _searchText];
    if (keyword.length)
    {
        id op = [GGSharedAPI getCompanySuggestionWithKeyword:keyword callback:^(id operation, id aResultObject, NSError *anError) {
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            GGDataPage *page = [parser parseSearchCompany];
            _searchedCompanies = page.items;
            
            [self.tableViewSearchResult reloadData];
        }];
        
        [self registerOperation:op];
    }
}


-(void)_callSearchCompany
{
    NSString *keyword = [self _searchText];
    if (keyword.length)
    {
        [self showLoadingHUD];
        id op = [GGSharedAPI searchCompaniesWithKeyword:keyword page:0 callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            GGDataPage *page = [parser parseSearchCompany];
            _searchedCompanies = page.items;
            if (_searchedCompanies.count <= 0) {
                [GGAlert alertWithMessage:@"Sorry, No company matched."];
            }
            
            [self.tableViewSearchResult reloadData];
        }];
        
        [self registerOperation:op];
    }
}

-(void)_callGetFollowedCompanies
{
    id op = [GGSharedAPI getFollowedCompaniesWithPage:0 callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseFollowedCompanies];
        _followedCompanies = page.items;
        
        for (GGCompany *company in _followedCompanies) {
            company.followed = 1;
        }
        
        [self.tableViewCompanies reloadData];
    }];
    
    [self registerOperation:op];
}

@end
