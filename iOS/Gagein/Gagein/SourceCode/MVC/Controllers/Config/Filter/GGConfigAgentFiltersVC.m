//
//  GGConfigAgentFiltersVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGConfigAgentFiltersVC.h"
#import "GGConfigSwitchCell.h"
#import "GGConfigLabel.h"
#import "GGAgentFilter.h"

@interface GGConfigAgentFiltersVC ()
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation GGConfigAgentFiltersVC
{
    NSMutableArray  *_customAgents;
    //GGAgentFiltersGroup  *_predefinedAgentFilterGroup;
    GGConfigSwitchCell *_configSwitchCell;
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
    [super viewDidLoad];
    self.naviTitle = @"Agent Filters";
    self.tv.backgroundColor = GGSharedColor.silver;
    
    _configSwitchCell = [GGConfigSwitchCell viewFromNibWithOwner:self];
    _configSwitchCell.btnSwitch.isOn = YES;
    
    // at last
    [self _callApiGetConfigOptions];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_configSwitchCell.btnSwitch.isOn) {
        return 3;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_configSwitchCell.btnSwitch.isOn) {
        
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            return _customAgents.count;
        } else if (section == 2) {
            //return _predefinedAgentFilterGroup.options.count;
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == 0) {
        
        return _configSwitchCell;
        
    } else if (section == 1) {
        
        static NSString *cellID = @"customAgentCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = _customAgents[row];
        
        return cell;
        
    } else if (section == 2) {
        
        static NSString *cellID = @"predefinedAgentCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        GGAgentFilter *data = nil;//_predefinedAgentFilterGroup.options[row];
        cell.textLabel.text = data.name;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == 0) {
        
        return [GGConfigSwitchCell HEIGHT];
        
    } else if (section == 1) {
        
        return 44.f;
        
    } else if (section == 2) {
        
        return 44.f;
    }
    
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.f;
        
    } else if (section == 1) {
        
        return 44.f;
        
    } else if (section == 2) {
        
        return 44.f;
    }
    
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    GGConfigLabel *head;
    if (section == 1)
    {
        head = [GGConfigLabel viewFromNibWithOwner:self];
        head.lblText.text = @"CUSTOM AGENTS";
        
    } else if (section == 2)
    {
        head = [GGConfigLabel viewFromNibWithOwner:self];
        head.lblText.text = @"PREDEFINED AGENTS";
    }
    
    return head;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)viewDidUnload {
    [self setTv:nil];
    [super viewDidUnload];
}

#pragma mark - 
-(void)_callApiGetConfigOptions
{
    [self showLoadingHUD];
//    [GGSharedAPI getConfigFilterOptions:^(id operation, id aResultObject, NSError *anError) {
//        [self hideLoadingHUD];
//        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
//        NSMutableArray *arr = [parser parseGetConfigFilterOptions];
//        _predefinedAgentFilterGroup = arr[0];
//        [self.tv reloadData];
//    }];
}
@end
