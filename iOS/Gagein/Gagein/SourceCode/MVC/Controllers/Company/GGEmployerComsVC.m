//
//  GGEmployerComsVC.m
//  Gagein
//
//  Created by Dong Yiming on 6/28/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGEmployerComsVC.h"

#import "GGCustomBriefCell.h"
#import "GGCompany.h"
#import "GGCompanyDetailVC.h"

@interface GGEmployerComsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation GGEmployerComsVC

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
   
    self.view.backgroundColor = GGSharedColor.silver;
    
    self.naviTitle = @"Previous Companies";
    
    _tv.rowHeight = [GGCustomBriefCell HEIGHT];
    _tv.backgroundColor = GGSharedColor.silver;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tv.showsVerticalScrollIndicator = NO;
    
    [self addScrollToHide:_tv];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.companies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *updateCellId = @"GGPersonCell";
    GGCustomBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGCustomBriefCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGCompany *data = [self.companies objectAtIndexSafe:indexPath.row];
    
    cell.lblName.text = data.name;
    cell.lblTitle.text = data.website;
    cell.lblAddress.text = data.address;
    [cell.ivPhoto setImageWithURL:[NSURL URLWithString:data.logoPath] placeholderImage:GGSharedImagePool.placeholder];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGCompany *data = _companies[indexPath.row];
    GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
    vc.companyID = data.ID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_tv centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH_FULL];
}

@end
