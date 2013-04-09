//
//  GGSelectAgentsVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSelectAgentsVC.h"
#import "GGDataPage.h"
#import "GGAgent.h"

@interface GGSelectAgentsVC ()
@property (weak, nonatomic) IBOutlet UITableView *viewTable;
@property (weak, nonatomic) IBOutlet UIButton *btnAddCustomAgent;
@property (weak, nonatomic) IBOutlet UIView *viewSetupLower;
@property (weak, nonatomic) IBOutlet UIView *viewSetupUpper;
@property (weak, nonatomic) IBOutlet UIButton *btnNextStep;

@end

@implementation GGSelectAgentsVC
{
    NSMutableArray *_predefinedAgents;
    NSMutableArray *_customAgents;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _predefinedAgents = [NSMutableArray array];
        _customAgents = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _getAgentsData];
}



- (void)viewDidUnload {
    [self setViewTable:nil];
    [self setBtnAddCustomAgent:nil];
    [self setViewSetupLower:nil];
    [self setViewSetupUpper:nil];
    [self setBtnNextStep:nil];
    [super viewDidUnload];
}


#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_customAgents.count)
    {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_customAgents.count && section == 0)
    {
        return _customAgents.count;
    }
    
    return _predefinedAgents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *predefinedCellId = @"predefinedCellId";
    static NSString *customCellId = @"customCellId";
    UITableViewCell* cell = nil;
    
    BOOL isCustomCell = (_customAgents.count && indexPath.section == 0);
    
    if (!isCustomCell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:predefinedCellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:predefinedCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGAgent *agentData = [_predefinedAgents objectAtIndex:indexPath.row];
        cell.textLabel.text = agentData.name;
        cell.accessoryType = agentData.checked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:customCellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:customCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGAgent *agentData = [_customAgents objectAtIndex:indexPath.row];
    cell.textLabel.text = agentData.name;
    cell.detailTextLabel.text = agentData.keywords;
    cell.accessoryType = agentData.checked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_customAgents.count && section == 0)
    {
        return @"CUSTOM AGENTS";
    }
    
    return @"PREDEFINED AGENTS";
}

#pragma mark - API calls
-(void)_getAgentsData
{
    [GGSharedAPI getMyAgentsList:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.status == 1)
        {
           GGDataPage *page = [parser parseGetMyAgents];
            [_predefinedAgents removeAllObjects];
            [_customAgents removeAllObjects];
            for (GGAgent *agent in page.items) {
                if (agent.type == kGGAgentTypePredefined)
                {
                    [_predefinedAgents addObject:agent];
                }
                else
                {
                    [_customAgents addObject:agent];
                }
            }
            
            [self.viewTable reloadData];
        }
        
    }];
}

@end
