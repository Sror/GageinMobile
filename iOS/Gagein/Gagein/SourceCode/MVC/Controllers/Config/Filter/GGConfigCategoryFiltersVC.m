//
//  GGConfigCategoryFiltersVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGConfigCategoryFiltersVC.h"
#import "GGConfigSwitchView.h"
#import "GGCategoryFilter.h"
#import "GGDataPage.h"
#import "GGConfigLabel.h"
#import "GGGroupedCell.h"

@interface GGConfigCategoryFiltersVC ()
//@property (weak, nonatomic) IBOutlet GGConfigSwitchCell *cellConfigSwitch;
//@property (weak, nonatomic) IBOutlet GGConfigSwitchView *viewConfigSwitch;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIView *viewTvContainer;

@end

@implementation GGConfigCategoryFiltersVC
{
    NSMutableArray      *_filters;
    //GGConfigLabel       *_configOffTipView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _filters = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"Category Filters";
    self.view.backgroundColor = GGSharedColor.silver;
    _tv.backgroundColor = GGSharedColor.clear;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tv.rowHeight = [GGGroupedCell HEIGHT];
    
//    _viewConfigSwitch = [GGUtils replaceFromNibForView:_viewConfigSwitch];
//    
//    _viewConfigSwitch.backgroundColor = GGSharedColor.white;
//    _viewConfigSwitch.lblTitle.text = @"Category Filters";
//    _viewConfigSwitch.btnSwitch.isOn = YES;
//    _viewConfigSwitch.btnSwitch.lblOn.text = @"On";
//    _viewConfigSwitch.btnSwitch.lblOff.text = @"Off";
//    _viewConfigSwitch.btnSwitch.delegate = self;
//    [GGUtils applyTableStyle1ToView:_viewConfigSwitch];
    
//    _tv.layer.cornerRadius = 8;
//    [GGUtils applyTableStyle1ToView:_viewTvContainer];
    
//    _configOffTipView = [GGConfigLabel viewFromNibWithOwner:self];
//    _configOffTipView.lblText.text = @"Filter your update feed by agents.";
//    CGRect configOffRc = _configOffTipView.frame;
//    configOffRc.origin.y = _viewTvContainer.frame.origin.y;
//    _configOffTipView.frame = configOffRc;
//    [self.view addSubview:_configOffTipView];
//    _configOffTipView.hidden = _viewConfigSwitch.btnSwitch.isOn;
    
    [self _callApiGetConfigOptions];
}

- (void)viewDidUnload {
    //[self setViewConfigSwitch:nil];
    [self setTv:nil];
    [self setViewTvContainer:nil];
    [super viewDidUnload];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = _filters.count;
//    CGRect tvRc = _viewTvContainer.frame;
//    tvRc.size.height = 44 * count;
//    _viewTvContainer.frame = tvRc;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int row = indexPath.row;
//   // int section = indexPath.section;
//    
//    static NSString *cellID = @"cellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
    
    int row = indexPath.row;
    //int section = indexPath.section;
    
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
    }
    
    GGCategoryFilter *data = _filters[row];
    cell.lblTitle.text = data.name;
    cell.checked = data.checked;
    
    cell.style = [GGUtils styleForArrayCount:_filters.count atIndex:row];
    //cell.accessoryType = (data.checked) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //int section = indexPath.section;
    int row = indexPath.row;
    
    GGCategoryFilter *filter = _filters[row];
    id op = [GGSharedAPI selectCategoryFilterWithID:filter.ID selected:!filter.checked callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            //succeeded
            filter.checked = !filter.checked;
            [_tv reloadData];
        }
    }];
    
    [self registerOperation:op];
}

#pragma mark - switch button delegate
-(void)switchButton:(GGSwitchButton *)aSwitchButton isOn:(BOOL)aIsOn
{
//    [self showLoadingHUD];
//    id op = [GGSharedAPI setCategoryFilterEnabled:aIsOn callback:^(id operation, id aResultObject, NSError *anError) {
//        [self hideLoadingHUD];
//        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//        if (parser.isOK)
//        {
//            _tv.hidden = !aIsOn;
//            //_configOffTipView.hidden = aIsOn;
//            [self _callApiGetConfigOptions];
//        }
//        
//    }];
//    
//    [self registerOperation:op];
}


#pragma mark - 
-(void)_callApiGetConfigOptions
{
    [self showLoadingHUD];
    
    id op = [GGSharedAPI getCategoryFiltersList:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCategoryFiltersList];
        
        [_filters removeAllObjects];
        
        for (GGCategoryFilter *filter in page.items)
        {
            [_filters addObject:filter];
        }
        
        [_tv reloadData];
    }];
    
    [self registerOperation:op];
}

@end
