//
//  GGProfileEditCompanyVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileEditCompanyVC.h"

#import "GGUserProfile.h"
//#import "GGCompanySearchCell.h"
#import "GGSearchSuggestionCell.h"
#import "GGCompany.h"
#import "GGDataPage.h"

@interface GGProfileEditCompanyVC ()
@property (weak, nonatomic) IBOutlet UIView *viewComInfo;
@property (weak, nonatomic) IBOutlet UIImageView *ivComInfoBg;
@property (weak, nonatomic) IBOutlet UIImageView *ivComLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblComName;
@property (weak, nonatomic) IBOutlet UILabel *lblComWebsite;

@property (weak, nonatomic) IBOutlet UIView *viewDimed;
@property (weak, nonatomic) IBOutlet UITableView *tvSuggestedCompanies;
@property (weak, nonatomic) IBOutlet GGStyledSearchBar *viewSearchBar;

@property (weak, nonatomic) IBOutlet UIView *viewComInfoDefined;
@property (weak, nonatomic) IBOutlet UIView *viewComInfoCustom;
@property (weak, nonatomic) IBOutlet UILabel *lblComNameCustom;

@end

@implementation GGProfileEditCompanyVC
{
    NSMutableArray      *_suggestedCompanies;
    NSTimer             *_searchTimer;
    NSString            *_customComName;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _suggestedCompanies = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"Company";
    _ivComInfoBg.image = GGSharedImagePool.tableCellRoundBg;
    _viewSearchBar = [GGUtils replaceFromNibForView:_viewSearchBar];
    _viewSearchBar.delegate = self;
    _viewSearchBar.tfSearch.returnKeyType = UIReturnKeyDone;
    _viewSearchBar.tfSearch.placeholder = @"Your new company";
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDimedView)];
    [_viewDimed addGestureRecognizer:tapGest];
    
    _tvSuggestedCompanies.rowHeight = [GGSearchSuggestionCell HEIGHT];
    CGRect tvComRc = _tvSuggestedCompanies.frame;
    tvComRc.size.height = [GGLayout pageRectWithLayoutElement:kLayoutElementStatusBar | kLayoutElementNaviBar].size.height - _viewSearchBar.frame.size.height;
    _tvSuggestedCompanies.frame = tvComRc;
    
    [self _updateUiIsComanyCustomed];
}

-(void)_updateUiIsComanyCustomed
{
    BOOL isCustomCompany = (_userProfile.orgID <= 0);
    _viewComInfoDefined.hidden = isCustomCompany;
    _viewComInfoCustom.hidden = !isCustomCompany;
    [self hideDimedView];
    
    if (isCustomCompany)
    {
        _lblComNameCustom.text = _userProfile.orgName;
    }
    else
    {
        _lblComName.text = _userProfile.orgName;
        _lblComWebsite.text = _userProfile.orgWebsite;
        [_ivComLogo setImageWithURL:[NSURL URLWithString:_userProfile.orgLogoPath] placeholderImage:GGSharedImagePool.placeholder];
    }
}

- (void)viewDidUnload {
    [self setViewComInfo:nil];
    [self setIvComInfoBg:nil];
    [self setIvComLogo:nil];
    [self setLblComName:nil];
    [self setLblComWebsite:nil];
    [self setViewDimed:nil];
    [self setTvSuggestedCompanies:nil];
    [self setViewSearchBar:nil];
    [self setViewComInfoDefined:nil];
    [self setViewComInfoCustom:nil];
    [self setLblComNameCustom:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [_searchTimer invalidate];
    _searchTimer = nil;
}

#pragma mark - 
-(void)hideDimedView
{
    [_viewSearchBar.tfSearch resignFirstResponder];
    _viewSearchBar.tfSearch.text = @"";
    _viewDimed.hidden = YES;
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _suggestedCompanies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *searchResultCellId = @"GGSearchSuggestionCell";
    GGSearchSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellId];
    if (cell == nil) {
        cell = [GGSearchSuggestionCell viewFromNibWithOwner:self];
    }
    
    GGCompany *companyData = _suggestedCompanies[indexPath.row];
    [cell.ivLogo setImageWithURL:[NSURL URLWithString:companyData.logoPath] placeholderImage:nil];
    cell.lblName.text = companyData.name;
    cell.lblName.textColor = [GGSharedColor colorForCompanyGrade:companyData.getGrade];
    cell.lblWebsite.text = companyData.website;
    cell.tag = indexPath.row;
    
    return cell;
}

