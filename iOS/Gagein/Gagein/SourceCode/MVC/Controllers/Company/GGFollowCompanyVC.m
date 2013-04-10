//
//  GGFollowCompanyVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGFollowCompanyVC.h"
#import "GGSearchBar.h"

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
    CGRect      _searchBarRect;
    CGRect      _searchBarRectOnNavi;
    NSTimer     *_searchTimer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    
    [super viewDidLoad];
    
    _searchBarRect = self.searchBar.frame;
    _searchBarRectOnNavi = CGRectMake(10, (self.navigationController.navigationBar.frame.size.height - _searchBarRect.size.height) / 2, _searchBarRect.size.width, _searchBarRect.size.height);
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
    if (tableView == self.tableViewCompanies) {
        return 10;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableViewCompanies) {
        static NSString *companyCellId = @"companyCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companyCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companyCellId];
        }
        
        cell.textLabel.text = @"company";
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
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    searchBar.frame = _searchBarRect;
    [self.viewScroll addSubview:searchBar];
    self.viewSearchBg.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_searchTimer invalidate];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(_callSearchCompany) userInfo:nil repeats:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"seach button clicked");
    // search and show result
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    DLog(@"cancel button clicked");
    [searchBar resignFirstResponder];
}

#pragma mark - API calls
-(void)_callSearchCompany
{
    if (self.searchBar.text.length)
    {
        //
    }
}

@end
