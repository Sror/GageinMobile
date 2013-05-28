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

#import "GGGroupedCell.h"
#import "GGConfigLabel.h"

@interface GGFollowPeopleVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;
@property (weak, nonatomic) IBOutlet UITableView *tvPeople;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBg;
@property (weak, nonatomic) IBOutlet UIView *viewSearchTransparent;

@property (weak, nonatomic) IBOutlet UITableView *tvSearchResult;

@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (strong, nonatomic) IBOutlet UIView *viewTvPeopleHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnSalesforce;

@end

@implementation GGFollowPeopleVC
{
    GGStyledSearchBar *_searchBar;
    
    CGRect              _searchBarRect;
    CGRect              _searchBarRectOnNavi;
    
    //CGRect              _tvSearchResultRect;
    CGRect              _tvSearchResultRectShort;
    
    NSTimer             *_searchTimer;
    
    NSMutableArray      *_searchedPeople;
    NSMutableArray      *_followedPeople;
    NSMutableArray      *_suggestedPeople;
    
    UITapGestureRecognizer        *_tapGestToHideSearch;
    
#warning XXX: this two boolean value should be replaced by real judgement for salesforce and linkedIn account.
    BOOL                _needImportFromSalesforce;
    BOOL                _needImportFromLinkedIn;
}

#define BUTTON_WIDTH_LONG       247.f
#define BUTTON_WIDTH_SHORT      116.f
#define BUTTON_HEIGHT           31.f
-(void)_adjustStyleForSuggestedHeaderView
{
    _tvPeople.tableHeaderView = (!_needImportFromLinkedIn && !_needImportFromSalesforce) ? nil : _viewTvPeopleHeader;
    
    CGRect headerRc = _viewTvPeopleHeader.frame;
    _btnSalesforce.hidden = _btnLinkedIn.hidden = YES;
    
    if (_needImportFromLinkedIn && _needImportFromSalesforce)
    {
        // case 1
        float horiGap = (headerRc.size.width - BUTTON_WIDTH_SHORT * 2) / 3;
        CGRect salesBtnRc = _btnSalesforce.frame;
        salesBtnRc.size.width = BUTTON_WIDTH_SHORT;
        salesBtnRc.origin.x = horiGap;
        _btnSalesforce.frame = salesBtnRc;
        [_btnSalesforce setImage:[UIImage imageNamed:@"salesForceBtnBg"] forState:UIControlStateNormal];
        
        CGRect linkedInRc = _btnLinkedIn.frame;
        linkedInRc.size.width = BUTTON_WIDTH_SHORT;
        linkedInRc.origin.x = headerRc.size.width - horiGap - BUTTON_WIDTH_SHORT;
        _btnLinkedIn.frame = linkedInRc;
        [_btnLinkedIn setImage:[UIImage imageNamed:@"linkedInBtnBg"] forState:UIControlStateNormal];
        
        _btnSalesforce.hidden = _btnLinkedIn.hidden = NO;
    }
    else if (_needImportFromSalesforce)
    {
        // case 2
        // salesForceLongBtnBg
        
        CGRect salesBtnRc = _btnLinkedIn.frame;
        salesBtnRc.size.width = BUTTON_WIDTH_LONG;
        salesBtnRc.origin.x = (headerRc.size.width - BUTTON_WIDTH_LONG) / 2;
        _btnSalesforce.frame = salesBtnRc;
        [_btnSalesforce setImage:[UIImage imageNamed:@"salesForceLongBtnBg"] forState:UIControlStateNormal];
        
        _btnSalesforce.hidden = NO;
    }
    else if (_needImportFromLinkedIn)
    {
        // case 3
        // linkedInLongBtnBg
        
        CGRect linkedInRc = _btnLinkedIn.frame;
        linkedInRc.size.width = BUTTON_WIDTH_LONG;
        linkedInRc.origin.x = (headerRc.size.width - BUTTON_WIDTH_LONG) / 2;
        _btnLinkedIn.frame = linkedInRc;
        [_btnLinkedIn setImage:[UIImage imageNamed:@"linkedInLongBtnBg"] forState:UIControlStateNormal];
        
        _btnLinkedIn.hidden = NO;
    }
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
    _searchBar.tfSearch.placeholder = @"Search for people";
    _searchBar.delegate = self;
    [self.svContent addSubview:_searchBar];
    
    _searchBarRect = _searchBar.frame;
    _searchBarRectOnNavi = CGRectMake((self.navigationController.navigationBar.frame.size.width - _searchBarRect.size.width) / 2
                                      , (self.navigationController.navigationBar.frame.size.height - _searchBarRect.size.height) / 2
                                      , _searchBarRect.size.width
                                      , _searchBarRect.size.height);
    
    //_tvSearchResultRect = self.tvSearchResult.frame;
    float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT + self.tabBarController.tabBar.frame.size.height;
    _tvSearchResultRectShort = [GGUtils setH:height rect:self.tvSearchResult.frame];
    self.tvSearchResult.frame = _tvSearchResultRectShort;
    
    self.tvSearchResult.rowHeight = [GGSearchSuggestionCell HEIGHT];
    
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
//    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(doneAction:)];
    
    _tapGestToHideSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideSearch:)];
    [_viewSearchTransparent addGestureRecognizer:_tapGestToHideSearch];
    
    //
    //_tvPeople.tableHeaderView = _viewTvPeopleHeader;
    _tvPeople.backgroundColor = GGSharedColor.silver;
    _tvPeople.rowHeight = [GGGroupedCell HEIGHT];
    
    //
    _needImportFromLinkedIn = NO;
    _needImportFromSalesforce = NO;
    [self _adjustStyleForSuggestedHeaderView];
    
    [self _showTitle:YES];
    [self _showDoneBtn:YES];
    
    [self _callGetFollowedPeople];
}

