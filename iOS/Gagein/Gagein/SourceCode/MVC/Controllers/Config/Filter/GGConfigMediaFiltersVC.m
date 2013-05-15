//
//  GGConfigMediaFiltersVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGConfigMediaFiltersVC.h"
#import "GGConfigSwitchView.h"
#import "GGConfigLabel.h"

@interface GGConfigMediaFiltersVC ()
@property (weak, nonatomic) IBOutlet GGConfigSwitchView *viewConfigSwitch;
@property (weak, nonatomic) IBOutlet GGConfigLabel *lblConfigOffTip;
@property (weak, nonatomic) IBOutlet UIView *viewConfigOn;
@property (weak, nonatomic) IBOutlet UIButton *btnAddSource;
@property (weak, nonatomic) IBOutlet UIView *viewTvBg;
@property (weak, nonatomic) IBOutlet UITableView *tvMediaSources;

@end

@implementation GGConfigMediaFiltersVC
{
    NSMutableArray      *_mediaSources;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _mediaSources = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"Media Filters";
    self.view.backgroundColor = GGSharedColor.silver;
    
    _viewConfigSwitch = [GGUtils replaceFromNibForView:_viewConfigSwitch];
    
    _viewConfigSwitch.backgroundColor = GGSharedColor.white;
    _viewConfigSwitch.lblTitle.text = @"Media Filters";
    _viewConfigSwitch.btnSwitch.isOn = YES;
    _viewConfigSwitch.btnSwitch.lblOn.text = @"On";
    _viewConfigSwitch.btnSwitch.lblOff.text = @"Off";
    _viewConfigSwitch.btnSwitch.delegate = self;
    [GGUtils applyTableStyle1ToLayer:_viewConfigSwitch.layer];
    
    _tvMediaSources.layer.cornerRadius = 8;
    [GGUtils applyTableStyle1ToLayer:_viewTvBg.layer];
    
    [_lblConfigOffTip removeFromSuperview];
    _lblConfigOffTip = [GGConfigLabel viewFromNibWithOwner:self];
    _lblConfigOffTip.backgroundColor = GGSharedColor.silver;
    _lblConfigOffTip.lblText.text = @"Filter your update feed by sources.";
    CGRect configOffRc = _lblConfigOffTip.frame;
    configOffRc.origin.y = _viewConfigOn.frame.origin.y;
    _lblConfigOffTip.frame = configOffRc;
    [self.view addSubview:_lblConfigOffTip];
    
    _lblConfigOffTip.hidden = _viewConfigSwitch.btnSwitch.isOn;
    _viewConfigOn.hidden = !_lblConfigOffTip.hidden;
    
    [_btnAddSource setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
}


- (void)viewDidUnload {
    [self setViewConfigSwitch:nil];
    [self setLblConfigOffTip:nil];
    [self setViewConfigOn:nil];
    [self setBtnAddSource:nil];
    [self setViewTvBg:nil];
    [self setTvMediaSources:nil];
    [super viewDidUnload];
}


#pragma mark - switch button delegate
-(void)switchButton:(GGSwitchButton *)aSwitchButton isOn:(BOOL)aIsOn
{
    [self showLoadingHUD];
    [GGSharedAPI setMediaFilterEnabled:aIsOn callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _viewConfigOn.hidden = !aIsOn;
            _lblConfigOffTip.hidden = aIsOn;
        }
        
    }];
}

@end
