//
//  GGConfigAgentFiltersVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGConfigAgentFiltersVC.h"

#import "GGConfigLabel.h"
#import "GGAgentFilter.h"
#import "GGDataPage.h"
#import "GGEditCustomAgentFilterVC.h"

//#import "GGGroupedCell.h"
#import "GGTriggerChartCell.h"
#import "GGConfigSwitchView.h"

@interface GGConfigAgentFiltersVC ()
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation GGConfigAgentFiltersVC
{
    //GGConfigSwitchCell *_configSwitchCell;
    
    NSMutableArray      *_customAgentFilters;
    NSMutableArray      *_predefinedAgentFilters;
    
    GGConfigSwitchView  *_viewSwitch;
    UITableViewCell     *_headerView;
}

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
    _customAgentFilters = [NSMutableArray array];
    _predefinedAgentFilters = [NSMutableArray array];
    
    [super viewDidLoad];
    self.naviTitle = @"Trigger Filters";
    self.view.backgroundColor = GGSharedColor.silver;
    self.tv.backgroundColor = GGSharedColor.silver;
    //_tv.rowHeight = [GGTriggerChartCell HEIGHT];
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Edit" target:self selector:@selector(editCustomAgentAction:)];
    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(naviBackAction:)];
    
    //
    [self _createSwitchView];
    
    // at last
    [self _callApiGetConfigOptions];
}

#pragma mark -
-(void)editCustomAgentAction:(id)sender
{
    GGEditCustomAgentFilterVC *vc = [[GGEditCustomAgentFilterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
//        return _headerView.frame.size.height;
//    }

    return [GGTriggerChartCell HEIGHT];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    } else if (section == 1) {
//        return _predefinedAgentFilters.count;
//    }
//    
//    return 0;
    
    return _predefinedAgentFilters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
//    if (section == 0)
//    {
//        return _headerView;
//    }
    
    static NSString *cellID = @"GGTriggerChartCell";
    GGTriggerChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGTriggerChartCell viewFromNibWithOwner:self];
    }
    
    GGAgentFilter *data = _predefinedAgentFilters[row];
    cell.lblTitle.text = data.name;
    [cell setChecked:data.checked];
    float percent = (arc4random() % 100) / 100.f;
    [cell setPercentage:percent];
    
    cell.style = [GGUtils styleForArrayCount:_predefinedAgentFilters.count atIndex:row];

    
    cell.tag = row;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section = indexPath.section;
    int row = indexPath.row;
    
    //if (section != 0)
    {
        GGAgentFilter *filter = _predefinedAgentFilters[row];
        id op = [GGSharedAPI selectAgentFilterWithID:filter.ID selected:!filter.checked callback:^(id operation, id aResultObject, NSError *anError) {
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
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    //UIView *header = _viewSwitch.superview;
//    return _headerView;
//}
//
//-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//   // UIView *header = _viewSwitch.superview;
//    return _headerView.frame.size.height;
//}

- (void)viewDidUnload {
    [self setTv:nil];
    [super viewDidUnload];
}

#pragma mark - 
-(void)_callApiGetConfigOptions
{
    [self showLoadingHUD];
    
    id op = [GGSharedAPI getAgentFiltersList:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetAgentFiltersList];
        
        [_customAgentFilters removeAllObjects];
        [_predefinedAgentFilters removeAllObjects];
        
        for (GGAgentFilter *agentFilter in page.items)
        {
            if (agentFilter.type == kGGAgentTypeCustom)
            {
                [_customAgentFilters addObject:agentFilter];
            }
            else if (agentFilter.type == kGGAgentTypePredefined)
            {
                [_predefinedAgentFilters addObject:agentFilter];
            }
        }
        
        [_tv reloadData];
    }];
    
    [self registerOperation:op];
}

#pragma mark - GGSwitchButtonDelegate
-(void)_createSwitchView
{
    _viewSwitch = [GGConfigSwitchView viewFromNibWithOwner:self];
    
    _viewSwitch.backgroundColor = GGSharedColor.white;
    _viewSwitch.lblTitle.text = @"Trigger Chart";
    _viewSwitch.btnSwitch.isOn = YES;
    _viewSwitch.btnSwitch.lblOn.text = @"Likes";
    _viewSwitch.btnSwitch.lblOff.text = @"Clicks";
    _viewSwitch.btnSwitch.delegate = self;
    [GGUtils applyTableStyle1ToView:_viewSwitch];
    
    CGRect containerRc = CGRectMake(0, 0, _tv.frame.size.width, _viewSwitch.frame.size.height + 30);
    _headerView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _headerView.frame = containerRc;
    //_headerView.contentView.backgroundColor = GGSharedColor.darkGray;
    _headerView.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //[[UIView alloc] initWithFrame:containerRc];
    //_headerView.backgroundColor = GGSharedColor.darkGray; // useless
    float switchWidth = 290.f;
    _viewSwitch.frame = CGRectMake((containerRc.size.width - switchWidth) / 2
                                   , (containerRc.size.height - _viewSwitch.frame.size.height) / 2
                                   , switchWidth
                                   , _viewSwitch.frame.size.height);
    //_viewSwitch.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_headerView.contentView addSubview:_viewSwitch];
}

-(void)switchButton:(GGSwitchButton *)aSwitchButton isOn:(BOOL)aIsOn
{
    DLog(@"switch tapped:%d", aIsOn);
}

#pragma mark - orientation change
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
//    CGRect headerRc = _viewSwitch.frame;
//    headerRc.size.width = self.view.frame.size.width;
//    _viewSwitch.frame = headerRc;
    
    float width = _headerView.contentView.frame.size.width - 30;
    [_viewSwitch centerMeHorizontallyChangeMyWidth:width];
}

@end
