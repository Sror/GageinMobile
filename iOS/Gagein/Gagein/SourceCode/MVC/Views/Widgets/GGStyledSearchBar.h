//
//  GGStyledSearchBar.h
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGBaseSearchBar;

@protocol GGStyledSearchBarDelegate
 @optional
- (BOOL)searchBarShouldBeginEditing:(GGBaseSearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(GGBaseSearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(GGBaseSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(GGBaseSearchBar *)searchBar;
- (BOOL)searchBar:(GGBaseSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (BOOL)searchBarShouldClear:(GGBaseSearchBar *)searchBar;
- (BOOL)searchBarShouldSearch:(GGBaseSearchBar *)searchBar;
- (void)searchBarCanceled:(GGBaseSearchBar *)searchBar;
@end


//
@interface GGBaseSearchBar : UIView <UITextFieldDelegate>
@property (weak) NSObject<GGStyledSearchBarDelegate>       *delegate;
@end


//
@interface GGStyledSearchBar : GGBaseSearchBar
@property (weak, nonatomic) IBOutlet UIImageView    *ivBg;
@property (weak, nonatomic) IBOutlet UIImageView    *ivSearchIcon;
@property (weak, nonatomic) IBOutlet UITextField    *tfSearch;
@property (weak, nonatomic) IBOutlet UIButton       *btnCancel;

@property (assign)  BOOL        manuallyControlCancelButton;

-(void)showCancelButton:(BOOL)aShow animated:(BOOL)animated;

@end


//
@interface GGBlackSearchBar : GGBaseSearchBar 
@property (weak, nonatomic) IBOutlet UIView *viewSearchField;
@property (weak, nonatomic) IBOutlet UIImageView *ivSearchBg;
@property (weak, nonatomic) IBOutlet UIImageView *ivSearchGlass;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;


-(void)showCancelButton:(BOOL)aShow animated:(BOOL)animated;

@end
