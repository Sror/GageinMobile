//
//  GGStyledSearchBar.h
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGStyledSearchBar;

@protocol GGStyledSearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(GGStyledSearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(GGStyledSearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(GGStyledSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(GGStyledSearchBar *)searchBar;
- (BOOL)searchBar:(GGStyledSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (BOOL)searchBarShouldClear:(GGStyledSearchBar *)searchBar;
- (BOOL)searchBarShouldSearch:(GGStyledSearchBar *)searchBar;
@end

@interface GGStyledSearchBar : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView    *ivBg;
@property (weak, nonatomic) IBOutlet UIImageView    *ivSearchIcon;
@property (weak, nonatomic) IBOutlet UITextField    *tfSearch;
@property NSObject<GGStyledSearchBarDelegate>       *delegate;
@end
