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
#import "GGSelectFuncAreasVC.h"
#import "GGCustomAgentVC.h"

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
    BOOL            _isSelectionChanged;
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
    self.view.backgroundColor = GGSharedColor.veryLightGray;
    self.title = @"Start Your Gagein";
    self.navigationItem.hidesBackButton = YES;
    
    
    if (!_isFromRegistration)
    {
        self.title = @"Choose Agents";
        // add done button
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
        self.navigationItem.rightBarButtonItem = doneBtn;
        
        // hide setup tip
        self.viewSetupLower.hidden = self.viewSetupUpper.hidden = YES;
        
        // addjust layout
        self.btnAddCustomAgent.frame = [GGUtils setY:20 rect:self.btnAddCustomAgent.frame];
        self.viewTable.frame = [GGUtils setH:self.view.frame.size.height - 60 rect:[GGUtils setY:60 rect:self.viewTable.frame]];
    }
    
    [self _getAgentsData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackButton];
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

#pragma mark - internal
-(NSArray *)_selectedAgentIDs
{
    NSMutableArray *selectedAgentIDs = [NSMutableArray array];
    
    for (GGAgent *agent in _predefinedAgents) {
        if (agent.checked) {
            [selectedAgentIDs addObject:[NSNumber numberWithLongLong:agent.ID]];
        }
    }
    
    for (GGAgent *agent in _customAgents) {
        if (agent.checked) {
            [selectedAgentIDs addObject:[NSNumber numberWithLongLong:agent.ID]];
        }
    }
    
    return selectedAgentIDs;
}

#pragma mark - actions
-(IBAction)nextStepAction:(id)sender
{
    [GGSharedAPI selectAgents:[self _selectedAgentIDs] callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            // go to functional areas setting
            GGSelectFuncAreasVC *vc = [[GGSelectFuncAreasVC alloc] init];
            vc.isFromRegistration = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

-(IBAction)doneAction:(id)sender
{
    if (!_isSelectionChanged)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [GGSharedAPI selectAgents:[self _selectedAgentIDs] callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            [GGAlert alert:@"Succeeded!"];
        }
        else
        {
            [GGAlert alert:parser.message];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(IBAction)addCustomAgentAction:(id)sender
{
    GGCustomAgentVC *vc = [[GGCustomAgentVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    // save the agents silently...
    NSArray *selectedAgentIDs = [self _selectedAgentIDs];
    if (selectedAgentIDs.count) {
        [GGSharedAPI selectAgents:selectedAgentIDs callback:^(id operation, id aResultObject, NSError *anError) {
        }];
    }
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

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGAgent *agent = nil;
    if (_customAgents.count && indexPath.section == 0)
    {
        agent = [_customAgents objectAtIndex:indexPath.row];
    }
    else
    {
        agent = [_predefinedAgents objectAtIndex:indexPath.row];
    }
    
    agent.checked = !agent.checked;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    _isSelectionChanged = YES;
    self.btnNextStep.hidden = ([self _selectedAgentIDs].count <= 0);
}

#pragma mark - API calls
-(void)_getAgentsData
{
    [GGSharedAPI getAgents:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.status == 1)
        {
           GGDataPage *page = [parser parseGetAgents];
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
