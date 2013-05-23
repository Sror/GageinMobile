//
//  GGProfileEditJobTitleVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileEditJobTitleVC.h"
#import "GGUserProfile.h"

@interface GGProfileEditJobTitleVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfJobTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end

@implementation GGProfileEditJobTitleVC

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
    self.naviTitle = @"Job Title";
    
    [_btnSave setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
    [_btnSave addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _tfJobTitle.text = _userProfile.orgTitle;
}



- (void)viewDidUnload {
    [self setTfJobTitle:nil];
    [self setBtnSave:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(void)saveAction:(id)sender
{
    if (_tfJobTitle.text.length <= 0)
    {
        [_tfJobTitle becomeFirstResponder];
        [GGAlert alertWithMessage:@"You should enter your a Job Title."];
    }
    
    else
    {
        [self showLoadingHUD];
        id op = [GGSharedAPI changeProfileWithTitle:_tfJobTitle.text callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _userProfile.orgTitle = _tfJobTitle.text;
                [GGAlert alertWithMessage:@"Job title changed OK!"];
                [self naviBackAction:nil];
            }
        }];
        
        [self registerOperation:op];
    }
}



@end
