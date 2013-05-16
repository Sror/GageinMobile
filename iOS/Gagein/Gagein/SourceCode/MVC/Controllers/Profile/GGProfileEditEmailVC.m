//
//  GGProfileEditEmailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileEditEmailVC.h"
#import "GGUserProfile.h"

@interface GGProfileEditEmailVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end

@implementation GGProfileEditEmailVC

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
    self.naviTitle = @"Email";
    
    [_btnSave setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
    [_btnSave addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _tfEmail.text = _userProfile.email;
}


- (void)viewDidUnload {
    [self setTfEmail:nil];
    [self setBtnSave:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(void)saveAction:(id)sender
{
    if (_tfEmail.text.length <= 0)
    {
        [_tfEmail becomeFirstResponder];
        [GGAlert alert:@"You should enter your an Email address."];
    }
   
    else
    {
        [GGSharedAPI changeProfileWithEmail:_tfEmail.text callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _userProfile.email = _tfEmail.text;
                [GGAlert alert:@"Email changed OK!"];
                [self naviBackAction:nil];
            }
        }];
    }
}

@end
