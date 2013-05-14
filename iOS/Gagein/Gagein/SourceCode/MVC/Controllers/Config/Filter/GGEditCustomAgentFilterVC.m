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
    _tvFilters.editing = YES;
    _tvFilters.layer.cornerRadius = 8;
    
    [self _callApiGetCustomAgentFilters];
}




- (void)viewDidUnload {
    [self setBtnAdd:nil];
    [self setTvFilters:nil];
    [super viewDidUnload];
}


#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _customAgentFilters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    int row = indexPath.row;
    
    GGAgentFilter * filter = _customAgentFilters[row];
    cell.textLabel.text = filter.name;
    cell.tag = row;
    
    return cell;
}


#pragma mark - API calls
-(void)_callApiGetCustomAgentFilters
{
    [GGSharedAPI getAgentFiltersList:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetAgents];
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