-(void)tapToHideSearch:(UITapGestureRecognizer *)aTapGest
{
    [self searchBarCanceled:_searchBar];
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
    [self setViewTvPeopleHeader:nil];
    [self setViewSearchTransparent:nil];
    [self setBtnSalesforce:nil];
    [super viewDidUnload];
}

#pragma mark - internal
-(void)_showDoneBtn:(BOOL)aShow
{
    if (aShow)
    {
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
        self.title = @"Follow People";
    }
    else
    {
        self.title = @"";
    }
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
    int row = indexPath.row;
    
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
//    static NSString *companyCellId = @"companyCellId";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companyCellId];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companyCellId];
//    }
//    
//    GGPerson *data = _followedPeople[indexPath.row];
//    cell.textLabel.text = data.name;
//    cell.accessoryType = data.followed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
//    
//    return cell;
    
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
    }
    
    GGPerson *data = _followedPeople[row];
    
    cell.lblTitle.text = data.name;
    cell.tag = row;
    
    cell.style = [GGUtils styleForArrayCount:_followedPeople.count atIndex:row];
    
    cell.checked = data.followed;
    [cell showSubTitle:NO];
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (tableView == self.tvPeople)
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
    if (tableView == _tvPeople)
    {
        GGConfigLabel *configLabel = [GGConfigLabel viewFromNibWithOwner:self];
        if (section == 0)
        {
            configLabel.lblText.text = @"FOLLOWED PEOPLE";
        }
        else if (section == 1)
        {
            configLabel.lblText.text = @"SUGGESTED PEOPLE";
        }
        
        return configLabel;
    }
    
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tvPeople)
    {
        return [GGConfigLabel HEIGHT];
    }
    
    return 0.f;
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
            
            if (data.followed)  // unfollow him
            {
#warning TODO: No follow/unfollow person API
                id op = [GGSharedAPI unfollowPersonWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        data.followed = NO;
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    else
                    {
                        [GGAlert alertWithApiMessage:parser.message];
                    }
                }];
                
                [self registerOperation:op];
            }
            else    // follow him
            {
                id op = [GGSharedAPI followPersonWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        data.followed = YES;
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
    else if (tableView == self.tvSearchResult)
    {
        GGPerson *data = _searchedPeople[row];
        
        
        if ([self _isPersonFollowed:data.ID])
        {
            [GGAlert alertWithMessage:@"Ops, You have already followed this company."];
        }
        else
        {
            id op = [GGSharedAPI followPersonWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
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
                    
                    //[self _cancelSearch];
                    [self searchBarCanceled:_searchBar];
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
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(_callSearchPeopleSuggestion) userInfo:nil repeats:NO];
}

- (BOOL)searchBarShouldClear:(GGBaseSearchBar *)searchBar
{
    [_searchTimer invalidate];
    _searchTimer = nil;
    _tvSearchResult.hidden = YES;
    
    return YES;
}

- (void)searchBarCanceled:(GGBaseSearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    _searchBar.frame = _searchBarRect;
    [_svContent addSubview:_searchBar];
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
    [self _callSearchPeople];
    //[searchBar resignFirstResponder];
    
    //    UIButton *cancelBtn = ((GGSearchBar *)searchBar).cancelButton;
    //    cancelBtn.enabled = YES;
    
    return YES;
}

-(NSString *)_searchText
{
    return _searchBar.tfSearch.text;
}


#pragma mark - styled search bar delegate
//-(void)_cancelSearch
//{
//    [_searchBar resignFirstResponder];
//    _viewSearchBg.hidden = YES;
//}

//- (BOOL)searchBarShouldBeginEditing:(GGBaseSearchBar *)searchBar
//{
//    return YES;
//}
//
//- (void)searchBarTextDidBeginEditing:(GGBaseSearchBar *)searchBar
//{
//    self.viewSearchBg.hidden = NO;
//    self.tvSearchResult.frame = _tvSearchResultRectShort;
//}
//
//- (BOOL)searchBarShouldEndEditing:(GGBaseSearchBar *)searchBar
//{
//    return YES;
//}
//
//- (void)searchBarTextDidEndEditing:(GGBaseSearchBar *)searchBar
//{
//    self.tvSearchResult.frame = _tvSearchResultRect;
//}

//- (BOOL)searchBar:(GGBaseSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    [_searchTimer invalidate];
//    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(_callSearchPeopleSuggestion) userInfo:nil repeats:NO];
//    
//    return YES;
//}

//- (BOOL)searchBarShouldClear:(GGBaseSearchBar *)searchBar
//{
//    return YES;
//}
//
//- (BOOL)searchBarShouldSearch:(GGBaseSearchBar *)searchBar
//{
//    [_searchTimer invalidate];
//    _searchTimer = nil;
//    [self _callSearchPeople];
//    [((GGStyledSearchBar *)searchBar).tfSearch resignFirstResponder];
//    
//    return YES;
//}

#pragma mark - API calls
-(void)_callSearchPeopleSuggestion
{
    if (_searchBar.tfSearch.text.length)
    {
#warning TODO: Currently no API for people suggestion

    }
}


-(void)_callSearchPeople
{
    if (_searchBar.tfSearch.text.length)
    {
        [self showLoadingHUD];
        id op = [GGSharedAPI searchPeopleWithKeyword:_searchBar.tfSearch.text page:0 callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            GGDataPage *page = [parser parseSearchForPeople];
            _searchedPeople = page.items;
            if (_searchedPeople.count <= 0) {
                [GGAlert alertWithMessage:@"Sorry, No person matched."];
            }
            
            [self.tvSearchResult reloadData];
        }];
        
        [self registerOperation:op];
    }
}

-(void)_callGetFollowedPeople
{
#warning TODO: Currently no API for followed people list
}

@end
