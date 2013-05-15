//
//  GGConfigFiltersVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGConfigFiltersVC.h"
#import "GGConfigLabel.h"

#import "GGConfigAgentFiltersVC.h"
#import "GGConfigCategoryFiltersVC.h"
#import "GGConfigMediaFiltersVC.h"
//#import "GGCustomAgentVC.h"

@interface GGConfigFiltersVC ()
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation GGConfigFiltersVC
{
    NSMutableArray  *_dataSource;
    GGConfigLabel   *_configHeadLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray arrayWithObjects:@"Agent Filters", @"Category Filters", @"Media Filters", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"Configure Filters";
    self.tv.backgroundColor = GGSharedColor.silver;
    
    _configHeadLabel = [GGConfigLabel viewFromNibWithOwner:self];
    _configHeadLabel.lblText.text = @"Personalize your company update streams";
    
    self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(doneAction:)];
    //[self hideBackButton];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackButton];
}

-(void)doneAction:(id)sender
{
    [self naviBackAction:sender];
}




- (void)viewDidUnload {
    [self setTv:nil];
    [super viewDidUnload];
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [GGConfigLabel HEIGHT];
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    return _configHeadLabel;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = indexPath.row;
    if (row == 0) {
        
        GGConfigAgentFiltersVC *vc = [[GGConfigAgentFiltersVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 1) {
        // category filters
        GGConfigCategoryFiltersVC *vc = [[GGConfigCategoryFiltersVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (row == 2) {
        // media filters
        GGConfigMediaFiltersVC *vc = [[GGConfigMediaFiltersVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

@end
