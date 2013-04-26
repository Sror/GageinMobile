//
//  GGStyledSearchBar.m
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGStyledSearchBar.h"

@implementation GGStyledSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

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
    [_delegate searchBarTextDidBeginEditing:self];
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
    [_delegate searchBarTextDidEndEditing:self];
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
