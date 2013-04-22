//
//  GGComOverviewDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-22.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGComOverviewDetailVC.h"
#import "GGWebVC.h"
#import "GGCompanyDetailHeaderView.h"
#import "GGCompany.h"
#import "GGTicker.h"

#import "GGComOverviewAboutCell.h"
#import "GGComOverviewProfileCell.h"
#import "GGComOverviewStockCell.h"
#import "GGComOverviewRevenuesCell.h"

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
    self.navigationItem.title = @"Overview";
	
    _tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tv.backgroundColor = GGSharedColor.silver;
    _tv.dataSource = self;
    _tv.delegate = self;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tv];
}

#pragma mark - actions
-(IBAction)_seeStockAction:(id)sender
{
    if (_overview.tickerSymbols.count)
    {
        GGTicker *ticker = _overview.tickerSymbols[0];
        if (ticker.url.length)
        {
            GGWebVC *vc = [[GGWebVC alloc] init];
            vc.urlStr = ticker.url;
            vc.navigationItem.title = ticker.name;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - table view cells
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

-(GGComOverviewProfileCell *)_tvCellProfile
{
    GGComOverviewProfileCell * cell;
    if (!cell)
    {
        cell = [GGComOverviewProfileCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.lblFounded.text = _overview.founded;
    cell.lblIndustry.text = _overview.industries;
    cell.lblSpeciality.text = _overview.specialities;
    cell.lblEmployees.text = _overview.employeeSize;
    cell.lblRevenue.text = _overview.revenueSize;
    cell.lblFortuneRank.text = _overview.fortuneRank;
    cell.lblFiscalYear.text = _overview.fiscalYear;
    
    return cell;
}

-(GGComOverviewStockCell *)_tvCellStock
{
    GGComOverviewStockCell * cell;
    if (!cell)
    {
        cell = [GGComOverviewStockCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.lblOwnership.text = _overview.ownership;
    if (_overview.tickerSymbols.count)
    {
        GGTicker *ticker = _overview.tickerSymbols[0];
        NSArray *stockStings = [ticker.name componentsSeparatedByString:@": "];
        if (stockStings.count == 2)
        {
            cell.lblStockChange.text = stockStings[0];
            cell.lblStockSymbol.text = stockStings[1];
        }
        
        [cell.btnStock addTarget:self action:@selector(_seeStockAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(GGComOverviewRevenuesCell *)_tvCellRevernues
{
    GGComOverviewRevenuesCell * cell;
    if (!cell)
    {
        cell = [GGComOverviewRevenuesCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.ivChart setImageWithURL:[NSURL URLWithString:_overview.revenuesChartUrl] placeholderImage:nil];
    
    return cell;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    //int row = indexPath.row;
    
    if (section == kGGSectionAbout) {
        
        return [self _tvCellAbout];
        
    } else if (section == kGGSectionProfile) {
        
        return [self _tvCellProfile];
        
    } else if (section == kGGSectionStock) {

        return [self _tvCellStock];
        
    } else if (section == kGGSectionRevenues) {
        
        return [self _tvCellRevernues];

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
    //int row = indexPath.row;
    
    if (section == kGGSectionAbout) {
        
    } else if (section == kGGSectionProfile) {
        
    } else if (section == kGGSectionStock) {
        
    } else if (section == kGGSectionRevenues) {
        
        if (_overview.revenuesChartUrl)
        {
            GGWebVC *vc = [[GGWebVC alloc] init];
            vc.urlStr = _overview.revenuesChartUrl;
            vc.navigationItem.title = @"Chart";
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
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
        
        return [self _tvCellProfile].height;
        
    } else if (section == kGGSectionStock) {
        
        return [self _tvCellStock].height;
        
    } else if (section == kGGSectionRevenues) {
        
        return [self _tvCellRevernues].height;
        
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
