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
#import "GGLinkedInOAuthVC.h"
#import "GGCompanyDetailVC.h"

#define BUTTON_WIDTH_LONG       247.f
#define BUTTON_WIDTH_SHORT      116.f
#define BUTTON_HEIGHT           31.f

#define LOADING_OFFSET_Y        (-100.f)

@interface GGFollowCompanyVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *viewScroll;
//@property (weak, nonatomic) IBOutlet GGSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;

@property (weak, nonatomic) IBOutlet UITableView *tableViewCompanies;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBg;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearchResult;
@property (weak, nonatomic) IBOutlet GGStyledSearchBar *viewSearchBar;
@property (weak, nonatomic) IBOutlet UIView *viewSearchTransparent;

@property (strong, nonatomic) IBOutlet UIView *viewTvCompaniesHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnSalesForce;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;

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
    
//#warning XXX: this two boolean value should be replaced by real judgement for salesforce and linkedIn account.
    //BOOL                _needImportFromSalesforce;
    //BOOL                _needImportFromLinkedIn;
    //NSMutableArray      *_snTypes;
    
    NSUInteger          _pageNumberFollowedCompanies;
    NSUInteger          _pageNumberSuggestedCompanies;
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _searchedCompanies = [NSMutableArray array];
        _followedCompanies = [NSMutableArray array];
        _suggestedCompanies = [NSMutableArray array];
        //_snTypes = [NSMutableArray array];
        
        _pageNumberFollowedCompanies = 1;
        _pageNumberSuggestedCompanies = 1;
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    [self observeNotification:GG_NOTIFY_COMPANY_FOLLOW_CHANGED];
    
    [super viewDidLoad];
    self.naviTitle = @"Follow Companies";
    self.view.backgroundColor = GGSharedColor.silver;
    
    // action binding
    [_btnLinkedIn addTarget:self action:@selector(importFromLinkedInAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSalesForce addTarget:self action:@selector(importFromSalesforceAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    //
    if (ISIPADDEVICE)
    {
        CGRect dimBgRc = _viewSearchBg.frame;
        dimBgRc.origin.y = CGRectGetMaxY(_viewSearchBar.frame);
        dimBgRc.size.height = _viewSearchBg.superview.frame.size.height - dimBgRc.origin.y;
        _viewSearchBg.frame = dimBgRc;
    }
    
//    if (!ISIPADDEVICE)
//    {
//        float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT + self.tabBarController.tabBar.frame.size.height;
//        _tvSearchResultRectShort = [GGUtils setH:height rect:self.tableViewSearchResult.frame];
//        self.tableViewSearchResult.frame = _tvSearchResultRectShort;
//    }
    
    self.tableViewSearchResult.rowHeight = [GGSearchSuggestionCell HEIGHT];
    _tableViewSearchResult.showsVerticalScrollIndicator = NO;
    
    //
    _tapGestToHideSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideSearch:)];
    [_viewSearchTransparent addGestureRecognizer:_tapGestToHideSearch];
    
    //
    _tableViewCompanies.backgroundColor = GGSharedColor.silver;
    _tableViewCompanies.rowHeight = [GGGroupedCell HEIGHT];
    
    //
    //_needImportFromLinkedIn = NO;
    //_needImportFromSalesforce = NO;
    
    [self _adjustStyleForSuggestedHeaderView];
    _tableViewCompanies.tableHeaderView = nil;
    
    //
    [self _showTitle:YES];
    [self _showDoneBtn:YES];
    
    
    [self _getAllFollowedCompanies];
    [self _getAllSuggestedCompanies];
    [self _callApiGetSnList];
    
    //_btnSalesForce.hidden = _btnLinkedIn.hidden = YES;
}

