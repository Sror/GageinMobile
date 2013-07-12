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
    
//#warning XXX: this two boolean value should be replaced by real judgement for salesforce and linkedIn account.
    BOOL                _needImportFromSalesforce;
    BOOL                _needImportFromLinkedIn;
    
    NSUInteger          _pageNumberFollowedPeople;
    NSUInteger          _pageNumberSuggestedPeople;
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
    
    //
    _searchBar = [GGStyledSearchBar viewFromNibWithOwner:self];
    _searchBar.tfSearch.placeholder = @"Search for people";
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.delegate = self;
    [self.svContent addSubview:_searchBar];
    
    _searchBarRect = _searchBar.frame;
    _searchBarRect.size.width = _svContent.frame.size.width;
    _searchBar.frame = _searchBarRect;
    
    _searchBarRectOnNavi = CGRectMake((self.navigationController.navigationBar.frame.size.width - _searchBarRect.size.width) / 2
                                      , (self.navigationController.navigationBar.frame.size.height - _searchBarRect.size.height) / 2
                                      , _searchBarRect.size.width
                                      , _searchBarRect.size.height);
    
    //
    //
    if (ISIPADDEVICE)
    {
        CGRect dimBgRc = _viewSearchBg.frame;
        dimBgRc.origin.y = CGRectGetMaxY(_searchBar.frame);
        dimBgRc.size.height = _viewSearchBg.superview.frame.size.height - dimBgRc.origin.y;
        _viewSearchBg.frame = dimBgRc;
    }
    
    //
//    if (!ISIPADDEVICE)
//    {
//        float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT + self.tabBarController.tabBar.frame.size.height;
//        _tvSearchResultRectShort = [GGUtils setH:height rect:self.tvSearchResult.frame];
//        self.tvSearchResult.frame = _tvSearchResultRectShort;
//    }
    
    self.tvSearchResult.rowHeight = [GGSearchSuggestionCell HEIGHT];
    
    
    _tapGestToHideSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideSearch:)];
    [_viewSearchTransparent addGestureRecognizer:_tapGestToHideSearch];
    
    //
    //_tvPeople.tableHeaderView = _viewTvPeopleHeader;
    _tvPeople.backgroundColor = GGSharedColor.silver;
    _tvPeople.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tvPeople.rowHeight = [GGGroupedCell HEIGHT];
    
    // for now, both flags are set to NO, to hide the import buttons since API is not ready --- Daniel Dong
    _needImportFromLinkedIn = NO;
    _needImportFromSalesforce = NO;
    [self _adjustStyleForSuggestedHeaderView];
    
    [self _showTitle:YES];
    [self _showDoneBtn:YES];
    
    [self _getAllFollowedPeople];
    [self _getAllSuggestedPeople];
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
    [self naviBackAction:nil];
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
        [cell.ivLogo applyEffectCircleSilverBorder];
        cell.lblName.text = data.name;
        cell.lblWebsite.text = data.orgTitle;
        cell.tag = indexPath.row;
        
        return cell;
    }
    
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
                [self showLoadingHUD];
                id op = [GGSharedAPI unfollowPersonWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
                    [self hideLoadingHUD];
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        data.followed = NO;
                        
                        [self postNotification:GG_NOTIFY_PERSON_FOLLOW_CHANGED];
                        
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    else
                    {
                        [GGAlert alertWithApiParser:parser];
                    }
                }];
                
                [self registerOperation:op];
            }
            else    // follow him
            {
                [self showLoadingHUD];
                id op = [GGSharedAPI followPersonWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
                    [self hideLoadingHUD];
                    GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                    if (parser.isOK)
                    {
                        data.followed = YES;
                        
                        [self postNotification:GG_NOTIFY_PERSON_FOLLOW_CHANGED];
                        
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    else
                    {
                        [GGAlert alertWithApiParser:parser];
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
            [self showLoadingHUD];
            id op = [GGSharedAPI followPersonWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
                
                [self hideLoadingHUD];
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    [self postNotification:GG_NOTIFY_PERSON_FOLLOW_CHANGED];
                    
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
                        
                        NSArray *updateIndexs = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
                        
                        [self.tvPeople insertRowsAtIndexPaths:updateIndexs withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                        if (_followedPeople.count > 1)
                        {
                            [self.tvPeople reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        }
                        
                    }
                    
                    //[self _cancelSearch];
                    [self searchBarCanceled:_searchBar];
                }
                else
                {
                    [GGAlert alertWithApiParser:parser];
                }
            }];
            
            [self registerOperation:op];
        }
    }
}


#pragma mark - scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tvSearchResult)
    {
        [_searchBar endEditing:YES];
    }
}

