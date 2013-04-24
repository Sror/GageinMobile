//
//  GGComUpdateSearchVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComUpdateSearchVC.h"
#import "GGSearchBar.h"
#import "GGKeywordExampleCell.h"
#import "GGComUpdateSearchResultVC.h"

#define SEARCH_BAR_HEIGHT   44

@interface GGComUpdateSearchVC ()
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation GGComUpdateSearchVC
{
    NSMutableArray          *_suggestedKeywords;
    GGSearchBar             *_searchBar;
    GGKeywordExampleCell    *_keywordExampleCell;
    
    CGRect                 _tvRect;
    CGRect                _tvRectShort;
    
    NSTimer                 *_searchTimer;
    
    BOOL                    _isFirstTimeDidAppear;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _suggestedKeywords = [NSMutableArray array];
        _isFirstTimeDidAppear = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initSearchBar];
    [self.navigationController.navigationBar addSubview:_searchBar];
    
    _tvRect = self.view.bounds;
    float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT + self.tabBarController.tabBar.frame.size.height;
    _tvRectShort = [GGUtils setH:height rect:_tvRect];
    
    //
    _keywordExampleCell = [GGKeywordExampleCell viewFromNibWithOwner:self];
}

-(void)_initSearchBar
{
    CGRect searchRc = CGRectMake(0
                                 , (self.navigationController.navigationBar.frame.size.height - SEARCH_BAR_HEIGHT) / 2 + 4
                                 , self.view.bounds.size.width
                                 , SEARCH_BAR_HEIGHT);
    
    [_searchBar removeFromSuperview];
    _searchBar = [[GGSearchBar alloc] initWithFrame:searchRc];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.text = self.keyword;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideBackButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _searchBar.hidden = NO;
    [self.navigationController.navigationBar addSubview:_searchBar];
    
    if (_isFirstTimeDidAppear)
    {
        _isFirstTimeDidAppear = NO;
        [self _callApiGetSuggestions];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _searchBar.hidden = YES;
    [self.view addSubview:_searchBar];
}

- (void)viewDidUnload {
    [self setTv:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [_searchBar removeFromSuperview];
}

#pragma mark - actions
-(void)_doSearch:(NSString *)aKeyword
{
    if (!aKeyword.length) { return;}
    
    [_searchTimer invalidate];
    _searchTimer = nil;
    
    GGComUpdateSearchResultVC *vc = [[GGComUpdateSearchResultVC alloc] init];
    vc.keyword = aKeyword;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [_searchBar resignFirstResponder];
}

-(void)_refreshTimer
{
    [_searchTimer invalidate];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(_callApiGetSuggestions) userInfo:nil repeats:NO];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _suggestedKeywords.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (row == _suggestedKeywords.count)
    {
        return _keywordExampleCell;
    }
    else
    {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSString *keyword = _suggestedKeywords[indexPath.row];
        cell.textLabel.text = keyword;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - table view delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _suggestedKeywords.count)
    {
        return [GGKeywordExampleCell HEIGHT];
    }
    
    return 44.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < _suggestedKeywords.count)
    {
        [self _doSearch:_suggestedKeywords[indexPath.row]];
    }
}

#pragma mark - scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
    self.tv.frame = _tvRect;
}

#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.tv.frame = _tvRectShort;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _searchBar.cancelButton.enabled = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self _refreshTimer];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"seach button clicked");
    // search and show result
    [self _doSearch:_searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    DLog(@"cancel button clicked");
    [self.navigationController popViewControllerAnimated:YES];
    [searchBar resignFirstResponder];
}

-(void)_callApiGetSuggestions
{
    if (_searchBar.text.length)
    {
        [self showLoadingHUD];
        [GGSharedAPI getUpdateSuggestionWithKeyword:_searchBar.text callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [_suggestedKeywords removeAllObjects];
                NSArray *keywords = parser.dataInfos;
                for (NSDictionary *dic in keywords)
                {
                    [_suggestedKeywords addObject:[dic objectForKey:@"keywords"]];
                }
            }
            
            [_tv reloadData];
        }];
    }
}


@end
