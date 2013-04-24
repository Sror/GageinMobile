//
//  GGComUpdateSearchVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComUpdateSearchVC.h"
#import "GGSearchBar.h"
#import "GGKeywordExampleView.h"

#define SEARCH_BAR_HEIGHT   44

@interface GGComUpdateSearchVC ()
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation GGComUpdateSearchVC
{
    GGSearchBar             *_searchBar;
    GGKeywordExampleView    *_keywordExampleView;
    
    CGRect                 _tvRect;
    CGRect                _tvRectShort;
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
    [super viewDidLoad];
    
    CGRect searchRc = CGRectMake(0
                                 , (self.navigationController.navigationBar.frame.size.height - SEARCH_BAR_HEIGHT) / 2 + 4
                                 , self.view.bounds.size.width
                                 , SEARCH_BAR_HEIGHT);
    _searchBar = [[GGSearchBar alloc] initWithFrame:searchRc];
    _searchBar.delegate = self;
    _searchBar.text = self.keyword;
    _searchBar.showsCancelButton = YES;
    [_searchBar becomeFirstResponder];
    
    
    _tvRect = self.view.bounds;
    float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT + self.tabBarController.tabBar.frame.size.height;
    _tvRectShort = [GGUtils setH:height rect:_tvRect];
    
    //
    _keywordExampleView = [GGKeywordExampleView viewFromNibWithOwner:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideBackButton];
    [self.navigationController.navigationBar addSubview:_searchBar];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_searchBar removeFromSuperview];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = @"keyword";
    
    return cell;
}

#pragma mark - table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _keywordExampleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _keywordExampleView.frame.size.height;
}

#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.tv.frame = _tvRectShort;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //self.tableViewSearchResult.frame = _tvSearchResultRect;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    [_searchTimer invalidate];
//    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(_callSearchCompanySuggestion) userInfo:nil repeats:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"seach button clicked");
//    // search and show result
//    [_searchTimer invalidate];
//    _searchTimer = nil;
//    [self _callSearchCompany];
//    [searchBar resignFirstResponder];
//    
//    UIButton *cancelBtn = ((GGSearchBar *)searchBar).cancelButton;
//    cancelBtn.enabled = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    DLog(@"cancel button clicked");
    [self.navigationController popViewControllerAnimated:YES];
    [searchBar resignFirstResponder];
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
}

- (void)viewDidUnload {
    [self setTv:nil];
    [super viewDidUnload];
}
@end