-(void)tapToHideSearch:(UITapGestureRecognizer *)aTapGest
{
    [self searchBarCanceled:_viewSearchBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
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

-(void)_adjustStyleForSuggestedHeaderView
{
    id headerView = (![self _needImportFromLinkedIn] && ![self _needImportFromSalesforce]) ? nil : _viewTvCompaniesHeader;
    _tableViewCompanies.tableHeaderView = headerView;
    
    CGRect headerRc = _viewTvCompaniesHeader.frame;
    _btnSalesForce.hidden = _btnLinkedIn.hidden = YES;
    
    if ([self _needImportFromLinkedIn] && [self _needImportFromSalesforce])
    {
        // case 1
        float horiGap = (headerRc.size.width - BUTTON_WIDTH_SHORT * 2) / 3;
        CGRect salesBtnRc = _btnSalesForce.frame;
        salesBtnRc.size.width = BUTTON_WIDTH_SHORT;
        salesBtnRc.origin.x = horiGap;
        _btnSalesForce.frame = salesBtnRc;
        [_btnSalesForce setImage:[UIImage imageNamed:@"salesForceBtnBg"] forState:UIControlStateNormal];
        
        CGRect linkedInRc = _btnLinkedIn.frame;
        linkedInRc.size.width = BUTTON_WIDTH_SHORT;
        linkedInRc.origin.x = headerRc.size.width - horiGap - BUTTON_WIDTH_SHORT;
        _btnLinkedIn.frame = linkedInRc;
        [_btnLinkedIn setImage:[UIImage imageNamed:@"linkedInBtnBg"] forState:UIControlStateNormal];
        
        _btnSalesForce.hidden = _btnLinkedIn.hidden = NO;
    }
    else if ([self _needImportFromSalesforce])
    {
        // case 2
        // salesForceLongBtnBg
        
        CGRect salesBtnRc = _btnLinkedIn.frame;
        salesBtnRc.size.width = BUTTON_WIDTH_LONG;
        salesBtnRc.origin.x = (headerRc.size.width - BUTTON_WIDTH_LONG) / 2;
        _btnSalesForce.frame = salesBtnRc;
        [_btnSalesForce setImage:[UIImage imageNamed:@"salesForceLongBtnBg"] forState:UIControlStateNormal];
        
        _btnSalesForce.hidden = NO;
    }
    else if ([self _needImportFromLinkedIn])
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

#pragma mark - handle notifications
-(void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    NSString *notiName = notification.name;
    //id notiObj = notification.object;
    
    if ([notiName isEqualToString:OA_NOTIFY_LINKEDIN_AUTH_OK])
    {
        [self unobserveNotification:OA_NOTIFY_LINKEDIN_AUTH_OK];
        
        [self showLoadingHUD];
        id op = [GGSharedAPI snSaveLinedInWithToken:self.linkedInAuthView.accessToken.key secret:self.linkedInAuthView.accessToken.secret callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [GGUtils addSnType:kGGSnTypeLinkedIn];
                [self _callImportCompaniesWithSnType:kGGSnTypeLinkedIn];
                [self _adjustStyleForSuggestedHeaderView];
            }
        }];
        
        [self registerOperation:op];
        
    }
//    else if ([notiName isEqualToString:GG_NOTIFY_COMPANY_FOLLOW_CHANGED])
//    {
//        [self _callGetAllFollowedCompanies];
//    }
}

#pragma mark - actions
-(void)doneAction:(id)sender
{
    [self naviBackAction:nil];
}

-(void)importFromLinkedInAction:(id)sender
{
    if ([GGUtils hasLinkedSnType:kGGSnTypeLinkedIn])
    {
        [self _callImportCompaniesWithSnType:kGGSnTypeLinkedIn];
    }
    else
    {
        [self connectLinkedIn];
    }
}

-(void)importFromSalesforceAction:(id)sender
{
    [self connectSalesForce];
    //[self _callImportCompaniesWithSnType:kGGSnTypeSalesforce];
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
    
    if (section == 0)
    {
        return _followedCompanies.count;
    }
    else
    {
        return _suggestedCompanies.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (tableView == self.tableViewSearchResult) {
        static NSString *searchResultCellId = @"GGSearchSuggestionCell";
        GGSearchSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellId];
        if (cell == nil) {
            cell = [GGSearchSuggestionCell viewFromNibWithOwner:self];
            [cell.btnAction addTarget:self action:@selector(followCompanyAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        GGCompany *companyData = _searchedCompanies[row];
        
        [cell.ivLogo setImageWithURL:[NSURL URLWithString:companyData.logoPath] placeholderImage:nil];
        cell.lblName.text = companyData.name;
        cell.lblName.textColor = [GGSharedColor colorForCompanyGrade:companyData.getGrade];
        cell.lblWebsite.text = companyData.website;
        cell.tag = indexPath.row;
        
        cell.btnAction.enabled = !companyData.followed;
        cell.btnAction.tag = row;
        
        if (companyData.followed)
        {
            [cell showMarkCheck];
        }
        else
        {
            [cell showMarkPlus];
        }
        
        return cell;
    }
    
    /////
    
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
    }
    
    
    NSArray *companies = (section == 0) ? _followedCompanies : _suggestedCompanies;

    GGCompany *data = companies[row];
    cell.lblTitle.text = data.name;
    cell.tag = row;
    
    cell.style = [GGUtils styleForArrayCount:companies.count atIndex:row];
    
    cell.checked = data.followed;
    [cell showSubTitle:NO];
    
    return cell;
}

-(void)followCompanyAction:(id)sender
{
    int index = ((UIView *)sender).tag;
    //GGCompany *data = _searchedCompanies[index];
    
    GGCompany *company = _searchedCompanies[index];
    
    
    if ([self _isCompanyFollowed:company.ID])
    {
        [GGAlert alertWithMessage:GGString(@"api_message_already_following_the_company")];
    }
    else if (company.getGrade == kGGComGradeB)
    {
        //#warning MESSAGE NEED TO BE REFINED
        [GGAlert alertWithMessage:GGString(@"Not available to follow.")];
    }
    else
    {
        id op = [GGSharedAPI followCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [self postNotification:GG_NOTIFY_COMPANY_FOLLOW_CHANGED];

// manual or notify, it's a problem. -- D.D.
                
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
                [GGAlert alertWithApiParser:parser];
            }
        }];
        
        [self registerOperation:op];
    }
}

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

-(BOOL)_isExistsInFollowedCompanies:(GGCompany *)aCompany
{
    for (GGCompany *comany in _followedCompanies)
    {
        if (aCompany.ID == comany.ID)
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableViewCompanies)
    {
        NSArray *companies = (section == 0) ? _followedCompanies : _suggestedCompanies;
        
        GGCompany *company = companies[indexPath.row];
        
        if (company.followed)
        {
            [self showLoadingHUD];
            id op = [GGSharedAPI unfollowCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
                [self hideLoadingHUD];
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    company.followed = NO;
                    [self postNotification:GG_NOTIFY_COMPANY_FOLLOW_CHANGED];
                    [tableView reloadData];
                }
                else
                {
                    [GGAlert alertWithApiParser:parser];
                }
            }];
            
            [self registerOperation:op];
        }
        else
        {
            [self showLoadingHUD];
            id op = [GGSharedAPI followCompanyWithID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
                [self hideLoadingHUD];
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    company.followed = YES;
                    [self postNotification:GG_NOTIFY_COMPANY_FOLLOW_CHANGED];
                    
                    if (![self _isExistsInFollowedCompanies:company])
                    {
                        [_followedCompanies addObjectIfNotNil:company];
                    }
                    
                    [tableView reloadData];
                }
                else
                {
                    [GGAlert alertWithApiParser:parser];
                }
            }];
            
            [self registerOperation:op];
        }
    }
    else if (tableView == self.tableViewSearchResult)
    {
        [_viewSearchBar endEditing:YES];
        GGCompany *company = _searchedCompanies[row];
        
        GGCompanyDetailVC   *vc = [[GGCompanyDetailVC alloc] init];
        vc.companyID = company.ID;
        vc.isPresented = YES;
        
        GGNavigationController *nc = [[GGNavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:nc animated:YES completion:nil];
    }
}

