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
    
    NSMutableArray      *_topAgents;
    BOOL                _isSelectionChanged;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _topAgents = [NSMutableArray array];
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
    _tv.showsVerticalScrollIndicator = NO;
    
    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(doneAction:)];
    
    //
    [self _createSwitchView];
    
    // at last
    [self _callApiGetConfigOptions];
}


#pragma mark - internal
-(NSArray *)_selectedAgentIDs
{
    NSMutableArray *selectedAgentIDs = [NSMutableArray array];
    
    for (GGAgent *agent in _predefinedAgentFilters) {
        if (agent.checked) {
            [selectedAgentIDs addObject:[NSNumber numberWithLongLong:agent.ID]];
        }
    }
    
    return selectedAgentIDs;
}

-(IBAction)doneAction:(id)sender
{
    if (!_isSelectionChanged)
    {
        [self naviBackAction:nil];
        return;
    }
    
    id op = [GGSharedAPI selectAgents:[self _selectedAgentIDs] callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            //[GGAlert alertWithMessage:@"Succeeded!"];
            [self postNotification:GG_NOTIFY_TRIGGER_CHANGED];
        }
        else
        {
            [GGAlert alertWithApiParser:parser];
        }
        
        [self naviBackAction:nil];
    }];
    
    [self registerOperation:op];
    
}

#pragma mark -
-(void)editCustomAgentAction:(id)sender
{
    GGEditCustomAgentFilterVC *vc = [[GGEditCustomAgentFilterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 2;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //_headerView.backgroundColor = GGSharedColor.darkRed;
        //tableView.backgroundColor = GGSharedColor.random;
        return _headerView.frame.size.height;
    }

    return [GGTriggerChartCell HEIGHT];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _predefinedAgentFilters.count;
    }
    
    return 0;
    
    //return _predefinedAgentFilters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == 0)
    {
        return _headerView;
    }
    
    static NSString *cellID = @"GGTriggerChartCell";
    GGTriggerChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGTriggerChartCell viewFromNibWithOwner:self];
    }
    
    GGAgentFilter *data = _predefinedAgentFilters[row];
    cell.lblTitle.text = data.name;
    [cell setChecked:data.checked];
    //float percent = (arc4random() % 100) / 100.f;
    
    BOOL isHot = ([_topAgents indexOfObject:data] != NSNotFound);
    
    if (data.hasBeenAnimated)
    {
        [cell setPercentage:data.chartPercentage isHot:isHot];
    }
    else
    {
        [cell setPercentage:0.f isHot:isHot];
        [cell setPercentage:data.chartPercentage isHot:isHot animated:YES];
        data.hasBeenAnimated = YES;
    }
    
    cell.style = [GGUtils styleForArrayCount:_predefinedAgentFilters.count atIndex:row];

    
    cell.tag = row;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section = indexPath.section;
    int row = indexPath.row;
    
    if (section != 0)
    {
        _isSelectionChanged = YES;
        GGAgentFilter *filter = _predefinedAgentFilters[row];
        
        filter.checked = !filter.checked;
        [_tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
//        id op = [GGSharedAPI selectAgentFilterWithID:filter.ID selected:!filter.checked callback:^(id operation, id aResultObject, NSError *anError) {
//            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//            if (parser.isOK)
//            {
//                //succeeded
//                filter.checked = !filter.checked;
//                [_tv reloadData];
//            }
//        }];
//        
//        [self registerOperation:op];
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
            //agentFilter.chartPercentage = (arc4random() % 100) / 100.f;
            if (agentFilter.type == kGGAgentTypeCustom)
            {
                [_customAgentFilters addObject:agentFilter];
            }
            else if (agentFilter.type == kGGAgentTypePredefined)
            {
                [_predefinedAgentFilters addObject:agentFilter];
            }
        }
        
        // if chart is enabled, sort agents order by chart percentage desc
        if (page.chartEnabled)
        {
            [_predefinedAgentFilters sortUsingComparator:^NSComparisonResult(GGAgentFilter *obj1, GGAgentFilter *obj2) {
                if (obj1.chartPercentage > obj2.chartPercentage)
                {
                    return NSOrderedAscending;
                }
                else if (obj1.chartPercentage < obj2.chartPercentage)
                {
                    return NSOrderedDescending;
                }
                
                return NSOrderedSame;
            }];
        }
        
        //
        int count = _predefinedAgentFilters.count;
        float topCount = count > 5 ? 5 : count;
        for (int i = 0; i < topCount; i++)
        {
            [_topAgents addObject:(_predefinedAgentFilters[i])];
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
    _viewSwitch.lblTitle.text = @"Relevance";
    
    EGGCompanyUpdateRelevance relevance = GGSharedRuntimeData.relevance;
    _viewSwitch.btnSwitch.isOn = (relevance == kGGCompanyUpdateRelevanceHigh);
    _viewSwitch.btnSwitch.lblOn.text = @"High";
    _viewSwitch.btnSwitch.lblOff.text = @"Medium";
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
    [GGSharedRuntimeData setRelevance:aIsOn ? kGGCompanyUpdateRelevanceHigh : kGGCompanyUpdateRelevanceNormal];
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
