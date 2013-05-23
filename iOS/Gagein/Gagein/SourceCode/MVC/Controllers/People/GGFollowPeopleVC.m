//
//  GGFollowPeopleVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGFollowPeopleVC.h"
#import "GGSearchSuggestionCell.h"
#import "GGPerson.h"
#import "GGDataPage.h"

@interface GGFollowPeopleVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (weak, nonatomic) IBOutlet UITableView *tvPeople;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBg;
@property (weak, nonatomic) IBOutlet UITableView *tvSearchResult;

@end

@implementation GGFollowPeopleVC
{
    GGStyledSearchBar *_searchBar;
    
    CGRect              _tvSearchResultRect;
    CGRect              _tvSearchResultRectShort;
    
    NSTimer             *_searchTimer;
    
    NSMutableArray      *_searchedPeople;
    NSMutableArray      *_followedPeople;
    NSMutableArray      *_suggestedPeople;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _searchedPeople = [NSMutableArray array];
        _followedPeople = [NSMutableArray array];
        _suggestedPeople = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    
    [super viewDidLoad];
    self.svContent.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"Follow People";
    
    _searchBar = [GGStyledSearchBar viewFromNibWithOwner:self];
    _searchBar.delegate = self;
    [self.svContent addSubview:_searchBar];
    
    _tvSearchResultRect = self.tvSearchResult.frame;
    float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT - _searchBar.frame.size.height + self.tabBarController.tabBar.frame.size.height;
    _tvSearchResultRectShort = [GGUtils setH:height rect:_tvSearchResultRect];
    
    self.tvSearchResult.rowHeight = [GGSearchSuggestionCell HEIGHT];
    
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(doneAction:)];
    
    [self _callGetFollowedPeople];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackButton];
}

- (void)viewDidUnload {
    [self setSvContent:nil];
    [self setBtnLinkedIn:nil];
    [self setTvPeople:nil];
    [self setViewSearchBg:nil];
    [self setTvSearchResult:nil];
    [super viewDidUnload];
}

#pragma mark - helper
-(BOOL)_isPersonFollowed:(long long)aPersonID
{
    for (GGPerson *person in _followedPeople)
    {
        if (person.ID == aPersonID && person.followed)
        {
            return YES;
        }
    }
    
    return NO;
}

