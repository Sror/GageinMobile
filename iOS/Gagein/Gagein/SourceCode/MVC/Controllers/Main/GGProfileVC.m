//
//  GGProfileVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileVC.h"
#import "GGProfileHeaderView.h"
#import "GGProfileFooterView.h"

@interface GGProfileVC ()
@property (weak, nonatomic) IBOutlet UITableView *tvProfile;

@end

@implementation GGProfileVC
{
    GGProfileHeaderView *_viewHeader;
    GGProfileFooterView *_viewFooter;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Profile";
        self.tabBarItem.image = [UIImage imageNamed:@"Players"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"My Profile";
    self.tvProfile.backgroundColor = GGSharedColor.silver;
    
    _viewHeader = [GGProfileHeaderView viewFromNibWithOwner:self];
    _viewFooter = [GGProfileFooterView viewFromNibWithOwner:self];
    
    [self _callApiGetMyOverview];
}

- (void)viewDidUnload {
    [self setTvProfile:nil];
    [super viewDidUnload];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.detailTextLabel.text = @"";
    
    int row = indexPath.row;
    //int section = indexPath.section;
    
    if (row == 0) {
        
        cell.textLabel.text = @"Name";
        cell.detailTextLabel.text = @"Bill Gates";
        
    } else if (row == 1) {
        
        cell.textLabel.text = @"Email";
        cell.detailTextLabel.text = @"send@bill.mail";
        
    } else if (row == 2) {
        
        cell.textLabel.text = @"Company";
        cell.detailTextLabel.text = @"Microsoft";
        
    } else if (row == 3) {
        
        cell.textLabel.text = @"Job Title";
        cell.detailTextLabel.text = @"former CEO";
        
    } else if (row == 4) {
        
        cell.textLabel.text = @"Time Zone";
        cell.detailTextLabel.text = @"UTC-12";
        
    }
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [GGProfileHeaderView HEIGHT];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [GGProfileFooterView HEIGHT];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _viewHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _viewFooter;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = indexPath.row;
    if (row == 0) {
        
        //@"Name";
        
    } else if (row == 1) {
        
        //@"Email";
        
    } else if (row == 2) {
        
        //@"Company";
        
    } else if (row == 3) {
        
        //@"Job Title";
        
    } else if (row == 4) {
        
        //@"Time Zone";
        
    }
}

#pragma mark - api
-(void)_callApiGetMyOverview
{
    [GGSharedAPI getMyOverview:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
    }];
}

@end
