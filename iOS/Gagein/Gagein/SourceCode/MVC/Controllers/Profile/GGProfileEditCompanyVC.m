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

@end

@implementation GGProfileEditCompanyVC
{
    NSMutableArray      *_suggestedCompanies;
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
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDimedView)];
    [_viewDimed addGestureRecognizer:tapGest];
    
    _tvSuggestedCompanies.rowHeight = [GGSearchSuggestionCell HEIGHT];
    CGRect tvComRc = _tvSuggestedCompanies.frame;
    tvComRc.size.height = [UIScreen mainScreen].applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height - _viewSearchBar.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT;
    _tvSuggestedCompanies.frame = tvComRc;
    
    _lblComName.text = _userProfile.orgName;
    _lblComWebsite.text = _userProfile.orgWebsite;
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
    [super viewDidUnload];
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
    cell.lblName.textColor = (companyData.getType == kGGCompanyTypePrivate) ? GGSharedColor.gray : GGSharedColor.black;
    cell.lblWebsite.text = companyData.website;
    cell.tag = indexPath.row;
    
    return cell;
}

#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //GGCompany *company = _suggestedCompanies[indexPath.row];
#warning TODO: set company to user profile
}

#pragma mark - GGStyledSearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(GGStyledSearchBar *)searchBar
{
    _viewDimed.hidden = NO;
    return YES;
}

- (void)searchBarTextDidBeginEditing:(GGStyledSearchBar *)searchBar
{
    
}

- (BOOL)searchBarShouldEndEditing:(GGStyledSearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(GGStyledSearchBar *)searchBar
{
    
}

- (BOOL)searchBar:(GGStyledSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location <= 0) {
        _tvSuggestedCompanies.hidden = YES;
    }
    return YES;
}

- (BOOL)searchBarShouldClear:(GGStyledSearchBar *)searchBar
{
    _tvSuggestedCompanies.hidden = YES;
    return YES;
}

- (BOOL)searchBarShouldSearch:(GGStyledSearchBar *)searchBar
{
    [self _callSearchCompanySuggestion];
    return YES;
}

#pragma mark - api calls
-(void)_callSearchCompanySuggestion
{
    NSString *keyword = self.viewSearchBar.tfSearch.text;
    if (keyword.length)
    {
        [self showLoadingHUD];
        [GGSharedAPI getCompanySuggestionWithKeyword:keyword callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            GGDataPage *page = [parser parseSearchCompany];
            [_suggestedCompanies removeAllObjects];
            [_suggestedCompanies addObjectsFromArray:page.items];
            
            _tvSuggestedCompanies.hidden = NO;
            [_tvSuggestedCompanies reloadData];
        }];
    }
}

@end
