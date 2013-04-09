//
//  GGSelectAgentsVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSelectAgentsVC.h"

@interface GGSelectAgentsVC ()
@property (weak, nonatomic) IBOutlet UITableView *viewTable;
@property (weak, nonatomic) IBOutlet UIButton *btnAddCustomAgent;
@property (weak, nonatomic) IBOutlet UIView *viewSetupLower;
@property (weak, nonatomic) IBOutlet UIView *viewSetupUpper;
@property (weak, nonatomic) IBOutlet UIButton *btnNextStep;

@end

@implementation GGSelectAgentsVC

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *predefinedCellId = @"predefinedCellId";
    //static NSString *customCellId = @"customCellId";
    //NSString *cellId = (indexPath.section == 0) ? customCellId
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:predefinedCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:predefinedCellId];
    }
    
    cell.textLabel.text = @"aaaa";
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"bbb";
}


@end