#pragma mark - scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableViewSearchResult)
    {
        [_viewSearchBar endEditing:YES];
    }
}

#pragma mark - GGStyledSearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(GGBaseSearchBar *)searchBar
{
    // install the search bar to the navigation bar
    if (!ISIPADDEVICE)
    {
        searchBar.frame = _searchBarRectOnNavi;
        [self.navigationController.navigationBar addSubview:searchBar];
        
        [self _showDoneBtn:NO];
        [self _showTitle:NO];
    }
    
    self.viewSearchBg.hidden = NO;
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(GGBaseSearchBar *)searchBar
{
    
}

- (BOOL)searchBarShouldEndEditing:(GGBaseSearchBar *)searchBar
{
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
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(_callSearchCompanySuggestion) userInfo:nil repeats:NO];
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
    [_viewSearchBar.tfSearch resignFirstResponder];
    //[_viewSearchBar endEditing:YES];
    self.viewSearchBg.hidden = YES;
    
    if (!ISIPADDEVICE)
    {
        _viewSearchBar.frame = _searchBarRect;
        [_viewScroll addSubview:_viewSearchBar];
        
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
    [self _callSearchCompany];
    [_viewSearchBar endEditing:YES];
    
    return YES;
}

-(NSString *)_searchText
{
    return self.viewSearchBar.tfSearch.text;
}


#pragma mark - API calls
-(void)_callSearchCompanySuggestion
{
    NSString *keyword = [self _searchText];
    if (keyword.length)
    {
        [self showLoadingHUDWithOffsetY:LOADING_OFFSET_Y];
        id op = [GGSharedAPI getCompanySuggestionWithKeyword:keyword callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                GGDataPage *page = [parser parseSearchCompany];
                _searchedCompanies = page.items;
                
                [self.tableViewSearchResult reloadData];
            }
            else
            {
                [GGAlert alertWithApiParser:parser];
            }
        }];
        
        [self registerOperation:op];
    }
}



