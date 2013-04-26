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

@end

@implementation GGFollowPeopleVC
{
    GGStyledSearchBar *_searchBar;
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
    self.svContent.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"Follow People";
    
    _searchBar = [GGStyledSearchBar viewFromNibWithOwner:self];
    [self.svContent addSubview:_searchBar];
}

- (void)viewDidUnload {
    [self setSvContent:nil];
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