#pragma mark - GGStyledSearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(GGBaseSearchBar *)searchBar
{
    if (!ISIPADDEVICE)
    {
        // install the search bar to the navigation bar
        searchBar.frame = _searchBarRectOnNavi;
        [self.navigationController.navigationBar addSubview:searchBar];
        
        [self _showDoneBtn:NO];
        [self _showTitle:NO];
        //[self hideBackButton];
    }
    
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
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(_callSearchPeopleSuggestion) userInfo:nil repeats:NO];
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
    [_searchBar.tfSearch resignFirstResponder];
    self.viewSearchBg.hidden = YES;
    
    if (!ISIPADDEVICE)
    {
        _searchBar.frame = _searchBarRect;
        [_svContent addSubview:_searchBar];
        
        [self _showDoneBtn:YES];
        [self _showTitle:YES];
    }
}

- (BOOL)searchBarShouldSearch:(GGBaseSearchBar *)searchBar
{
    DLog(@"seach button clicked");
    // search and show result
    [_searchTimer invalidate];
    _searchTimer = nil;
    [self _callSearchPeople];
    [searchBar endEditing:YES];
    
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
    NSString *keyword = _searchBar.tfSearch.text;
    if (keyword.length)
    {
//#warning TODO: Currently no API for people suggestion
        //getSuggestedPeopleWithKeyword
        [self showLoadingHUDWithOffsetY:-100];
        id op = [GGSharedAPI getSuggestedPeopleWithKeyword:keyword page:0 callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                GGDataPage *page = [parser parseGetSeggestedPeople];
                _searchedPeople = page.items;
//                if (_searchedPeople.count <= 0) {
//                    [GGAlert alertWithMessage:@"No results."];
//                }
            }
            
            [_tvSearchResult reloadData];
        }];
        
        [self registerOperation:op];
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
                [GGAlert alertWithMessage:@"No results."];
            }
            
            [self.tvSearchResult reloadData];
        }];
        
        [self registerOperation:op];
    }
}

-(void)_getAllFollowedPeople
{
    _pageNumberFollowedPeople = 1;
    [self _callGetAllFollowedPeople];
}


#pragma mark - 递归调用
-(void)_callGetAllFollowedPeople
{
    //#warning TODO: Currently no API for followed people list
    [self showLoadingHUD];
    id op = [GGSharedAPI getFollowedPeopleWithPage:_pageNumberFollowedPeople callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetFollowedPeople];
            
            if (_pageNumberFollowedPeople == 1)
            {
                [_followedPeople removeAllObjects];
            }
            
            [_followedPeople addObjectsFromArray:page.items];
            
            if (page.hasMore)
            {
                _pageNumberFollowedPeople++;
                [self _callGetAllFollowedPeople];
            }
        }
        
        [_tvPeople reloadData];
        
    }];
    
    [self registerOperation:op];
}

//-(void)_callGetFollowedPeople
//{
//    [self showLoadingHUD];
//    id op = [GGSharedAPI getFollowedPeopleWithPage:0 callback:^(id operation, id aResultObject, NSError *anError) {
//        [self hideLoadingHUD];
//        
//        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//        if (parser.isOK)
//        {
//            GGDataPage *page = [parser parseGetFollowedPeople];
//            [_followedPeople removeAllObjects];
//            [_followedPeople addObjectsFromArray:page.items];
//        }
//        
//        [_tvPeople reloadData];
//        
//    }];
//    
//    [self registerOperation:op];
//}

-(void)_getAllSuggestedPeople
{
    _pageNumberSuggestedPeople = 1;
    [self _callGetAllRecommendedPeople];
}

#pragma mark - 递归调用
-(void)_callGetAllRecommendedPeople
{
    [self showLoadingHUD];
    id op = [GGSharedAPI getRecommendedPeopleWithPage:_pageNumberSuggestedPeople callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetRecommendedPeople];
            
            if (_pageNumberSuggestedPeople == 1)
            {
                [_suggestedPeople removeAllObjects];
            }
            
            [_suggestedPeople addObjectsFromArray:page.items];
            
            if (page.hasMore)
            {
                _pageNumberSuggestedPeople++;
                [self _callGetAllRecommendedPeople];
            }
        }
        
        [_tvPeople reloadData];
    }];
    
    [self registerOperation:op];
}

//-(void)_callGetRecommendedPeople
//{
//    [self showLoadingHUD];
//    id op = [GGSharedAPI getRecommendedPeopleWithPage:0 callback:^(id operation, id aResultObject, NSError *anError) {
//        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//        if (parser.isOK)
//        {
//            GGDataPage *page = [parser parseGetRecommendedPeople];
//            [_suggestedPeople removeAllObjects];
//            [_suggestedPeople addObjectsFromArray:page.items];
//        }
//        
//        [_tvPeople reloadData];
//    }];
//    
//    [self registerOperation:op];
//}

@end
