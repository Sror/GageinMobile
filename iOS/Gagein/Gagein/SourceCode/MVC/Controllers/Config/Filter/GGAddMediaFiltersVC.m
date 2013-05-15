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

@end

@implementation GGAddMediaFiltersVC
{
    NSMutableArray      *_suggestedMeidaFilters;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _suggestedMeidaFilters = [NSMutableArray array];
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
    //_tvSuggested.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(doneAction:)];
    [self hideBackButton];
    
    //
    _viewSearchBar = [GGUtils replaceFromNibForView:_viewSearchBar];
    
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
    [GGSharedAPI getMediaSuggestedList:^(id operation, id aResultObject, NSError *anError) {
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
}

- (void)viewDidUnload {
    [self setViewSearchBar:nil];
    [self setTvSuggested:nil];
    [super viewDidUnload];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _suggestedMeidaFilters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"GGGroupedCell";
    int row = indexPath.row;
    
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
    }
    
    GGMediaFilter *data = _suggestedMeidaFilters[row];
    cell.lblTitle.text = data.name;
    //[self _setStyleForSuggestedCell:cell index:row];
    cell.style = [GGUtils styleForArrayCount:_suggestedMeidaFilters.count atIndex:row];
    
    return cell;
}

#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
