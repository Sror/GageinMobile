//
//  GGStyledSearchBar.m
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGStyledSearchBar.h"

#define CANCEL_SPACE_LEN        70
#define FILTER_SPACE_LEN        30

@implementation GGBaseSearchBar

#pragma mark - text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return [_delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [_delegate searchBarTextDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [_delegate searchBarShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        [_delegate searchBarTextDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([_delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
        return [_delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(searchBarShouldClear:)]) {
        return [_delegate searchBarShouldClear:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(searchBarShouldSearch:)]) {
        return [_delegate searchBarShouldSearch:self];
    }
    return YES;
}


@end


//
@implementation GGStyledSearchBar
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!_manuallyControlCancelButton)
    {
        [self showCancelButton:YES animated:YES];
    }
    
    [super textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!_manuallyControlCancelButton)
    {
        [self showCancelButton:NO animated:YES];
    }
    
    [super textFieldDidEndEditing:textField];
}


-(void)awakeFromNib
{
    _btnCancel.hidden = YES;
    _btnCancel.layer.cornerRadius = 10.f;
    [_btnCancel addTarget:self action:@selector(_cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.backgroundColor = GGSharedColor.darkRed;
}

-(void)_cancelAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchBarCanceled:)]) {
        [self.delegate searchBarCanceled:self];
    }
}

-(void)showCancelButton:(BOOL)aShow animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:.3f animations:^{
            [self _showCancelButton:aShow];
        }];
    }
    else
    {
        [self _showCancelButton:aShow];
    }
}

-(void)_showCancelButton:(BOOL)aShow
{
//    float width = (aShow) ? self.frame.size.width - CANCEL_SPACE_LEN : self.frame.size.width - FILTER_SPACE_LEN;
//    
//    CGRect searchRc = _viewSearchField.frame;
//    searchRc.size.width = width;
//    _viewSearchField.frame = searchRc;
//    
//    CGRect cancelRc = _btnCancel.frame;
//    cancelRc.origin.x = searchRc.size.width;
//    _btnCancel.frame = cancelRc;
    
    _btnCancel.hidden = !aShow;
    
//    float filterX = aShow ? self.frame.size.width : (self.frame.size.width - FILTER_SPACE_LEN - 5);
//    CGRect filterRc = _btnFilter.frame;
//    filterRc.origin.x = filterX;
//    _btnFilter.frame = filterRc;
//    
//    _btnFilter.hidden = aShow;
}


-(BOOL)resignFirstResponder
{
    [_tfSearch resignFirstResponder];
    
    return [super resignFirstResponder];
}
@end




///////////////////////////////////////////
@implementation GGBlackSearchBar

-(void)awakeFromNib
{
    self.backgroundColor = GGSharedColor.graySettingBg;
    _ivSearchBg.image = [[UIImage imageNamed:@"searchBgDarkRound"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 20, 16, 20)];
    _tfSearch.text = @"";
    
    [_btnCancel addTarget:self action:@selector(_cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.backgroundColor = GGSharedColor.darkRed;
}

-(void)_cancelAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchBarCanceled:)]) {
        [self.delegate searchBarCanceled:self];
    }
}

-(void)showCancelButton:(BOOL)aShow animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:.3f animations:^{
            [self _showCancelButton:aShow];
        }];
    }
    else
    {
        [self _showCancelButton:aShow];
    }
}

-(void)_showCancelButton:(BOOL)aShow
{
    float width = (aShow) ? self.frame.size.width - CANCEL_SPACE_LEN : self.frame.size.width - FILTER_SPACE_LEN;
    
    CGRect searchRc = _viewSearchField.frame;
    searchRc.size.width = width;
    _viewSearchField.frame = searchRc;
    
    CGRect cancelRc = _btnCancel.frame;
    cancelRc.origin.x = searchRc.size.width;
    _btnCancel.frame = cancelRc;
    
    _btnCancel.hidden = !aShow;
    
    float filterX = aShow ? self.frame.size.width : (self.frame.size.width - FILTER_SPACE_LEN - 5);
    CGRect filterRc = _btnFilter.frame;
    filterRc.origin.x = filterX;
    _btnFilter.frame = filterRc;
    
    _btnFilter.hidden = aShow;
}

-(BOOL)resignFirstResponder
{
    [_tfSearch resignFirstResponder];
    
    return [super resignFirstResponder];
}

@end