-(void)_callSearchCompany
{
    NSString *keyword = [self _searchText];
    if (keyword.length)
    {
        //[self showLoadingHUDWithOffsetY:LOADING_OFFSET_Y];
        [self showLoadingHUD];
        id op = [GGSharedAPI getCompanySuggestionWithKeyword:keyword callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            
            if (parser.isOK)
            {
                GGDataPage *page = [parser parseSearchCompany];
                _searchedCompanies = page.items;
                if (_searchedCompanies.count <= 0) {
                    [GGAlert showToast:@"No results." inView:self.view];
                }
                
                [self.tableViewSearchResult reloadData];
            }
            else
            {
                [GGAlert alertWithApiParser:parser];
            }
            
        }];
        
        [self registerOperation:op];
    }
}

//#warning TODO: both followed and recommended companies need paging
-(void)_getAllFollowedCompanies
{
    _pageNumberFollowedCompanies = 1;
    [self _callGetAllFollowedCompanies];
}

-(void)_getAllSuggestedCompanies
{
    _pageNumberSuggestedCompanies = 1;
    [self _callGetAllRecommendCompanies];
}

-(void)_callGetAllFollowedCompanies
{
    [self showLoadingHUD];
    id op = [GGSharedAPI getFollowedCompaniesWithPage:_pageNumberFollowedCompanies callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseFollowedCompanies];
            
            if (_pageNumberFollowedCompanies == 1)  // first page
            {
                [_followedCompanies removeAllObjects];
            }
            
            [_followedCompanies addObjectsFromArray:page.items];
            
            for (GGCompany *company in _followedCompanies) {
                company.followed = 1;
            }
            
            if (page.hasMore)
            {
                _pageNumberFollowedCompanies++;
                [self _callGetAllFollowedCompanies];
            }
        }
        
        [self.tableViewCompanies reloadData];
    }];
    
    [self registerOperation:op];
}

-(void)_callGetFollowedCompanies
{
    [self showLoadingHUD];
    id op = [GGSharedAPI getFollowedCompaniesWithPage:0 callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseFollowedCompanies];
            [_followedCompanies removeAllObjects];
            [_followedCompanies addObjectsFromArray:page.items];
            
            for (GGCompany *company in _followedCompanies) {
                company.followed = 1;
            }
        }
        
        [self.tableViewCompanies reloadData];
    }];
    
    [self registerOperation:op];
}

-(void)_callGetAllRecommendCompanies
{
    //#warning TODO: need API for getting recommend companies
    [self showLoadingHUD];
    id op = [GGSharedAPI getRecommendedCompanieWithPage:_pageNumberSuggestedCompanies callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetRecommendedCompanies];
            
            if (_pageNumberFollowedCompanies == 1)
            {
                [_suggestedCompanies removeAllObjects];
            }
            
            [_suggestedCompanies addObjectsFromArray:page.items];
            
            if (page.hasMore)
            {
                _pageNumberSuggestedCompanies ++;
                [self _callGetAllRecommendCompanies];
            }
        }
        
        [self.tableViewCompanies reloadData];
    }];
    
    [self registerOperation:op];
}

-(void)_callGetRecommendCompanies
{
//#warning TODO: need API for getting recommend companies
    [self showLoadingHUD];
    id op = [GGSharedAPI getRecommendedCompanieWithPage:0 callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            if (parser.isOK)
            {
                GGDataPage *page = [parser parseGetRecommendedCompanies];
                [_suggestedCompanies removeAllObjects];
                [_suggestedCompanies addObjectsFromArray:page.items];
            }
            
            [self.tableViewCompanies reloadData];
        }
    }];
    
    [self registerOperation:op];
}

-(void)_callApiGetSnList
{
    id op = [GGSharedAPI snGetList:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            NSArray *snTypes = [parser parseSnGetList];
            [GGSharedRuntimeData.snTypes removeAllObjects];
            [GGSharedRuntimeData.snTypes addObjectsFromArray:snTypes];
            
            [self _adjustStyleForSuggestedHeaderView];
        }
    }];
    
    [self registerOperation:op];
}

-(BOOL)_needImportFromLinkedIn
{
    return (![GGUtils hasLinkedSnType:kGGSnTypeLinkedIn]);
}

-(BOOL)_needImportFromSalesforce
{
    return (![GGUtils hasLinkedSnType:kGGSnTypeSalesforce]);
}

-(void)_callImportCompaniesWithSnType:(EGGSnType)aSnType
{
    [self showLoadingHUD];
    id op = [GGSharedAPI importCompaniesWithType:aSnType callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseImportCompanies];
            NSMutableArray *newSuggestedCompanies = [NSMutableArray arrayWithArray:page.items];
            [newSuggestedCompanies addObjectsFromArray:_suggestedCompanies];
            _suggestedCompanies = newSuggestedCompanies;
        }
        
        [self.tableViewCompanies reloadData];
    }];
    
    [self registerOperation:op];
}

@end
