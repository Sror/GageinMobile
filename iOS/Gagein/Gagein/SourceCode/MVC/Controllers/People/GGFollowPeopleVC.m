//
//  GGFollowPeopleVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGFollowPeopleVC.h"


@interface GGFollowPeopleVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (weak, nonatomic) IBOutlet UITableView *tvPeople;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBg;
@property (weak, nonatomic) IBOutlet UITableView *tvSearchResult;

@end

@implementation GGFollowPeopleVC
{
    GGStyledSearchBar *_searchBar;
    
    CGRect              _tvSearchResultRect;
    CGRect              _tvSearchResultRectShort;
    
    NSTimer             *_searchTimer;
    
    NSMutableArray      *_searchedPeople;
    NSMutableArray      *_followedPeople;
    NSMutableArray      *_suggestedPeople;
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
    [self.svContent addSubview:_searchBar];
    
    _tvSearchResultRect = self.tvSearchResult.frame;
    float height = self.view.frame.size.height - GG_KEY_BOARD_HEIGHT_IPHONE_PORTRAIT + self.tabBarController.tabBar.frame.size.height;
    _tvSearchResultRectShort = [GGUtils setH:height rect:_tvSearchResultRect];
}

- (void)viewDidUnload {
    [self setSvContent:nil];
    [self setBtnLinkedIn:nil];
    [self setTvPeople:nil];
    [self setViewSearchBg:nil];
    [self setTvSearchResult:nil];
    [super viewDidUnload];
}

#pragma mark - styled search bar delegate
- (BOOL)searchBarShouldBeginEditing:(GGStyledSearchBar *)searchBar
{
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
    return YES;
}

- (BOOL)searchBarShouldClear:(GGStyledSearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBarShouldSearch:(GGStyledSearchBar *)searchBar
{
    return YES;
}

@end
