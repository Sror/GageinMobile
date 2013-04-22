//
//  GGComOverviewDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComOverviewDetailVC.h"
#import "GGCompanyDetailHeaderView.h"
#import "GGCompany.h"

#import "GGComOverviewAboutCell.h"

typedef enum
{
    kGGSectionAbout = 0
    , kGGSectionProfile
    , kGGSectionStock
    , kGGSectionRevenues
    , kGGSectionSubsidaries
    , kGGSectionDivisions
    , kGGSectionContact
    
    , kGGSectionCount
}EGGSection;

@interface GGComOverviewDetailVC ()

@end

@implementation GGComOverviewDetailVC
{
    UITableView     *_tv;
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
	
    _tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tv.backgroundColor = GGSharedColor.silver;
    _tv.dataSource = self;
    _tv.delegate = self;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tv];
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kGGSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kGGSectionAbout) {
        return 1;
    } else if (section == kGGSectionProfile) {
        return 1;
    } else if (section == kGGSectionStock) {
        return 1;
    } else if (section == kGGSectionRevenues) {
        return 1;
    } else if (section == kGGSectionSubsidaries) {
        return 1;
    } else if (section == kGGSectionDivisions) {
        return 1;
    }  else if (section == kGGSectionContact) {
        return 1;
    }
    
    return 0;
}

-(GGComOverviewAboutCell *)_tvCellAbout
{
    GGComOverviewAboutCell * cell;
    if (!cell)
    {
        cell = [GGComOverviewAboutCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textView.text = _overview.description;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    if (section == kGGSectionAbout) {
        
        GGComOverviewAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGComOverviewAboutCell"];
        if (!cell)
        {
            cell = [self _tvCellAbout];
        }
        
        return cell;
        
    } else if (section == kGGSectionProfile) {

    } else if (section == kGGSectionStock) {

    } else if (section == kGGSectionRevenues) {

    } else if (section == kGGSectionSubsidaries) {

    } else if (section == kGGSectionDivisions) {

    }  else if (section == kGGSectionContact) {

    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    if (section == kGGSectionAbout) {
        
    } else if (section == kGGSectionProfile) {
        
    } else if (section == kGGSectionStock) {
        
    } else if (section == kGGSectionRevenues) {
        
    } else if (section == kGGSectionSubsidaries) {
        
    } else if (section == kGGSectionDivisions) {
        
    }  else if (section == kGGSectionContact) {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    if (section == kGGSectionAbout) {
        
        return [self _tvCellAbout].height;
        
    } else if (section == kGGSectionProfile) {
        
    } else if (section == kGGSectionStock) {
        
    } else if (section == kGGSectionRevenues) {
        
    } else if (section == kGGSectionSubsidaries) {
        
    } else if (section == kGGSectionDivisions) {
        
    }  else if (section == kGGSectionContact) {
        
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kGGSectionAbout) {
        
    } else if (section == kGGSectionProfile) {
        return 0.f;
    } else if (section == kGGSectionStock) {
        return 0.f;
    } else if (section == kGGSectionRevenues) {
        
    } else if (section == kGGSectionSubsidaries) {
        
    } else if (section == kGGSectionDivisions) {
        
    }  else if (section == kGGSectionContact) {
        
    }
    
    return [GGCompanyDetailHeaderView HEIGHT];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GGCompanyDetailHeaderView *header = [GGCompanyDetailHeaderView viewFromNibWithOwner:self];
    header.lblAction.hidden = YES;
    
    if (section == kGGSectionAbout) {
        header.lblTitle.text = @"ABOUT";//[[NSString stringWithFormat:@"ABOUT %@", _overview.name] uppercaseString];
    } else if (section == kGGSectionProfile) {
        
    } else if (section == kGGSectionStock) {
        
    } else if (section == kGGSectionRevenues) {
        header.lblTitle.text = @"QUARTERLY REVENUES";
    } else if (section == kGGSectionSubsidaries) {
        header.lblTitle.text = @"SUBSIDARIES";
    } else if (section == kGGSectionDivisions) {
        header.lblTitle.text = @"DIVISIONS";
    }  else if (section == kGGSectionContact) {
        header.lblTitle.text = @"CONTACT";
    }
    
    return header;
}

@end
