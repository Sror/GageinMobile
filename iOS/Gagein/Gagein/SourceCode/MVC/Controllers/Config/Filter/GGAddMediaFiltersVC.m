//
//  GGAddMediaFiltersVC.m
//  Gagein
//
//  Created by Dong Yiming on 5/15/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGAddMediaFiltersVC.h"
#import "GGMediaFilter.h"
#import "GGDataPage.h"
#import "GGStyledSearchBar.h"
#import "GGGroupedCell.h"

@interface GGAddMediaFiltersVC ()
@property (weak, nonatomic) IBOutlet GGStyledSearchBar *viewSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tvSuggested;
@property (weak, nonatomic) IBOutlet UITableView *tvSearchResult;

@end

@implementation GGAddMediaFiltersVC
{
    NSMutableArray      *_suggestedMeidaFilters;
    NSMutableArray      *_searchedMediaFilters;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _suggestedMeidaFilters = [NSMutableArray array];
        _searchedMediaFilters = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"Add Sources";
    self.view.backgroundColor = GGSharedColor.silver;
    _tvSuggested.rowHeight = [GGGroupedCell HEIGHT];
    _tvSuggested.backgroundColor = GGSharedColor.clear;
    
    _tvSearchResult.hidden = YES;
    
    if (!ISIPADDEVICE)
    {
        CGRect tvSearchRc = _tvSearchResult.frame;
        tvSearchRc.size.height = [UIScreen mainScreen].applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT - _viewSearchBar.frame.size.height;
        _tvSearchResult.frame = tvSearchRc;
    }
    
    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(doneAction:)];
    [self hideBackButton];
    
    //
    _viewSearchBar = [GGUtils replaceFromNibForView:_viewSearchBar];
    _viewSearchBar.tfSearch.placeholder = @"Search for media";
    _viewSearchBar.delegate = self;
    
    [self _callApiGetSuggestedMediaFilters];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackButton];
}


#pragma mark - actions
-(void)doneAction:(id)sender
{
    [self naviBackAction:sender];
}

#pragma mark - api calls
-(void)_callApiGetSuggestedMediaFilters
{
    [self showLoadingHUD];
    id op = [GGSharedAPI getMediaSuggestedList:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetMediaFiltersList];
            [_suggestedMeidaFilters removeAllObjects];
            for (GGMediaFilter *filter in page.items)
            {
                [_suggestedMeidaFilters addObject:filter];
            }
        }
        
        [_tvSuggested reloadData];
    }];
    
    [self registerOperation:op];
}

- (void)viewDidUnload {
    [self setViewSearchBar:nil];
    [self setTvSuggested:nil];
    [self setTvSearchResult:nil];
    [super viewDidUnload];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tvSuggested) {
        return _suggestedMeidaFilters.count;
    }
    
    return _searchedMediaFilters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (tableView == _tvSuggested) {
        
        static NSString *cellID = @"GGGroupedCell";
        
        GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [GGGroupedCell viewFromNibWithOwner:self];
        }
        
        GGMediaFilter *data = _suggestedMeidaFilters[row];
        cell.lblTitle.text = data.name;
        cell.style = [GGUtils styleForArrayCount:_suggestedMeidaFilters.count atIndex:row];
        cell.checked = data.checked;
        
        return cell;
        
    }
    
    static NSString *cellID = @"searchCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    GGMediaFilter *data = _searchedMediaFilters[row];
    cell.textLabel.text = data.name;
    
    return cell;
}

#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = indexPath.row;
    
    if (tableView == _tvSuggested)
    {
        
        GGMediaFilter *data = _suggestedMeidaFilters[row];
        
        if (data.checked)
        {
            [self showLoadingHUD];
            id op = [GGSharedAPI deleteMediaFilterWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
                [self hideLoadingHUD];
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    data.checked = NO;
                    [_tvSuggested reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
            
            [self registerOperation:op];
        }
        else
        {
            [self showLoadingHUD];
            id op = [GGSharedAPI addMediaFilterWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
                [self hideLoadingHUD];
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    data.checked = YES;
                    [_tvSuggested reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
            
            [self registerOperation:op];
        }
        
    }
    else
    {
        GGMediaFilter *data = _searchedMediaFilters[row];
        
        [self showLoadingHUD];
        id op = [GGSharedAPI addMediaFilterWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                data.checked = YES;
                [self naviBackAction:nil];
            }
        }];
        
        [self registerOperation:op];
    }
    
}


#pragma mark - GGStyledSearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(GGBaseSearchBar *)searchBar
{
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
    if (range.location <= 0) {
        _tvSearchResult.hidden = YES;
    }
    //DLog(@"range:%d, %d", range.location, range.length);
    return YES;
}

- (BOOL)searchBarShouldClear:(GGBaseSearchBar *)searchBar
{
    _tvSearchResult.hidden = YES;
    return YES;
}

- (BOOL)searchBarShouldSearch:(GGBaseSearchBar *)searchBar
{
    NSString *keyword = ((GGStyledSearchBar *)searchBar).tfSearch.text;
    if (keyword.length)
    {
        [self showLoadingHUD];
        id op = [GGSharedAPI searchMediaWithKeyword:keyword callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                GGDataPage *page = [parser parseGetMediaFiltersList];
                [_searchedMediaFilters removeAllObjects];
                [_searchedMediaFilters addObjectsFromArray:page.items];
                
                _tvSearchResult.hidden = NO;
                [_tvSearchResult reloadData];
            }
        }];
        
        [self registerOperation:op];
    }
    return YES;
}


@end