#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGCompany *company = _suggestedCompanies[indexPath.row];
//#warning TODO: set company to user profile
    
    [self showLoadingHUD];
    id op = [GGSharedAPI changeProfileWithOrgID:company.ID callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _userProfile.orgID = company.ID;
            _userProfile.orgName = company.name;
            _userProfile.orgWebsite = company.website;
            _userProfile.orgLogoPath = company.logoPath;
            
            [self _updateUiIsComanyCustomed];
            [self naviBackAction:nil];
            //[GGAlert alertWithMessage:@"Company changed OK!"];
        }
        else
        {
            //[GGAlert alertWithMessage:@"Failed"];
        }
        
        [self.viewSearchBar.tfSearch resignFirstResponder];
        _tvSuggestedCompanies.hidden = YES;
    }];
    
    [self registerOperation:op];
}

#pragma mark - scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tvSuggestedCompanies)
    {
        [_viewSearchBar endEditing:YES];
    }
}

#pragma mark - GGStyledSearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(GGBaseSearchBar *)searchBar
{
    _viewDimed.hidden = NO;
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
    if (range.location <= 0)
    {
        _tvSuggestedCompanies.hidden = YES;
    }
    else
    {
        [_searchTimer invalidate];
        _searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(_callSearchCompanySuggestion) userInfo:nil repeats:NO];
    }
    
    return YES;
}

- (BOOL)searchBarShouldClear:(GGBaseSearchBar *)searchBar
{
    _tvSuggestedCompanies.hidden = YES;
    return YES;
}

- (void)searchBarCanceled:(GGBaseSearchBar *)searchBar
{
    [self hideDimedView];
}

- (BOOL)searchBarShouldSearch:(GGBaseSearchBar *)searchBar
{
    [_searchTimer invalidate];
    _searchTimer = nil;
    //[self _callSearchCompanySuggestion];
    
    _customComName = _viewSearchBar.tfSearch.text;
    if (_customComName.length)
    {
        [self showLoadingHUD];
        id op = [GGSharedAPI changeProfileWithOrgName:_customComName callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _userProfile.orgID = 0;
                _userProfile.orgName = _customComName;
                _userProfile.orgWebsite = nil;
                _userProfile.orgLogoPath = nil;
                
                [self _updateUiIsComanyCustomed];
                //[GGAlert alertWithMessage:@"Company changed OK!"];
            }
            
            [self.viewSearchBar.tfSearch resignFirstResponder];
            _tvSuggestedCompanies.hidden = YES;
        }];
        
        [self registerOperation:op];
    }
    
    
    return YES;
}

#pragma mark - api calls
-(void)_callSearchCompanySuggestion
{
    NSString *keyword = self.viewSearchBar.tfSearch.text;
    if (keyword.length)
    {
        [self showLoadingHUD];
        id op = [GGSharedAPI getCompanySuggestionWithKeyword:keyword callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                GGDataPage *page = [parser parseSearchCompany];
                [_suggestedCompanies removeAllObjects];
                [_suggestedCompanies addObjectsFromArray:page.items];
                
                _tvSuggestedCompanies.hidden = NO;
                [_tvSuggestedCompanies reloadData];
            }
            
        }];
        
        [self registerOperation:op];
    }
}

#pragma mark -
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_viewComInfo centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

@end
