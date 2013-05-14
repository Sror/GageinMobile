//
//  GGEditCustomAgentFilterVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-10.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGEditCustomAgentFilterVC.h"
#import "GGAgentFilter.h"
#import "GGAgent.h"
#import "GGDataPage.h"
#import "GGEditStyleCell.h"
#import "GGCustomAgentVC.h"

@interface GGEditCustomAgentFilterVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UITableView *tvFilters;

@end

@implementation GGEditCustomAgentFilterVC
{
    NSMutableArray      *_customAgentFilters;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _customAgentFilters = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"Edit Agent Filters";
    self.view.backgroundColor = GGSharedColor.silver;
    
    [self.btnAdd setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
    [self.btnAdd addTarget:self action:@selector(addCustomAgentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _tvFilters.editing = YES;
    _tvFilters.layer.cornerRadius = 8;
    _tvFilters.rowHeight = [GGEditStyleCell HEIGHT];
    
    [self _callApiGetCustomAgentFilters];
}

-(void)viewWillAppearNotFirstTimeAction
{
    [self _callApiGetCustomAgentFilters];
}


- (void)viewDidUnload {
    [self setBtnAdd:nil];
    [self setTvFilters:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(void)editFilterAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    GGAgentFilter * filter = _customAgentFilters[btn.tag];
    DLog(@"Edit filter: %@", filter.name);
    
    GGCustomAgentVC *vc = [[GGCustomAgentVC alloc] init];
    
    vc.agent = [filter agent];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addCustomAgentAction:(id)sender
{
    GGCustomAgentVC *vc = [[GGCustomAgentVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)deleteAction:(id)sender
{
    
}


#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _customAgentFilters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //GGEditStyleCell
    static NSString *cellID = @"cellID";
    GGEditStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [GGEditStyleCell viewFromNibWithOwner:self];
        [cell.btnEdit addTarget:self action:@selector(editFilterAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int row = indexPath.row;
    
    GGAgentFilter * filter = _customAgentFilters[row];
    cell.lblTitle.text = filter.name;
    cell.btnEdit.tag = row;
    cell.tag = row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        GGAgentFilter * filter = _customAgentFilters[row];
        [self showLoadingHUD];
        [GGSharedAPI deleteCustomAgentWithID:filter.ID callback:^(id operation, id aResultObject, NSError *anError) {
            [self hideLoadingHUD];
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [_customAgentFilters removeObject:filter];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}


#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //int row = indexPath.row;
    
    //GGAgentFilter * filter = _customAgentFilters[row];
    //DLog(@"Edit filter: %@", filter.name);
}



#pragma mark - API calls
-(void)_callApiGetCustomAgentFilters
{
    [self showLoadingHUD];
    [GGSharedAPI getAgentFiltersList:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetAgentFiltersList];
            [_customAgentFilters removeAllObjects];

            for (GGAgentFilter *agent in page.items) {
                if (agent.type == kGGAgentTypeCustom)
                {
                    [_customAgentFilters addObject:agent];
                }
            }
            
            [self.tvFilters reloadData];
        }
        
    }];
}



@end
