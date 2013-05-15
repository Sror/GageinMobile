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
#import "GGMediaFilter.h"
#import "GGDataPage.h"
#import "GGAddMediaFiltersVC.h"

#define TV_HEIGHT       314

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
    //CGRect              _tvOriginalRc;
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
    _tvMediaSources.editing = YES;
    //_tvOriginalRc = _viewTvBg.frame;
    
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
    
    // add source button
    [_btnAddSource setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
    [_btnAddSource addTarget:self action:@selector(addSourcesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self _callApiGetMediaFilterList];
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

#pragma mark - actions
-(IBAction)addSourcesAction:(id)sender
{
    GGAddMediaFiltersVC *vc = [[GGAddMediaFiltersVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = _mediaSources.count;
    CGRect tvRc = _viewTvBg.frame;
 
    tvRc.size.height = MIN(TV_HEIGHT, 44 * count);
    
    _viewTvBg.frame = tvRc;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    // int section = indexPath.section;
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    GGMediaFilter *data = _mediaSources[row];
    cell.textLabel.text = data.name;
    
    //cell.accessoryType = (data.checked) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        GGMediaFilter *filter = _mediaSources[row];
        [self showLoadingHUD];
        [GGSharedAPI deleteMediaFilterWithID:filter.ID callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [_mediaSources removeObject:filter];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
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

#pragma mark - 
-(void)_callApiGetMediaFilterList
{
    [self showLoadingHUD];
    
    [GGSharedAPI getMediaFiltersList:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetMediaFiltersList];
        
        [_mediaSources removeAllObjects];
        
        for (GGMediaFilter *filter in page.items)
        {
            [_mediaSources addObject:filter];
        }
        
        [_tvMediaSources reloadData];
    }];
}

@end
