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
#import "GGGroupedCell.h"

@interface GGConfigAgentFiltersVC ()
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation GGConfigAgentFiltersVC
{
    //GGConfigSwitchCell *_configSwitchCell;
    
    NSMutableArray      *_customAgentFilters;
    NSMutableArray      *_predefinedAgentFilters;
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
    self.naviTitle = @"Agent Filters";
    self.view.backgroundColor = GGSharedColor.silver;
    self.tv.backgroundColor = GGSharedColor.silver;
    _tv.rowHeight = [GGGroupedCell HEIGHT];
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Edit" target:self selector:@selector(editCustomAgentAction:)];
    
//    _configSwitchCell = [GGConfigSwitchCell viewFromNibWithOwner:self];
//    _configSwitchCell.viewContent.btnSwitch.lblOn.text = @"On";
//    _configSwitchCell.viewContent.btnSwitch.lblOff.text = @"Off";
//    _configSwitchCell.viewContent.btnSwitch.isOn = YES;
//    _configSwitchCell.viewContent.btnSwitch.delegate = self;
    
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
//    if (_configSwitchCell.viewContent.btnSwitch.isOn) {
//        return 3;
//    }
//    
//    return 1;
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_configSwitchCell.viewContent.btnSwitch.isOn) {
//        
//        if (section == 0) {
//            return 1;
//        } else if (section == 1) {
//            return _customAgentFilters.count;
//        } else if (section == 2) {
//            return _predefinedAgentFilters.count;
//        }
//    }
//    
//    return 1;
    
    if (section == 0) {
        return _customAgentFilters.count;
    } else if (section == 1) {
        return _predefinedAgentFilters.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
    }
    
    if (section == 0)
    {
        GGAgentFilter *data = _customAgentFilters[row];
        cell.lblTitle.text = data.name;
        cell.checked = data.checked;
        
        cell.style = [GGUtils styleForArrayCount:_customAgentFilters.count atIndex:row];
    }
    else if (section == 1)
    {
        GGAgentFilter *data = _predefinedAgentFilters[row];
        cell.lblTitle.text = data.name;
        cell.checked = data.checked;
        
        cell.style = [GGUtils styleForArrayCount:_predefinedAgentFilters.count atIndex:row];
    }
    
    cell.tag = row;
    
    return cell;

//    /////////
//        if (section == 0) {
//        
//        static NSString *cellID = @"customAgentCellID";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        
//        GGAgentFilter *data = _customAgentFilters[row];
//        cell.textLabel.text = data.name;
//        
//        cell.accessoryType = (data.checked) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
//        
//        return cell;
//        
//    } else if (section == 1) {
//        
//        static NSString *cellID = @"predefinedAgentCellID";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        
//        GGAgentFilter *data = _predefinedAgentFilters[row];
//        cell.textLabel.text = data.name;
//        
//        cell.accessoryType = (data.checked) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
//        
//        return cell;
//    }
//    
//    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //int row = indexPath.row;
//    int section = indexPath.section;
//    
////    if (section == 0) {
////        
////        return [GGConfigSwitchCell HEIGHT];
////        
////    } else
//    
//        if (section == 0) {
//        
//        return 44.f;
//        
//    } else if (section == 1) {
//        
//        return 44.f;
//    }
//    
//    return 0.f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        
//        return 0.f;
//        
//    } else
    
        if (section == 0) {
        
        return [GGConfigLabel HEIGHT];
        
    } else if (section == 1) {
        
        return [GGConfigLabel HEIGHT];
    }
    
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    GGConfigLabel *head;
    if (section == 0)
    {
        head = [GGConfigLabel viewFromNibWithOwner:self];
        head.lblText.text = @"CUSTOM AGENTS";
        
    } else if (section == 1)
    {
        head = [GGConfigLabel viewFromNibWithOwner:self];
        head.lblText.text = @"PREDEFINED AGENTS";
    }
    
    return head;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
////    if (!_configSwitchCell.viewContent.btnSwitch.isOn && section == 0)
////    {
//        GGConfigLabel *head = [GGConfigLabel viewFromNibWithOwner:self];
//        head.lblText.text = @"Filter your update feed by agents.";
//        return head;
//    //}
//    
//    //return nil;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section = indexPath.section;
    int row = indexPath.row;
    
    //if (section != 0)
    {
        GGAgentFilter *filter = (section == 0) ? _customAgentFilters[row] : _predefinedAgentFilters[row];
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
-(void)switchButton:(GGSwitchButton *)aSwitchButton isOn:(BOOL)aIsOn
{
//    [self showLoadingHUD];
//    id op = [GGSharedAPI setAgentFilterEnabled:aIsOn callback:^(id operation, id aResultObject, NSError *anError) {
//        [self hideLoadingHUD];
//        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//        if (parser.isOK)
//        {
//            [self _callApiGetConfigOptions];
//        }
//        
//        [_tv reloadData];
//        
//    }];
//    
//    [self registerOperation:op];
}

@end