-(int)_indexInFollowedListWithPersonID:(long long)aPersonID
{
    NSUInteger count = _followedPeople.count;
    for (int i = 0; i < count; i++)
    {
        GGPerson *person = _followedPeople[i];
        if (person.ID == aPersonID)
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
    if (tableView == self.tvSearchResult)
    {
        return 1;
    }
    
    if (_suggestedPeople.count) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tvSearchResult) {
        self.tvSearchResult.hidden = (_searchedPeople.count <= 0);
        return _searchedPeople.count;
    }
    
    return _followedPeople.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tvSearchResult) {
        static NSString *searchResultCellId = @"GGSearchSuggestionCell";
        GGSearchSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellId];
        if (cell == nil) {
            cell = [GGSearchSuggestionCell viewFromNibWithOwner:self];
        }
        
        GGPerson *data = _searchedPeople[indexPath.row];
        [cell.ivLogo setImageWithURL:[NSURL URLWithString:data.photoPath] placeholderImage:GGSharedImagePool.placeholder];
        cell.lblName.text = data.name;
        cell.lblWebsite.text = data.orgTitle;
        cell.tag = indexPath.row;
        
        return cell;
    }
    
    /////
    static NSString *companyCellId = @"companyCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companyCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companyCellId];
    }
    
    GGPerson *data = _followedPeople[indexPath.row];
    cell.textLabel.text = data.name;
    cell.accessoryType = data.followed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tvPeople)
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
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (tableView == self.tvPeople)
    {
        if (section == 0)
        {
            GGPerson *data = _followedPeople[row];
            
            if (data.followed)
            {
#warning TODO: No follow/unfollow person API
//                [GGSharedAPI unfollowCompanyWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
//                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//                    if (parser.isOK)
//                    {
//                        company.followed = NO;
//                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                    }
//                    else
//                    {
//                        [GGAlert alert:parser.message];
//                    }
//                }];
            }
            else
            {
//                [GGSharedAPI followCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
//                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//                    if (parser.isOK)
//                    {
//                        company.followed = YES;
//                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                    }
//                    else
//                    {
//                        [GGAlert alert:parser.message];
//                    }
//                }];
            }
        }
    }
    else if (tableView == self.tvSearchResult)
    {
        GGPerson *data = _searchedPeople[row];
        
        
        if ([self _isPersonFollowed:data.ID])
        {
            [GGAlert alertWithMessage:@"Ops, You have already followed this company."];
        }
        else
        {
            [GGSharedAPI followPersonWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    int indexInFollowedList = [self _indexInFollowedListWithPersonID:data.ID];
                    if (indexInFollowedList != NSNotFound)
                    {
                        GGPerson *followedPerson = _followedPeople[indexInFollowedList];
                        followedPerson.followed = YES;
                        
                        [self.tvPeople reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexInFollowedList inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    else
                    {
                        data.followed = YES;
                        [_followedPeople insertObject:data atIndex:0];
                        
                        [self.tvPeople insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    
                    [self _cancelSearch];
                }
                else
                {
                    [GGAlert alertWithApiMessage:parser.message];
                }
            }];
        }
    }
}


#pragma mark - styled search bar delegate
-(void)_cancelSearch
{
    [_searchBar.tfSearch resignFirstResponder];
    _viewSearchBg.hidden = YES;
}

- (BOOL)searchBarShouldBeginEditing:(GGBaseSearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(GGBaseSearchBar *)searchBar
{
    self.viewSearchBg.hidden = NO;
    self.tvSearchResult.frame = _tvSearchResultRectShort;
}

- (BOOL)searchBarShouldEndEditing:(GGBaseSearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(GGBaseSearchBar *)searchBar
{
    self.tvSearchResult.frame = _tvSearchResultRect;
}

- (BOOL)searchBar:(GGBaseSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [_searchTimer invalidate];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(_callSearchPeopleSuggestion) userInfo:nil repeats:NO];
    
    return YES;
}

- (BOOL)searchBarShouldClear:(GGBaseSearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBarShouldSearch:(GGBaseSearchBar *)searchBar
{
    [_searchTimer invalidate];
    _searchTimer = nil;
    [self _callSearchPeople];
    [((GGStyledSearchBar *)searchBar).tfSearch resignFirstResponder];
    
    return YES;
}

#pragma mark - API calls
-(void)_callSearchPeopleSuggestion
{
    if (_searchBar.tfSearch.text.length)
    {
#warning Currently no API for people suggestion
//        [GGSharedAPI getCompanySuggestionWithKeyword:_searchBar.tfSearch.text callback:^(id operation, id aResultObject, NSError *anError) {
//            
//            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//            GGDataPage *page = [parser parseSearchCompany];
//            _searchedCompanies = page.items;
//            
//            [self.tableViewSearchResult reloadData];
//        }];
    }
}


-(void)_callSearchPeople
{
    if (_searchBar.tfSearch.text.length)
    {
        [self showLoadingHUD];
        [GGSharedAPI searchPeopleWithKeyword:_searchBar.tfSearch.text page:0 callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            GGDataPage *page = [parser parseSearchForPeople];
            _searchedPeople = page.items;
            if (_searchedPeople.count <= 0) {
                [GGAlert alertWithMessage:@"Sorry, No person matched."];
            }
            
            [self.tvSearchResult reloadData];
        }];
    }
}

-(void)_callGetFollowedPeople
{
#warning Currently no API for followed people list
//    [GGSharedAPI getFollowedCompaniesWithPage:0 callback:^(id operation, id aResultObject, NSError *anError) {
//        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//        GGDataPage *page = [parser parseFollowedCompanies];
//        _followedCompanies = page.items;
//        
//        for (GGCompany *company in _followedCompanies) {
//            company.followed = 1;
//        }
//        
//        [self.tableViewCompanies reloadData];
//    }];
}

@end
