//
//  GGProfileEditNameVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileEditNameVC.h"
#import "GGUserProfile.h"

@interface GGProfileEditNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (weak, nonatomic) IBOutlet UIImageView *ivTfBgFirst;
@property (weak, nonatomic) IBOutlet UIImageView *ivTfBgSecond;
@property (weak, nonatomic) IBOutlet UIScrollView *viewScorll;

@end

@implementation GGProfileEditNameVC

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
    self.view.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"Name";
    
    self.ivTfBgFirst.image = GGSharedImagePool.tableCellRoundBg;
    self.ivTfBgSecond.image = GGSharedImagePool.tableCellRoundBg;
    
    [_btnSave setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
    [_btnSave addTarget:self action:@selector(saveNameAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _tfFirstName.text = _userProfile.firstName;
    _tfLastName.text = _userProfile.lastName;
}


- (void)viewDidUnload {
    [self setTfFirstName:nil];
    [self setTfLastName:nil];
    [self setBtnSave:nil];
    [self setViewContent:nil];
    [self setIvTfBgFirst:nil];
    [self setIvTfBgSecond:nil];
    [self setViewScorll:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(void)saveNameAction:(id)sender
{
    if (_tfFirstName.text.length <= 0)
    {
        [_tfFirstName becomeFirstResponder];
        [GGAlert alertWithMessage:@"You should enter your first name."];
    }
    else if (_tfLastName.text.length <= 0)
    {
        [_tfLastName becomeFirstResponder];
        [GGAlert alertWithMessage:@"You should enter your last name."];
    }
    else
    {
        id op = [GGSharedAPI changeProfileWithFirstName:_tfFirstName.text lastName:_tfLastName.text callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _userProfile.firstName = _tfFirstName.text;
                _userProfile.lastName = _tfLastName.text;
                [GGAlert alertWithMessage:@"Name changed OK!"];
                [self naviBackAction:nil];
            }
        }];
        
        [self registerOperation:op];
    }
}

#pragma mark - text field delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!ISIPADDEVICE)
    {
        if (textField == _tfFirstName)
        {
            [_viewScorll setContentOffset:CGPointMake(0, 10) animated:YES];
        }
        else if (textField == _tfLastName)
        {
            [_viewScorll setContentOffset:CGPointMake(0, 50) animated:YES];
        }
    }
}

#pragma mark - scroll view delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!ISIPADDEVICE)
    {
        [_viewScorll setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.view resignAllResponders];
    }
}

#pragma mark -
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_viewContent centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

@end
